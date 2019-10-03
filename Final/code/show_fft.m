function y = show_fft(data, titles, fs)

dataSize = size(data);
errorType = ["normal", "roller", "inner race", "outer race", "inner race & roller", ...
    "inner race & outer race", "outer & inner race & roller", "outer race & roller"];

%% ploting
for i = 1:2:dataSize(1)    
    [f, P1] = self_fft(data(i, :).', fs);
    [f, P2] = self_fft(data(i+1, :).', fs);
    
    figure; cla;
    ax1 = subplot(2,1,1);
    plot(f, P1)
    legend(ax1,errorType(i))
    title(errorType(i));
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
    hold on
    ax2 = subplot(2,1,2);
    plot(f, P2)
    legend(ax2,errorType(i+1))
    
    title(errorType(i+1));
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
    sgt = sgtitle('Bearing signal after fourier transform','Color','red');
    hold off
end
    
% [~, hobj, ~, ~] = legend(errorType(1:dataSize(1)));
% hl = findobj(hobj,'type','line');
% set(hl,'LineWidth',2.0);
% 
% hold off;

end

