function [x, y1, y2, y3, topIndex] = getTopPriorSet_1(x1, x2, x3, topK)
    fs = 2560;
    healthArr = [];
    fault_1_Arr = [];
    fault_2_Arr = [];
    faultArr = [];
    xSize = size(x1);
    x4 = horzcat(x2, x3);

    for i = 1:xSize(2)
        [xHealth, fftHP1] = self_fft(x1(:, i), fs);
        healthArr = [healthArr fftHP1];
        
        [xFault, fftFP1] = self_fft(x4(:, i), fs);
        
        [xFault, fftFP2] = self_fft(x4(:, i + xSize(2)), fs);
        faultArr = [faultArr fftFP1 fftFP2];
    end

    %% P2P ; RMS ; STD
    p2p_x1 = [];
    p2p_x2 = [];
    p2p_x3 = [];
    rms_x1 = [];
    rms_x2 = [];
    rms_x3 = [];
    std_x1 = [];
    std_x2 = [];
    std_x3 = [];
    
    x1 = x1.';
    x2 = x2.';
    x3 = x3.';
    
    for i = 1:xSize(2) %0~20
        std_x1_temp = std(x1(:, i));
        std_x1 = [std_x1 std_x1_temp];
        std_x2_temp = std(x2(:, i));
        std_x2 = [std_x2 std_x2_temp];
        std_x3_temp = std(x3(:, i));
        std_x3 = [std_x3 std_x3_temp];
        
        p2p_x1_temp = max(x1(:, i))-min(x1(:, i));
        p2p_x1 = [p2p_x1 p2p_x1_temp];
        p2p_x2_temp = max(x2(:, i))-min(x2(:, i));
        p2p_x2 = [p2p_x2 p2p_x2_temp];
        p2p_x3_temp = max(x3(:, i))-min(x3(:, i));
        p2p_x3 = [p2p_x3 p2p_x3_temp];
        
        rms_x1_temp = rms(x1(:, i));
        rms_x1 = [rms_x1 rms_x1_temp];
        rms_x2_temp = rms(x2(:, i));
        rms_x2 = [rms_x2 rms_x2_temp];
        rms_x3_temp = rms(x3(:, i));
        rms_x3 = [rms_x3 rms_x3_temp];
    end
    
    
    
    p2p_x = [p2p_x1 p2p_x2 p2p_x3];
    rms_x = [rms_x1 rms_x2 rms_x3];
    std_x = [std_x1 std_x2 std_x3];
    
%     p2p_x
%     rms_x
%     std_x
    disp("rms size");
    size(p2p_x)
    %p2p_fisher = sum((mean(p2p_x)-mean(p2p_x(1:3))^2)) / std(p2p_x)^2;
    p2p_mean = mean([p2p_x1 p2p_x2 p2p_x3])
    rms_mean = mean([rms_x1 rms_x2 rms_x3])
    std_mean = mean([std_x1 std_x2 std_x3])
    p2p_fisher = ((mean(p2p_x1)-p2p_mean)^2 + (mean(p2p_x2)-p2p_mean)^2 +(mean(p2p_x3)-p2p_mean)^2) / (std(p2p_x1)^2 + std(p2p_x2)^2 + std(p2p_x3)^2)
    rms_fisher = ((mean(rms_x1)-rms_mean)^2 + (mean(rms_x2)-rms_mean)^2 +(mean(rms_x3)-rms_mean)^2) / (std(rms_x1)^2 + std(rms_x2)^2 + std(rms_x3)^2)
    std_fisher = ((mean(std_x1)-std_mean)^2 + (mean(std_x2)-std_mean)^2 +(mean(std_x3)-std_mean)^2) / (std(std_x1)^2 + std(std_x2)^2 + std(std_x3)^2)
    
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
    y1 = p2p_x;
    y2 = rms_x;
    y3 = std_x;
    
end