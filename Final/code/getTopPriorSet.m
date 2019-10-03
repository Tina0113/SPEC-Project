function [x, y, topIndex] = getTopPriorSet(yFFT, topK, classes, xLocation)
    FFTSIZE = size(xLocation)
    
    step = 256;
    bigMean = mean(yFFT, 2);
    % bigVar = var(yFFT, 0, 2);
    sumDiffmean = zeros(size(bigMean));
    sumVar = zeros(size(bigMean));    
    
    for k = 1:classes
        sumDiffmean = sumDiffmean + (mean(yFFT(:, (k-1)*step + 1:k*step), 2) - bigMean).^2;
        sumVar = sumVar + var(yFFT(:, (k-1)*step + 1:k*step), 0, 2);
    end
    disp('mean and var')
%     yFFT
    fisher_score = sumDiffmean ./ sumVar;
    
    %% ploting
    fSize = size(fisher_score)
    
    fish_x = linspace(0, 30, 30);
    size(fish_x)
     
    figure;
    plot(xLocation(1:30), fisher_score(1:30), 'r')
    title('Fisher criterion of each feature');
    xlabel('Hz')
    ylabel('Score')
   
    %% export result
    [out,idx] = sort(fisher_score, 'descend');
    topIndex = idx(1:topK, 1);
    disp(strcat('top-', k, 'idx:'));
    disp(idx(1:topK, 1));
    disp(strcat('top-', k, 'value:'));
    disp(out(1:topK, 1));

    x = xLocation;
    y = yFFT(topIndex, :).';
    
    %% plot bar fisher score
%     showIndex = [topIndex; 14; 17; 22]
%     showFre = xLocation(showIndex)
%     fisher_score(22)

%     figure
%     bar(fisher_score(showIndex))
%      
%     len = 1:length(fisher_score(showIndex));
%     % Reduce the size of the axis so that all the labels fit in the figure.
%     pos = get(gca,'Position');
%     set(gca,'Position',[pos(1), .2, pos(3) .65])
% 
%     % Add a title, if you need it.
%     %title('')
% 
%     % Set X-tick positions
%     Xt = len;
% 
%     % If you want to set x-axis limit, uncomment the following two lines of 
%     % code and remove the third
%     %Xl = [1 6]; 
%     %set(gca,'XTick',Xt,'XLim',Xl);
%     % set(gca,'XTick',Xt);
%     % ensure that each string is of the same length, using leading spaces
%     algos = ['    5011 Hz'; '   16315 Hz'; '   12378 Hz';
%         '       BPFO'; '       BPFI'; '        BSF'];
% 
%     ax = axis; % Current axis limits
%     Yl = ax(3:4); % Y-axis limits
% 
%     % Remove the default labels
%     set(gca,'XTickLabel','')
% 
%     % Place the text labels
%     t = text(Xt,Yl(1)*ones(1,length(Xt)),algos(len,:));
%     set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
%     'Rotation',45, 'Fontsize', 12);
%     ylabel('Fisher score', 'Fontsize', 13)
%     title('Fisher criterion bar chart', 'Fontsize', 13)

end