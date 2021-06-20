%  optimization with constratints for cos-s map MCR
% Scheme 1(b) and Scheme 2

%% Data & Parameters load
load('AnalysisData.mat')
load('PreprocessedData.mat')
load('Iniest.mat')
load('CalcPara_ALS.mat')

%% Initial estimation & Augemented data (scheme1 (b))
% Initial estimation
x = InitialEstimation.x;
inispec = InitialEstimation.spec;

% Data augmentation
 % parameter and Data
Data = PreprocessedData.y;
NumSpec = size(Data,2);
AugAmp = CalcPara_ALS.DataAug.amp;
NumAugData = CalcPara_ALS.DataAug.NumData ;

% Set random number 

AugData = Data;

for i = 1:NumAugData - NumSpec
    
    AddData(:) = 0;
    RandNumState_DataAug = rng(i);
    coefficient = rand(NumSpec,1);
    for j = 1:NumSpec
        AddData = AddData + Data(:,j) * coefficient(j);
    end
    
    AddData = AugAmp * AddData / (NumSpec);
    AugData = [AugData AddData];
    
end
    

%%  Determination of weight matrix based on initial estimation (scheme 2)


    %% Select the species with highest ratio at j-th wavlength and labeled
    u = (InitialEstimation.u)';
    L = zeros(size(u,1),size(u,2));
    [~,idx_u_max] = max(u,[],2);
    for j = 1:size(u,1)
        for k =1:size(u,2)
            
            if k == idx_u_max(j,1)
                L(j,k) = 1;
            end
        end
    end
     
    %%  Count the number of k-th label in each peak
    % divide the L into peak regions
    PeakEdge = PreprocessedData.PeakEdge;
    NumRegion = size(PeakEdge,1);
    NumComp = size(u,2);
    
    N = zeros(NumRegion,NumComp);
    P = zeros(NumRegion,NumComp);
    
    for r = 1:NumRegion
       L_region = L(PeakEdge(r,1) <= x & x <= PeakEdge(r,2),:); % Divde L into each peak region 
       N(r,:) = sum(L_region,1);
       P(r,:) = N(r,:) ./ sum(N(r,:),2);
       
    end
    
    %% Ratio of k-th label (weight matrix)
    
    % Parameter
    Ratio_kth_label = CalcPara_ALS.WeightMatrix_Ratio_kth_label;
    
    weight_region = ones(NumRegion,NumComp);
    weight_region(P < Ratio_kth_label) = 0.2;
    
    
    WeightMatrix = L; 
    
    for r = 1:NumRegion
        Weight_tmp = WeightMatrix(PeakEdge(r,1) <= x & x <= PeakEdge(r,2),:);
        WeightMatrix(PeakEdge(r,1) <= x & x <= PeakEdge(r,2),:) = repmat(weight_region(r,:),length(Weight_tmp),1);
                
    end
    
    WeightMatrix = WeightMatrix';
    
%% ALS optmization with constraitns determined by initial estimation
% parameters
NumIterDivergence = CalcPara_ALS.Opt.Weight.NumIterDivergence;
Area_Constraints = CalcPara_ALS.Opt.Weight.Area_Constraints;
LOF = CalcPara_ALS.Opt.LOF_criterion;
% ALS optimization with additional constraints
alsOptimization_cos_s_map;


%% Deconvolution 
% Parameter 
DeconvMethod = CalcPara_ALS.Deconvolution.Method;
DeconvKernel = PreprocessedData.func_kernel;
DeconvDamp = CalcPara_ALS.Deconvolution.damp;
DeconvNoiseSignralRatio = CalcPara_ALS.Deconvolution.NoiseSignralRatio;

x_part = InitialEstimation.x;
X_All = AnalysisData.x;
PeakRegions = zeros(length(X_All),1);

for r = 1:NumRegion
    PeakRegions_new = (PeakEdge(r,1) <= X_All & X_All <= PeakEdge(r,2));
    PeakRegions = PeakRegions + PeakRegions_new;
end
PeakRegions = logical(PeakRegions);
% ExcludedRegions = logical(1 - PeakRegions);

PaddingSpec_ini = zeros(NumComp,length(X_All));
PaddingSpec_ini(:,PeakRegions) = inispec(1:end-1,:);

PaddingSpec_sopt = zeros(NumComp,length(X_All));
PaddingSpec_sopt(:,PeakRegions) = sopt(1:end-1,:);


sopt_deconv = PaddingSpec_sopt;
% figure;plot(X_All,sopt_deconv);figure;plot(x_part,sopt)
inispec_deconv = PaddingSpec_ini;
% figure;plot(X_All,inispec_deconv);figure;plot(x_part,inispec)

for i =1:NumComp
    if DeconvMethod == "deconvblind"
        sopt_deconv(i,:) = deconvblind(PaddingSpec_sopt(i,:),DeconvKernel,[],DeconvDamp);
        inispec_deconv(i,:) = deconvblind(PaddingSpec_ini(i,:),DeconvKernel,[],DeconvDamp);
        
    elseif DeconvMethod == "deconvlucy"
        sopt_deconv(i,:) = deconvlucy(PaddingSpec_sopt(i,:),DeconvKernel);
        inispec_deconv(i,:) = deconvlucy(PaddingSpec_ini(i,:),DeconvKernel);
        
    elseif DeconvMethod == "deconvreg"
        sopt_deconv(i,:) = deconvreg(PaddingSpec_sopt(i,:),DeconvKernel);
        inispec_deconv(i,:) = deconvreg(PaddingSpec_ini(i,:),DeconvKernel);
        
    elseif DeconvMethod == "deconvwnr"
        
        sopt_deconv(i,:) = deconvwnr(PaddingSpec_sopt(i,:),DeconvKernel,DeconvNoiseSignralRatio);
        inispec_deconv(i,:) = deconvwnr(PaddingSpec_ini(i,:),DeconvKernel,DeconvNoiseSignralRatio);
        
    end
          
end


figure(12);
plot(X_All,sopt_deconv)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)



figure(13)
plot(X_All,inispec_deconv)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)
















    
    

    