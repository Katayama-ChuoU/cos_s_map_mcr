% initial estimation by cos-s map for MCR

%% Data & Parameters load
load('AnalysisData.mat')
load('PreprocessedData.mat')
load('CalcPara_ini_est.mat')

%% Preprocessed Data
% x is wavelength ,chemical shift, diffraction angle
% S is preprocessed mixture spectra 

x = PreprocessedData.x;
S = PreprocessedData.y;

%% Centering
% Calculate average spectrum
s_average = mean(S,2);

% Take transpose if raw of x and y are not same
if size(s_average,2) == size(x,1)
    S = S';
    s_average = mean(S,2);
end

% check average spectrum 
figure(9)
plot(x,s_average)

% centering
s_centered = S - s_average;

%% Similarity map
% initialization
MapSize = size(s_centered,1);
cos_map = eye(MapSize);

% cosine similarity values
for i = 1:MapSize
    for j = i+1:MapSize
        
        cos_map(i,j) = dot(s_centered(i,:),s_centered(j,:)) / (norm(s_centered(i,:)) * norm(s_centered(j,:)));
        cos_map(j,i) = cos_map(i,j);
        
    end
end

% Figure
figure(10)
image(x,x,cos_map,'CDataMapping','scaled')
% set(gca,'CLim',[-1 1],'Layer','top');
colorbar('peer',gca,'LineWidth',1,'Color',[0 0 0]);
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.xlabel)


%% Fuzy c-mean clustering (FCM)
% Parameter
NumComp = CalcPara_ini_est.FCM.NumComp;
ExpWeight = CalcPara_ini_est.FCM.ExpWeight; % generally, use 2(Fix)

% FCM clustering   ---- a toolbox is necessay to install---
% v....... cluster center
% u....... weight
[v,u] = fcm(cos_map,NumComp,ExpWeight);

%% Initial estimated spectra by cos map and FCM
% initial estimation spectra are obtaied by
% the product of average spectrum and weight (u)

S_est = s_average' .* (u.^ ExpWeight);

% sort the data by max peak of S_est or manually
% FCM can provide answer with different order
% ex. u_1st(:,1) == u_2nd(:,2), u_1st(:,2) == u_2nd(:,1)
% Then sort the order of S_est, u, and v.
SortMethod = CalcPara_ini_est.Sort.Method;
S_est_sort = S_est;
u_sort = u; v_sort = v;


if SortMethod == "Auto"
    % automatic order control by area of initial estimated spectra
    SpecArea = trapz(x,abs(S_est'));
    
    [~,sort_idx] = maxk(SpecArea,size(S_est,1));
    
    
elseif SortMethod == "Manual"
    % sort spectra by peak specific to each component
    % need to define pure peak position
    specific_peak_locs = CalcPara_ini_est.Sort.PeakLocs;
    sort_idx = ones(1,length(specific_peak_locs));
    
    for i = 1:length(specific_peak_locs)
        [~,specific_peak_idx] = min(abs(x - specific_peak_locs(i)));
        [~,sort_idx(1,i)] = max(S_est(:,specific_peak_idx));
    end
    
end

% sort the data of S_est, u and v
for i = 1:length(sort_idx)
    
    S_est_sort(i,:) = S_est(sort_idx(i),:);
    u_sort(i,:) = u(sort_idx(i),:);
    v_sort(i,:) = v(sort_idx(i),:);
    
end

S_est = S_est_sort;
u = u_sort;
v = v_sort;

InitialEstimation.x = x;
InitialEstimation.spec = S_est;
InitialEstimation.cos_map = cos_map;
InitialEstimation.NumComp = NumComp;
InitialEstimation.u = u;
InitialEstimation.v = v;
% Figure
figure(11)
plot(x,S_est)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)
















