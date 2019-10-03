function [f, y] = self_fft(x, fs)
% data preprocessing 
Fs = fs;              % Sampling frequency                    
T = 1/Fs;             % Sampling period       
[L, n] = size(x);     % size of signal array
t = (0:L-1)*T;        % Time vector

Y = fft(x);
P2 = abs(Y/L);

half = round(L / 2);

P1 = P2(1:half+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:half)/L;

y = P1;


end
