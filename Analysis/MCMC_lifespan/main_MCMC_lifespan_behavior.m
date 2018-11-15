clear all, clc, close all;
pt = plot_horizonn;
exps = pt.exps(end);
savedir = 'MCMC_lifespan';
pt.load_data;
%% MCMC_lifespan
pt.acthres = -0.001;
pt.setupexpwithin(exps, [], []);
pt.setupcolorn;
pt.setcompareidx('info_loss',{[0 1]},{'Gain', 'Loss'}, 1);
%% basic plots
pt.setparameter(0, 1, fullfile(savedir), 'MCMClifespan')
%%
pt.ispairedttest = [true, false];
pt.line_modelfreen;
pt.plot_choicecurven;
pt.plot_trialnsn;
pt.line_modelfreebyagen;
pt.line_switchn;
pt.line_bypatternn;
%%
pt.save4MCMC('learningmodel_horizononly',[],80);
%%
pt.save4MCMC('simplemodel',[],80);
%%
pt.save4MCMC('learningmodel_nodiffusion_horizononly',[],80);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        