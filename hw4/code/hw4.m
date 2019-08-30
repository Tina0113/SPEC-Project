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
% labelAssign = ['Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
%     'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
%     'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';
%     'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';
%     'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';
%     'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2']
%% 

% X = [yFFT(1:40,1),yFFT(1:40,3)]
%y = [ones(20,1)*0; ones(20,1)*1]
% Y = {'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
%     'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
%     'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';
%     'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';
%     'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';
%     'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2'}
% Y = {'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
%     'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
%     'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';
%     'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';'Faulty';
%     }
% SVMModel = fitcsvm(X,Y)
% classOrder = SVMModel.ClassNames
% sv = SVMModel.SupportVectors;
% figure
% gscatter(X(:,1),X(:,2),Y)
% hold on
% plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
% legend('Healthy','Faulty','Support Vector')
% hold off

X = [yFFT(:,1),yFFT(:,3)]
Y = {'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
    'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';'Healthy';
    'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';
    'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';'Unbalance 1';
    'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';
    'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2';'Unbalance 2'}
% Mdl = fitcecoc(X,Y)
t = templateSVM('Standardize',true,'SaveSupportVectors',true);
predictorNames = {'21.13Hz','21.2Hz'};
responseName = 'Species';
classNames = {'Healthy','Unbalance 1','Unbalance 2'}; % Specify class order
Mdl = fitcecoc(X,Y,'Learners',t,'ResponseName',responseName,'PredictorNames',predictorNames,'ClassNames',classNames)
% Mdl.ClassNames
% Mdl.CodingMatrix
L = size(Mdl.CodingMatrix,2); % Number of SVMs
sv = cell(L,1); % Preallocate for support vector indices
for j = 1:L
    SVM = Mdl.BinaryLearners{j};
    sv{j} = SVM.SupportVectors;
    sv{j} = sv{j}.*SVM.Sigma + SVM.Mu;
end
figure
gscatter(X(:,1),X(:,2),Y);
hold on
markers = {'ko','ro','bo'}; % Should be of length L
for j = 1:L
    svs = sv{j};
    plot(svs(:,1),svs(:,2),markers{j},'MarkerSize',10 + (j - 1)*3);
end

svs = sv(3);

title('Support Vectors Result')
xlabel(predictorNames{1})
ylabel(predictorNames{2})
legend([classNames,{'Support vectors - SVM 1','Support vectors - SVM 2','Support vectors - SVM 3'}],'Location','Best')
hold off







