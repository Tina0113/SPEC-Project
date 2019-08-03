%E-Manufacturing 2013

%Logistic Regression 

%How to Use This Method


%% clear stuff
clear all
clc
close all


%% Select Training Portion and PCA (front/back)

%GoodSampleIndex (in this example I assume the baseline data is first 100
%samples

GoodSampleIndex=1:100;

%Lets assume the last 100 samples are from a degraded system
DegradedSampleIndex=101:200;

%Baseline Data
BaselineData=FeatureMatrix(GoodSampleIndex,:);

DegradedData=FeatureMatrix(DegradedSampleIndex,:);



%% Train LR Model

%Label Vector (0.95 for good samples, 0.05 for bad samples
Label=[ones(size(BaselineData,1),1)*0.95; ones(size(DegradedData,1),1)*0.05];

%fit LR Model (glm-fit)
beta = glmfit([BaselineData; DegradedData],Label,'binomial');



%% Calculating Health Value (using LR Model)

%assume I have some test-data (assume it is samples 301-400

TestFeatureMatrix=FeatureMatrix(301:400,:);

%calculate CV (Health Value)
CV_Test = glmval(beta,TestFeatureMatrix,'logit') ;  %Use LR Model
   

