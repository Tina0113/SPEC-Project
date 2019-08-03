function result = lr_train(normal_data, faulty_data, SVD_CuttOff)

    Data = [normal_data;faulty_data];
    % do PCA first
    % remove means
    mu = mean(Data);
    tempData = Data - repmat(mu,size(Data,1),1);
    %normalize variance
    STD = std(tempData, 1);
%     tempData = tempData./repmat(STD, size(Data,1),1);
    
    C = tempData' * tempData/(size(Data,1)-1);
    %the above two lines do the same thing as the following line.
    %C = cov(Data);
    [V,S]=eig(C);
    TotSum=trace(S);
    VHlp=[];
    DHlp=[];
    Sum=0;
    for i=size(Data,2):-1:1
        if Sum<SVD_CuttOff*TotSum
            DHlp = [DHlp S(i,i)];
            VHlp = [VHlp V(:,i)];
            Sum=Sum+S(i,i);
        else
            break;
        end
    end;
    % calculate transformation matrix which lower dimension of Data and
    % unifiy the data. The term diag(DHlp.^(-1/2)) is optional
%     TransMatrix=diag(DHlp.^(-1/2))*transpose(VHlp);
    TransMatrix=transpose(VHlp);
    result.mu = mu;
    result.std = STD;
    result.TransMatrix = TransMatrix;
    
    temp = normal_data - repmat(mu,size(normal_data,1),1);
    %tranform data to principal compnent space.
    %be careful normData are row vectors, so do not use TransMatrix * normData
    Normal = temp * TransMatrix'; 
    num_Normal = size(Normal,1);
    
    temp = faulty_data - repmat(mu,size(faulty_data,1),1);
    %tranform data to principal compnent space.
    %be careful normData are row vectors, so do not use TransMatrix * normData
    Faulty = temp * TransMatrix'; 
    num_Faulty = size(Faulty,1);

    %using Matlab built-in function in the statistics toolbox
    Label = [ones(num_Normal,1)*0.95; ones(num_Faulty, 1)*0.05];
    result.beta = glmfit([Normal;Faulty], Label, 'normal','link','logit');
