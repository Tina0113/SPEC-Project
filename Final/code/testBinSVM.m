function [labelPredict, labelTest] = testBinSVM(data, label)
    %% split training and testing data
    cv = cvpartition(size(inFFT,1),'HoldOut',0.3);% split 70% train 30% test
    idx = cv.test;

    % Separate to training and test data
    dataTrain  = inFFT(~idx,:);
    dataTest   = inFFT(idx,:);
    labelTrain = inLabel(~idx, :);
    labelTest  = inLabel(idx, :);
    [~, inAcc] = SVM(dataTrain, dataTest, labelTrain, labelTest);

end