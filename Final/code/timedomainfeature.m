function [rms,p2p,variance] = timedomainfeature(data)
    x = data(:, 1:end-1).'; % remomve label
%     xSize = size(x)
%     timedomain = []
    
    rms = sqrt(mean(x.^2)).';
    p2p = peak2peak(x).';
    variance = var(x).';
%     timedomain = [rms,p2p,variance]; 
    
end   
    