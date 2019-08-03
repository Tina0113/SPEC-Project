function [x, y1, y2, topIndex] = getTopPriorSet(x1, x2, topK)
    fs = 2560;
    healthArr = [];
    faultArr = [];
    xSize = size(x1);

    for i = 1:xSize(2)
        [xHealth, fftHP1] = self_fft(x1(:, i), fs);
        healthArr = [healthArr fftHP1];
        
        [xFault, fftFP1] = self_fft(x2(:, i), fs);
        faultArr = [faultArr fftFP1];
    end
    meanDiff = (mean(healthArr, 2) - mean(faultArr, 2)).^2;
    varSum = var(healthArr,0,2) + var(faultArr,0,2);
    score = meanDiff ./ varSum;
    size(score)
    fish_x = linspace(0,19201, 19201);
    size(fish_x)
    
%     figure;
    plot(fish_x, score, 'r')
    title('Fisher criterion of each feature');
    
    [out,idx] = sort(score, 'descend');
    topIndex = idx(1:topK, 1);
    disp('top-3 idx:');
    disp(idx(1:topK, 1));
    disp('top-3 value:');
    disp(out(1:topK, 1));
    
    x = xFault;
    y1 = healthArr(topIndex, :).';
    y2 = faultArr(topIndex, :).';
    
end