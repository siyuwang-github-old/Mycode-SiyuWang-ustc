%% mcmc fit
clear all, clc;
path.main = 'C:\Users\sywangr\';
path.data = 'C:\Users\sywangr\Box Sync\2018_Fall\MCMClifespan';
path.result = 'C:\Users\sywangr\Box Sync\2018_Fall\MCMClifespan';
filename = 'BenAndreaLifespan_learningmodel.mat';
abe = analysis_bayesian(fullfile(path.data,filename), path.main, path.result);
%%
abe.analysis;
%%
abe.savesamples;
