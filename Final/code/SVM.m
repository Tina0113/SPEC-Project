function [Accuracy,Testset, mdl] = SVM(dataTrain,dataTest,labelTrain,labelTest,Featurename)   
% Testset is [data,predictlabel]

    %% Training
    mdl = fitcsvm(dataTrain,labelTrain); 
    %Test is data that you want to predict.
    [labelpredict] = predict(mdl,dataTest);
%     table(labelTest,labelpredict,'VariableNames',{'TrueLabel','PredictedLabel'})
    TestSize= size(labelTest)
    Testset = [dataTest,labelpredict,labelTest];
%     Testset
    Accuracy = sum(labelTest==labelpredict)/TestSize(1,1)*100
    Xasix = Featurename(:,1)+" Hz"
    Yasix = Featurename(:,2)+" Hz"
    
    %% plot
    sv = mdl.SupportVectors;
    figure
    gscatter(dataTrain(:,1),dataTrain(:,2),labelTrain)

    xlabel(Xasix)  
    ylabel(Yasix) 
    hold on
    plot(sv(:,1),sv(:,2),'ko','MarkerSize', 5)
    legend('healthy','faulty','Support Vector')
    hold off
    
end
