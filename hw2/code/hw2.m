hAddress = '..//Training//Healthy//';
fAddress = '..//Training//Faulty//';
tAddress = '..//Testing//';

healthy = dir([hAddress, '*.txt']);
faulty = dir([fAddress, '*.txt']);
testShaft = dir([tAddress, '*.txt']);

fs = 2560
hSize = size(healthy)
tSize = size(testShaft)

hData=[];
fData =[];
tData = [];

for k = 1:hSize(1)
    hSignal = importdata([hAddress, healthy(k).name]);
    fSignal = importdata([fAddress, faulty(k).name]);
    hData = [hData hSignal.data];
    fData = [fData fSignal.data];
end

for i = 1:tSize(1)
    signal = importdata([tAddress, testShaft(i).name]);
    tData = [tData signal.data];
end

hNData = normalize(hData, 'norm', 1);
fNData = normalize(fData, 'norm', 1);
tNData = normalize(tData, 'norm', 1);

% visualize
for i = 1:2
    hti = strcat("Healthy ", int2str(i));
    fti = strcat("Faulty ", int2str(i));
    tCombine = strcat('combine ', int2str(i));
    bind_fft(hNData(:, i), fNData(:, i), tCombine);
end

%% get top priority
[x, yH, yF, topIndex] = getTopPriorSet(hNData, fNData, 3);
labels = [ones(size(yH,1),1)*0.95; ones(size(yF,1),1)*0.05];

%% split data
data = [yH ;yF];%40*3 data combine after feature extraction  
cv = cvpartition(size(data,1),'HoldOut',0.3);% split 70% train 30% test
idx = cv.test;
% Separate to training and test data
dataTrain = data(~idx,:);
dataTest  = data(idx,:);
labelTrain = labels(~idx,:);
labelTest = labels(idx,:);

data=[dataTrain]
labels=[labelTrain]
%% start training logistic regression 
model = glmfit(dataTrain, labelTrain,'binomial');
CV_Test = glmval(model, dataTest, 'logit') ;  %Use LR Model

%% Cross validation
accuracy = [zeros(4,1)]
indices = crossvalind('Kfold',labels,4);
for i = 1:4
    test = (indices == i); 
    train = ~test;
    dataTrain(test,:)
    labelTrain(test,:)
    relabel = labels(test,:) > 0.5
    [b,dev,stats] = glmfit(data(train,:),labels(train),'binomial','logit'); % Logistic regression
    yhat=glmval(b,data(test,:), 'logit' );
    class_Healthy=yhat > 0.5;
    acc = (relabel == class_Healthy)
    accuracy(i) = sum(acc)/ size(acc,1) 
end
accuracy_per = (sum(accuracy)/ size(accuracy,1))*100
fprintf('Accuracy = %d %% \n', accuracy_per)

%% ploting
figure;
x = linspace(0,10,12);

plot(x,labelTest, 'r')
title('Predicition result numerical');

hold on

plot(x, CV_Test, 'b')

legend('real label','prediction label')

hold off

%% convert to discrete domain
predResult(CV_Test < 0.5) = 0;
predResult(CV_Test >= 0.5) = 1;

realResult(labelTest < 0.5) = 0;
realResult(labelTest >= 0.5) = 1;

figure;
x = linspace(0,10,12);

plot(x,realResult, 'r')
title('Predicition result logical');

hold on

plot(x, predResult, 'b')

legend('real label','prediction label')

hold off

% predResult = predResult.';
% realResult = realResult.';

%% Confusion matrix 
% figure; 
plotconfusion(realResult, predResult) 
 
%% ROC  
[X,Y,T,AUC] = perfcurve(realResult, CV_Test, 1); 
 
AUC 
figure; 
plot(X,Y, 'LineWidth',8) 
xlabel('False positive rate')  
ylabel('True positive rate') 
title('ROC for Classification by Logistic Regression') 
 
%% Run testing data by model 
tSize = size(tNData);
testArr = [];
for i = 1:tSize(2)
    [xTest, fftTP1] = self_fft(tNData(:, i), fs);
    testArr = [testArr fftTP1];        
end

testTop = testArr(topIndex, :).'; 
realTest = glmval(model, testTop, 'logit');  %Use LR Model 

figure
x = linspace(0, 30, 30);
plot(x, realTest, 'r')
title('Prediction result numberical in testing result');
