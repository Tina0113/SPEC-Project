close all;
clear;

Fs = 50000;   % Sampling rate
fr = 800/60;  % Spindle's rotating frequency (in Hz)
BPFO = 7.14*fr;  % outer defect freq.(in Hz)
BPFI = 9.88*fr;  % inner
BFF = 5.824*fr;  % roller
step = 256;

%% load data 
trainingSize = 2048;
testingSize = 512;
filePath = '..//Dataset//';
vStruct = load(strcat(filePath, 'data_train.mat'));
% testStruct = load(strcat(filePath, 'data_test.mat'));
vLabelStruct = load(strcat(filePath, 'data_train_labels.mat'));

% Column decription 1~8192: accelerated value 8193: label
vData = [cell2mat(vStruct.data_train).' vLabelStruct.data_train_labels.'];
% tData = [cell2mat(testStruct.data_test).']
% index = vData(vData(:,end) == 1, :);
% hNData = normalize(hData, 'norm', 1);
% u1NData = normalize(u1Data, 'norm', 1);
% u2NData = normalize(u2Data, 'norm', 1);
% tNData = normalize(tData, 'norm', 1);

%% visualize
% 8 types
showData = [];
for i = 1:8
    tmp = vData(vData(:,end) == i, :);
    showData = [showData; tmp(1, :)];
end
% show_fft(showData, 'combine', Fs);


%% get top priority
% roll
% [x, yFFT, topIndex] = getTopPriorSet(vData, 3, 8);
% yFFT = [yFFT vData(:, end)];
lSize = size(vData);
strLabels = strings([lSize(1), 1]);
errorType = ["normal", "roller", "inner race", "outer race", "inner race & roller", ...
    "inner race & outer race", "outer & inner race & roller", "outer race & roller"];

for i = 1:8    
    strLabels(vData(:, end) == i) = errorType(i);
end
 
% [up,lo]=envelope(vData(256 * 3 + 15, 1:end-1));
% nUp = normalize(up);
% 
% 
% [xUp, yUp] = self_fft(nUp.', Fs);
% 
% figure
% plot(xUp, yUp)
% xlabel('Frequency (Hz)')
% ylabel('Amplitude')
% title('Envelope specturm (outer)')


%% inner
% only reserve normal and other big class data(roller, outer, inner)
[roller, outer, inner] = removeByLabel(vData);
[roX, roF] = transferFFT(roller);
[ouX, ouF] = transferFFT(outer);
[inX, inF] = transferFFT(inner);

[allX, allF] = transferFFT(vData);
% [testX, testF] = transferFFT(tData);
% csvwrite('test_fft',testF)

[roFishIndex, roFishValue]= getTopPriorSetBin(roF(:, 1:step), roF(:, step+1:2*step), 2, roX);
[ouFishIndex, ouFishValue]= getTopPriorSetBin(ouF(:, 1:step), ouF(:, step+1:2*step), 2, ouX);
[inFishIndex, inFishValue]= getTopPriorSetBin(inF(:, 1:step), inF(:, step+1:2*step), 2, inX)

  %% split training and testing data
cv = cvpartition(size(allF,2),'HoldOut',0.3);% split 70% train 30% test
idx = cv.test;

% Separate to training and test data
allLabel = vData(:, end);
dataTrain  = allF(:, ~idx);
dataTest   = allF(:, idx);
labelTrain = allLabel(~idx, :);%1~8
labelTest  = allLabel(idx, :);%1~8
    
% Label = [ones(256,1)*0; ones(1024,1)*1];
roLabel = ones(length(allLabel), 1) * 0;
inLabel = ones(length(allLabel), 1) * 0;
ouLabel = ones(length(allLabel), 1) * 0;

roller = [5,6,7,8];
inner = [3,4,7,8];
outer = [2,4,6,8];

for i = 1:length(allLabel)
    if(allLabel(i) == 5 | allLabel(i) == 6|allLabel(i) == 7|allLabel(i) == 8)
        roLabel(i)=1
    end
    if(allLabel(i) == 3|allLabel(i) == 4|allLabel(i) == 7|allLabel(i) == 8)
        inLabel(i)=1
    end
    if(allLabel(i) == 2|allLabel(i) == 4|allLabel(i) == 6|allLabel(i) == 8)
        ouLabel(i)=1
    end
   
end
% for i = 1:length(allLabel)
%     if(allLabel(i) == 3 | allLabel(i) == 4|allLabel(i) == 6)
%         roLabel(i)=1
%     end
%     if(allLabel(i) == 2|allLabel(i) == 3|allLabel(i) == 5)
%         inLabel(i)=1
%     end
%     if(allLabel(i) == 2|allLabel(i) == 4|allLabel(i) == 8)
%         ouLabel(i)=1
%     end
%    
% end

% rollerRemove = [3, 4, 6];
% outerRemove = [2, 3, 5];
% innerRemove = [2, 4, 8];
% for i = 1:length(rollerRemove)
%     inLabel((innerRemove(i) - 1) * 256 + 1:innerRemove(i) * 256) = 1;
%     ouLabel((outerRemove(i) - 1) * 256 + 1:outerRemove(i) * 256) = 1;
%     roLabel((rollerRemove(i) - 1) * 256 + 1:rollerRemove(i) * 256) = 1;
% end


% inLabel = vData(:, end);
% getTopPriorSet(inF, 3, 5, inX);
% [roX, roFFT, roTopIndex] = getTopPriorSetBin(roller, 3);
% [inFishIndex, inFishValue] = getTopPriorSetBin(inF, 2);

% [x, y, topIndex] = getTopPriorSet(reF, 3, 8, reX); 

roFFT = allF(roFishIndex, :).';
ouFFT = allF(ouFishIndex, :).';
inFFT = allF(inFishIndex, :).';
%% SVM
[ro_accuracy,ro_Test,ro_model] = SVM(roFFT(~idx,:),roFFT(idx,:),roLabel(~idx,:),roLabel(idx,:),allX(roFishIndex));
[in_accuracy,in_Test,in_model] = SVM(inFFT(~idx,:),inFFT(idx,:),inLabel(~idx,:),inLabel(idx,:),allX(inFishIndex));
[ou_accuracy,ou_Test,ou_model] = SVM(ouFFT(~idx,:),ouFFT(idx,:),ouLabel(~idx,:),ouLabel(idx,:),allX(ouFishIndex));


Tablepredict =[ro_Test(:,3),in_Test(:,3),ou_Test(:,3)]
Tablepredictsize= size(Tablepredict)
Tablepredictresult= []
for i = 1:Tablepredictsize(1,1)
        state = Transfer(Tablepredict(i,1),Tablepredict(i,2),Tablepredict(i,3));
        tmp = [ro_Test(i,3) in_Test(i,3) ou_Test(i,3)  state];
        Tablepredictresult = [Tablepredictresult; tmp];
end

% TableTrueresult
% TableTrue =[ro_Test(:,4),in_Test(:,4),ou_Test(:,4);labelTest]
% TableTruesize= size(Tablepredict)
% TableTrueresult= []
% for i = 1:TableTruesize(1,1)
% %         state = Transfer(TableTrue(i,1),TableTrue(i,2),TableTrue(i,3));
%         tmp = [ro_Test(i,4) in_Test(i,4) ou_Test(i,4)  state];
%         TableTrueresult = [TableTrueresult; tmp];
% end
% size(TableTrueresult)
% TableTrueresult
acc=[]
% [Count, True]= Accuracy(TableTrueresult,Tablepredictresult)
[Count, True]= Accuracy(labelTest,Tablepredictresult);
% for i = 1:8
%     if Count(i) == 0
%         tmp = [100]
%         acc = [acc,tmp]
%     else
%         tmp = [True(i)/Count(i)*100]
%         acc = [acc,tmp]
%     end
%     
% end

for i = 1:8
        tmp = [True(i)/Count(i)*100];
        acc = [acc,tmp];
    
end
accur = mean(True ./ Count) * 100
%% plot bar fisher score
% figure
% inFishIndex = [inFishIndex; 4098; 4099; 4100; 23];
% 
% % bar(inFishValue(pIdx))
% tmp = inFishValue([4098; 4099; 4100])
% bar(inFishValue(inFishIndex))
% 
% len = 1:length(inFishValue(inFishIndex));
% % Reduce the size of the axis so that all the labels fit in the figure.
% pos = get(gca,'Position');
% set(gca,'Position',[pos(1), .2, pos(3) .65])
% 
% % Add a title, if you need it.
% %title('')
% 
% % Set X-tick positions
% Xt = len;
% 
% % If you want to set x-axis limit, uncomment the following two lines of 
% % code and remove the third
% %Xl = [1 6]; 
% %set(gca,'XTick',Xt,'XLim',Xl);
% % set(gca,'XTick',Xt);
% % ensure that each string is of the same length, using leading spaces
% 
% algos = ['   61.03 Hz'; '   54.93 Hz'; '   67.13 Hz';
%     '        RMS'; '        P2P'; '        VAR'; '       BPFI'];
% 
% ax = axis; % Current axis limits
% Yl = ax(1:4); % Y-axis limits
% 
% % Remove the default labels
% set(gca,'XTickLabel','')
% 
% % Place the text labels
% t = text(Xt,Yl(1)*ones(1,length(Xt)),algos(len,:));
% set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
% 'Rotation',45, 'Fontsize', 12);
% ylabel('Fisher score', 'Fontsize', 13)
% title('Fisher criterion bar chart (inner)', 'Fontsize', 13)

% %% split training and testing data
% cv = cvpartition(size(inFFT,1),'HoldOut',0.3);% split 70% train 30% test
% idx = cv.test;
% % Separate to training and test data
% dataTrain  = inFFT(~idx,:);
% dataTest   = inFFT(idx,:);
% labelTrain = inLabel(~idx, :);
% labelTest  = inLabel(idx, :);
% 


%% SOM
% SOM parameters
% dimensions   = [20 20];
% coverSteps   = 500;
% initNeighbor = 3;
% topologyFcn  = 'hextop';
% distanceFcn  = 'linkdist';
% 
% % define net
% net = selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn);
% 
% % train
% [net,Y] = train(net, inFFT);
% 
% %% plot SOM
% % plot input data and SOM weight positions
% plotsomtop(net)
% plotsompos(net, inFFT);
% plotsomnd(net, inFFT);
% grid on

