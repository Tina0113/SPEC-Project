function [topIndex, fisher_score] = getTopPriorSetBin(x1, x2, topK, xLocation)    
    meanDiff = (mean(x1, 2) - mean(x2, 2)).^2;
    varSum = var(x1,0,2) + var(x2,0,2);
    fisher_score = meanDiff ./ varSum;
    
    %% ploting
    fSize = size(fisher_score)
%     ja = 8
%     fisher_score(ja)
%     xLocation(ja)
    fish_x = linspace(0, 30, 30);
     
%     figure;
%     disp('test')
%     size(xLocation)
%     size(fisher_score)
%     plot(xLocation(1:30), fisher_score(1:30), 'r')
%     title('Fisher criterion of each feature');
%     xlabel('Hz')
%     ylabel('Score')

    %% 
    [out,idx] = sort(fisher_score, 'descend');
    topIndex = idx(1:topK, 1);
    disp(strcat('top-', topK, 'idx:'));
    disp(idx(1:topK, 1));
    disp(strcat('top-', topK, 'value:'));
    disp(out(1:topK, 1));
    disp(strcat('top-', topK, 'frequeny:'));
    disp(xLocation(topIndex));
    xLocation(22)
    fisher_score(22)
    tmp = [x1 x2];
    size(tmp)
    y = tmp(topIndex, :).';
    
%     xLocation(topIndex)
    
    
end