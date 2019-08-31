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
mergeData = [hNData fNData];
[x, yFFT, topIndex] = getTopPriorSet(mergeData, 3);
labelAssign = categorical([ones(20,1)*0; ones(20,1)*1; ones(20,1)*2]);

%% plot histogram
figure
h1 = histogram(yFFT(1:20, :));
hold on
h2 = histogram(yFFT(21:40, :));

h3 = histogram(yFFT(41:60, :));

title('Feature Distribution');
legend('Healthy', 'Unbalance 1', 'Unbalance 2');

hold off

%% split data

cv = cvpartition(size(yFFT,1),'HoldOut',0.3);% split 70% train 30% test
idx = cv.test;
% Separate to training and test data
dataTrain = yFFT(~idx,:);
dataTest  = yFFT(idx,:);
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
% CV_Test = glmval(model, dataTest, 'logit') ;  %Use LR Model
%% ploting
rs = size(result);
predResult = categorical(result);
figure;
x = linspace(0,rs(1),rs(1));

% plot(x,labelTest, 'r')
% hold on
% 
% plot(x, categorical(result), 'b')
% title('Predicition result logical');
% legend('real label','prediction label')

hold off

%% Confusion matrix 
figure; 
plotconfusion(labelTest, predResult) 
 
%% ROC  
[X,Y,T,AUC] = perfcurve(labelTest, result, 1); 

AUC 
figure; 
plot(X,Y, 'LineWidth',8) 
xlabel('False positive rate')  
ylabel('True positive rate') 
title('ROC for Classification by Logistic Regression') 

%% get top priority 2
[x, y1, y2, y3, topIndex] = getTopPriorSet_1(hNData, u1NData, u2NData, 3);% y1 is p2p, y2 is RMS, y3 is STD
size(yF / 2)
labelAssign = categorical([ones(size(yH,1),1)*0; ones(size(yF,1) / 2,1)*1; ones(size(yF,1) / 2,1)*2]);


%% SOM
% number of samples of each cluster
K = 20;
%define 3 clusters of input data
P=[normalize(splitData(:,1), 'norm', 1).';normalize(splitData(:,2), 'norm', 1).']
% plot clusters
P1=P(1,:)
P2=P(2,:)
plot(P(1,:),P(2,:),'k*')
hold on
grid on
% SOM parameters
dimensions   = [5 5];
coverSteps   = 500;
initNeighbor = 3;
topologyFcn  = 'hextop';
distanceFcn  = 'linkdist';

% define net
net = selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn);
plotsomtop(net)
savefig('plotsomtop_5x5')
% %%
% % train
% [net,Y] = train(net,P);
% %%
% % plot input data and SOM weight positions
% plotsomtop(net)
% plotsompos(net,P);
% savefig('plotsompos_5x5')
% grid on
% % plot SOM neighbor distances
% plotsomnd(net)
% savefig('plotsomnd_5x5')
% % plot SOM Weight Planes
% plotsomplanes(net)
% savefig('plotsomplanes_5x5')
% % plot for each SOM neuron the number of input vectors that it classifies
% figure
% plotsomhits(net,P)
% savefig('plotsomhit_5x5')
% %% find BMU and Calculate MQE
% % net.IW weight matrices of weights going to layers from network inputs
% Weights = net.IW{1,1};
% figure
% plot(P(1,:),P(2,:),'k*')
% hold on
% plot(Weights(:,1),Weights(:,2),'g.')
% % pick one sample
% Sample = P(:,1);
% plot(Sample(1),Sample(2),'r*')
% % find bmu
% Hits = sim(net,Sample);
% L = find(Hits==1);
% BMU = Weights(L,:);
% plot(BMU(1),BMU(2),'ro')
% % MQE
% MQE = norm(BMU'-Sample);
% MQE
% figure
% plotsomhits(net,Sample);
% savefig('plotsomhits_5x5')