function y = bind_fft(x1, x2, titles)

% data preprocessing 
Fs = 2560;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
[L, n] = size(x1);     % size of signal array
t = (0:L-1)*T;        % Time vector

% Visualization 
figure; cla;

Y = fft(x1);
P2 = abs(Y/L);
P1h = P2(1:L/2+1);
P1h(2:end-1) = 2*P1h(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1h, 'b');

%%
hold on;
Y = fft(x2);
P2 = abs(Y/L);
P1f = P2(1:L/2+1);
P1f(2:end-1) = 2*P1f(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f, P1f, 'r');

%%

title(['Shaft signal after fourier transform ',titles]);
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Healthy', 'Faulty');
hold off;

end

