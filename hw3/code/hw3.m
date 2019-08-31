close all;
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
%% get top priority 2
%[x, y1, y2, y3, topIndex] = getTopPriorSet_1(hNData, u1NData, u2NData, 3);% y1 is p2p, y2 is RMS, y3 is STD
%labelAssign = categorical([ones(size(yH,1),1)*0; ones(size(yF,1) / 2,1)*1; ones(size(yF,1) / 2,1)*2]);
%% plot histogram
% figure
% h1 = histogram(yFFT(1:20, :));
% hold on
% h2 = histogram(yFFT(21:40, :));
% h3 = histogram(yFFT(41:60, :));
% title('Feature Distribution');
% legend('Healthy', 'Unbalance 1', 'Unbalance 2');
% hold off
%% split data
cv = cvpartition(size(yFFT,1),'HoldOut',0.3);% split 70% train 30% test
idx = cv.test;
% Separate to training and test data
dataTrain = yFFT(~idx,:);
dataTest  = yFFT(idx,:);
labelTrain = labelAssign(~idx,:);
labelTest = labelAssign(idx,:);


%% start training logistic regression 
[model ,dev,stats] = mnrfit(dataTrain, labelTrain);
% model
pihat = mnrval(model,dataTest)
[M, mIdx] = max(pihat');
result = mIdx' - 1
% CV_Test = glmval(model, dataTest, 'logit') ;  %Use LR Model
%% Run testing data by model 
% tSize = size(tNData);
% testArr = [];
% for i = 1:tSize(2)
%     [xTest, fftTP1] = self_fft(tNData(:, i), fs);
%     testArr = [testArr fftTP1];        
% end
% 
% testTop = testArr(topIndex, :).'; 
% % realTest = glmval(model, testTop, 'logit');   
% 
% tmpTest = mnrval(model,testTop) %Use LR Model multiclass
% [M, mIdx] = max(tmpTest');
% realTest = mIdx' - 1

%% plot have not seen testing result
% testLabelAssign = [ones(10,1)*0; ones(10,1); ones(10,1)*2];
% figure
% x = linspace(0, 30, 30);
% %plot(x, testLabelAssign, 'b:s')
% hold on
% 
% %plot(x, realTest, 'r')
% 
% %legend('real label','prediction label')
% %title('Prediction result logical in testing result');
% 
% hold off
%% ploting
% rs = size(result);
% predResult = categorical(result);
% figure;
% x = linspace(0,rs(1),rs(1));
% 
% plot(x,labelTest, 'rs:')
% hold on
% plot(x, categorical(result), 'b')
% 
% title('Predicition result logical');
% legend('real label','prediction label')
% 
% hold off
%% Confusion matrix 
% figure; 
% plotconfusion(labelTest, predResult) 

%% ROC  
[X,Y,T,AUC] = perfcurve(labelTest, result, 1); 
figure; 
plot(X,Y, 'LineWidth',8) 
xlabel('False positive rate')  
ylabel('True positive rate') 
title('ROC for Classification by Logistic Regression') 

%% SOM
P = [yFFT(:,1).';yFFT(:,3).'];% healthy faulty1 and faulty 2 
% plot clusters
plot(P(1,:),P(2,:),'k*')
hold on
grid on
%% SOM parameters
dimensions   = [20 20];
coverSteps   = 100;
initNeighbor = 3;
topologyFcn  = 'hextop';
distanceFcn  = 'linkdist';
% define net
net = selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn);
% plotsomtop(net)
%% train
[net,Y] = train(net,P);
%% plot input data and SOM weight positions
plotsompos(net,P);grid on;
% plot SOM neighbor distances
plotsomnd(net);
% plot for each SOM neuron the number of input vectors that it classifies
figure;plotsomhits(net,P);
%% SOM MQE
%net.IW weight matrices of weights going to layers from network inputs
SOMMQE = P(:,1:20) %healthy in train
plot(SOMMQE(1,:),SOMMQE(2,:),'k*')
hold on;grid on;
MQEnet = selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn);
plotsomtop(net)
%% train
[MQEnet,Y] = train(MQEnet,SOMMQE);
plotsomtop(MQEnet);plotsompos(MQEnet,SOMMQE);
grid on;
% plot SOM neighbor distances
plotsomnd(MQEnet);
% plot for each SOM neuron the number of input vectors that it classifies
%plotsomhits(MQEnet,SOMMQE);
Weights = MQEnet.IW{1,1};
testQME = [testTop(:,1).';testTop(:,3).']
MQE = []
for i= 1:30
    Sample = testQME(:,i) ;
    %find best matching unit(BMU); sim Simulate neural network
    Hits = sim(MQEnet,Sample);
    L = find(Hits==1);% find (=1) position
    BMU = Weights(L,:);
    % MQE; norm() is distance 
    MQEbuffer = norm(BMU'-Sample);
    MQE=[MQE MQEbuffer]
end
figure
plot(MQE,'r')
