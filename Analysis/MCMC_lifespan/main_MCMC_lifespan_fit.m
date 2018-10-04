%% mcmc fit
clear all, clc;
%%
abe = analysis_bayesian('BenAndreaLifespan_learningmodel');
%%
abe = analysis_bayesian('BenAndreaLifespan_simplemodel');
%%
abe.analysis(1);
%%
abe.savesamples;
