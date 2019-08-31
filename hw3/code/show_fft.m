function y = show_fft(h1, f1, f2, titles, fs)

[f, PH] = self_fft(h1, fs);
[f, PF1] = self_fft(f1, fs);
[f, PF2] = self_fft(f2, fs);


% Visualization 
figure; cla;
plot(f,PH, 'b');

hold on;
plot(f, PF1, 'r');
plot(f, PF2, 'y');

%%
title(['Shaft signal after fourier transform ',titles]);
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Healthy', 'Unbalance 1', 'Unbalance 2');
hold off;

end

