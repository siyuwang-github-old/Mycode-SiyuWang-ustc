%% mcmc fit
clear all, close all, clc;
pb = plot_bayesian;
pb.setparameter(1, 1, 'MCMC_lifespan','MCMC_lifespan')
%%
exps = pb.exps(end);
pb.acthres = 0.55;
pb.setupexpwithin(exps, [], []);
pb.setupcolorn;
pb.setcompareidx('info_loss',{[0 1]},{'Gain', 'Loss'}, 1);
%%
pb.loadbayes('BenAndreaLifespan_simplemodel');
%%
pb.plot_subjectsnbyage;
%%
pb.plot_corrbehavior;
