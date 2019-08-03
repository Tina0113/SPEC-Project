function result = lr_test(test_data, param)

    mu = param.mu;
    TransMatrix = param.TransMatrix;
    STD = param.std;
    
    temp = test_data - repmat(mu,size(test_data,1),1);
%     temp = temp./repmat(STD, size(test_data,1),1);
    
    %tranform data to principal compnent space.
    %be careful normData are row vectors, so do not use TransMatrix * normData
    Test = temp * TransMatrix'; 
    
    %using Matlab built-in function in the statistics toolbox

    result = glmval(param.beta, Test,'logit');