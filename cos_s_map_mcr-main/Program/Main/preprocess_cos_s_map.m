% Pre-processing of cos-s map MCR

%% Data & Parameters load
load('AnalysisData.mat')
load('CalcPara_preprocess.mat')
%% RawData
RawData = AnalysisData.y;
x = AnalysisData.x;
CorrData = RawData;
%% Background Correction
% parameter
WindowSize = CalcPara_preprocess.BackCorr.WindowSize;
StepSize = CalcPara_preprocess.BackCorr.StepSize;
QuantileValue = CalcPara_preprocess.BackCorr.QuantileValue; % defalt 0.10

RegressionMethod = CalcPara_preprocess.BackCorr.RegressionMethod; %  'pchip' (default) | 'linear''spline'
EstimationMethod = CalcPara_preprocess.BackCorr.EstimationMethod; % 'quantile' (default) | 'em'
SmoothMethod = CalcPara_preprocess.BackCorr.SmoothMethod; %   'none' (default) | 'lowess' | 'loess' | 'rlowess' | 'rloess'

% Background correction
[BackCorrData] = msbackadj(x,RawData,'WindowSize',WindowSize,'StepSize',StepSize,.....
    'RegressionMethod',RegressionMethod,'EstimationMethod', EstimationMethod,....
    'QuantileValue',QuantileValue,'SmoothMethod',SmoothMethod);

% remove Nan(not a number)to avoid error
nan_idx = logical(sum(isnan(BackCorrData),2));
BackCorrData(nan_idx) = [];
x(nan_idx) = [];
CorrData = BackCorrData;

% Figure of subtraction
figure(3);
plot(x,BackCorrData)
hold on 
plot(x,zeros(length(x),1),'k')
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)
hold off


%% Discriminaiton ofisobestics points
% if there are isobestics points, random numbers must be multiplied 
% Plz skip/comment out this section if there is no isobetics point.

NumSamples = size(CorrData,2);
RandNumState = rng(5); % For deback
RandomNum = (rand(1,NumSamples)+.5); % random numbers
CorrData = RandomNum.* CorrData; % random numbers multiplication
%Figure
figure(4)
plot(x,CorrData)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)


%% icoshift (peak alignment)
% parameter
SplitInterval = CalcPara_preprocess.icoshift.SplitInterval;
ShiftMethod = CalcPara_preprocess.icoshift.ShiftMethod; %'average'
% peak alignment by icoshift
[AlignedData] = icoshift(ShiftMethod,CorrData',SplitInterval);

% figure of peak alignment
figure(5)
plot(x,AlignedData)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)


%% Convolution by gaussian
% parameter
conv_para.func_size = CalcPara_preprocess.conv_para.func_size; % size of kernel function
conv_para.sigma = CalcPara_preprocess.conv_para.sigma; % width of kernel
conv_para.center = CalcPara_preprocess.conv_para.center; % center of kernel
conv_para.graph = CalcPara_preprocess.conv_para.graph; % if on, graph of kernel is presented.

% convolution
t = 0:1:conv_para.func_size;
func_kernel = (1 / sqrt(2 * pi * conv_para.sigma ^ 2)) * (exp((- (t - conv_para.center) .^ 2 ) / (2 * conv_para.sigma ^2))); % gaussian


for i = 1:size(AlignedData,1)
    conv_data(:,i) = conv(AlignedData(i,:),func_kernel,'same');
end

% Figure of convolution
figure(6)
plot(x,conv_data)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)


%% Discrimination of no signal region and division of spectrum into key peak region
% parameter
PeakSeprateMethod = CalcPara_preprocess.Peak_Region.PeakSeprateMethod;
Min_PeakEdgeInt = CalcPara_preprocess.Peak_Region.PeakEdgeInt;
Min_PeakDist = CalcPara_preprocess.Peak_Region.PeakDist;
PeakEdge = CalcPara_preprocess.Peak_Region.PeakEdge; 

% Figure for decision of peak region edge
ref_spectrum2divide = mean(conv_data,2);
figure(7)
plot(x,ref_spectrum2divide)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)
hold on
plot(x,Min_PeakEdgeInt*ones(length(x),1))
hold off




if  PeakSeprateMethod == "Auto"
    PeakEdge = [];
    peak_idx = ref_spectrum2divide > Min_PeakEdgeInt;
    peak_idx_re = [0;peak_idx;0];
    peak_edge_idx = (diff(peak_idx_re,2)) == - 1;
    peak_edge = x(peak_edge_idx);
    PeakEdge = (reshape(peak_edge,[2,sum(peak_edge_idx)/2]))';
    peak_dist = abs(PeakEdge(:,2) - PeakEdge(:,1));
    PeakEdge((peak_dist < Min_PeakDist),:) = [];
    
end
   

x_PeakRegion = cell(size(PeakEdge,1),1);
y_PeakRegion = cell(size(PeakEdge,1),1);
for i = 1:size(PeakEdge,1)
    x_PeakRegion_idx = PeakEdge(i,1) <= x & x <= PeakEdge(i,2);
    x_PeakRegion{i,1} = x(x_PeakRegion_idx);
    y_PeakRegion{i,1} = conv_data(x_PeakRegion_idx,:);
end

PreprocessedData.x = cell2mat(x_PeakRegion);
PreprocessedData.y = cell2mat(y_PeakRegion);
PreprocessedData.PeakEdge = PeakEdge;
PreprocessedData.func_kernel = func_kernel;

figure(8)
plot(PreprocessedData.x,PreprocessedData.y)
xlabel(AnalysisData.xlabel)
ylabel(AnalysisData.ylabel)

    






















