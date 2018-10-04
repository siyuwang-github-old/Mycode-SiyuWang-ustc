%% mcmc fit
clear all, clc;
%%
abe = analysis_bayesian('BenAndreaLifespan_learningmodel');
%%
abe = analysis_bayesian('BenAndreaLifespan_simplemodel');
%%
abe.analysis(0);
%%
abe.savesamples;
