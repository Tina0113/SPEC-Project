close all, clear all, clc, format compact

hAddress = '..//Training//Healthy//';
u1Address = '..//Training//Faulty//Unbalance 1//';
u2Address = '..//Training//Faulty//Unbalance 2//';
tAddress = '..//Testing//';

healthy = dir([hAddress, '*.txt']);
unbalance1 = dir([u1Address, '*.txt']);
unbalance2 = dir([u2Address, '*.txt']);
testShaft = dir([tAddress, '*.txt']);

fs = 2560
hSize = size(healthy)
tSize = size(testShaft)

hData = [];
u1Data = [];
u2Data = [];
tData = [];

for k = 1:hSize(1)
    hSignal = importdata([hAddress, healthy(k).name]);
    u1Signal = importdata([u1Address, unbalance1(k).name]);
    u2Signal = importdata([u2Address, unbalance2(k).name]);
    hData = [hData hSignal.data];
    u1Data = [u1Data u1Signal.data];
    u2Data = [u2Data u2Signal.data];
end

for i = 1:tSize(1)
    signal = importdata([tAddress, testShaft(i).name]);
    tData = [tData signal.data];
end

hNData = normalize(hData, 'norm', 1);
u1NData = normalize(u1Data, 'norm', 1);
u2NData = normalize(u2Data, 'norm', 1);
tNData = normalize(tData, 'norm', 1);

% visualize
for i = 1:1
    tCombine = strcat('combine ', int2str(i));
%     show_fft(hNData(:, i), u1NData(:, i), u2NData(:, i), tCombine, fs);
end

fNData = horzcat(u1NData, u2NData);

%% get top priority
[x, yH, yF, topIndex] = getTopPriorSet(hNData, fNData, 3);
size(yF / 2)
labelAssign = categorical([ones(size(yH,1),1)*0; ones(size(yF,1) / 2,1)*1; ones(size(yF,1) / 2,1)*2]);

%% split data
splitData = [yH ;yF]; %60*3 data combine after feature extraction  
cv = cvpartition(size(splitData,1),'HoldOut',0.3);% split 70% train 30% test
idx = cv.test;
% Separate to training and test data
dataTrain = splitData(~idx,:);
dataTest  = splitData(idx,:);
labelTrain = labelAssign(~idx,:);
labelTest = labelAssign(idx,:);

data=[dataTrain];
labels=[labelTrain];

%% start training logistic regression 
[model ,dev,stats] = mnrfit(dataTrain, labelTrain);
% model
pihat = mnrval(model,dataTest)
[M, mIdx] = max(pihat');
result = mIdx' - 1

%% SOM
% number of samples of each cluster
K = 20;

P=[splitData]
% % offset of classes
% q = 1.1;
% % define 4 clusters of input data
% P = [rand(1,K)-q rand(1,K)+q rand(1,K)+q;
%      rand(1,K)+q rand(1,K)+q rand(1,K)-q];
% define 3 clusters of input data


% plot clusters
plot(P(1,:),P(2,:),'k*')
hold on
grid on
%%

% SOM parameters`
dimensions   = [10 10];
coverSteps   = 100;
initNeighbor = 4;
topologyFcn  = 'hextop';
distanceFcn  = 'linkdist';

% define net
net = selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn);
plotsomtop(net)

%%
% train
[net,Y] = train(net,P);

%%
% plot input data and SOM weight positions
plotsomtop(net)
plotsompos(net,P);
grid on

% plot SOM neighbor distances
plotsomnd(net)

% plot for each SOM neuron the number of input vectors that it classifies
figure
plotsomhits(net,P)