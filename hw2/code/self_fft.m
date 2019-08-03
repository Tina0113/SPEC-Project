function [f, y] = self_fft(x, fs)
% data preprocessing 
Fs = fs;              % Sampling frequency                    
T = 1/Fs;             % Sampling period       
[L, n] = size(x);     % size of signal array
t = (0:L-1)*T;        % Time vector

Y = fft(x);
P2 = abs(Y/L);

P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

y = P1;


end
