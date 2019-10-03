function [xLocation, yFFT] = transferFFT(data)
    fs = 50000;    
    x = data(:, 1:end-1).'; % remomve label    
    yFFT = [];
    xSize = size(x);

    for i = 1:xSize(2)
        [up,lo]=envelope(x(:, i));
        
        [xLocation, fftP1] = self_fft(up, fs); 
        yFFT = [yFFT fftP1];
    end
    
end