close all, clear all, clc, format compact

% number of samples of each cluster
K = 200;
% offset of classes
q = 1.1;
% define 4 clusters of input data
P = [rand(1,K)-q rand(1,K)+q rand(1,K)+q rand(1,K)-q;
     rand(1,K)+q rand(1,K)+q rand(1,K)-q rand(1,K)-q];
% plot clusters
plot(P(1,:),P(2,:),'k*')
hold on
grid on
% %%
% 
% % SOM parameters
% dimensions   = [10 10];
% coverSteps   = 100;
% initNeighbor = 4;
% topologyFcn  = 'hextop';
% distanceFcn  = 'linkdist';
% 
% % define net
% net = selforgmap(dimensions,coverSteps,initNeighbor,topologyFcn,distanceFcn);
% plotsomtop(net)
% 
% %%
% % train
% [net,Y] = train(net,P);
% 
% %%
% % plot input data and SOM weight positions
% plotsomtop(net)
% plotsompos(net,P);
% grid on
% 
% % plot SOM neighbor distances
% plotsomnd(net)
% 
% % plot for each SOM neuron the number of input vectors that it classifies
% figure
% plotsomhits(net,P)