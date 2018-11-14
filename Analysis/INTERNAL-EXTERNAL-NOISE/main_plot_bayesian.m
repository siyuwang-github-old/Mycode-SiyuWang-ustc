%% mcmc fit
clear all, close all, clc;
pb = plot_bayesian;
pb.setparameter(1, 1, 'Internal_external_noise','intext')
%%
% acs = [-0.01 0 0.55 0.6 0.65];
acs = -0.01;
for aci = 1:length(acs)
%     if acs(aci) == 0
%         pt.legsuffix = ', all subjects';
%     else
        pt.legsuffix = '';
%     end
pb.acthres = acs(aci);
pb.setupexps('16S075', 1,1,[], []); % why are there 4 matched participants if i do setexpwithin?
%%
pb.loadbayes('2noisemodel',1);
%%
pb.plot_hyperpriors_2noise([-1 22 -3 13],[0 4 20 -3 3 12]);
%%
% pb.plot_recovery_2noise();
end
%%
% pb.plot_corrbehavior;
%%

%%
% clear all, close all, clc;
% folder = 'W:\LAB\RESULT';
% pc = '60'
% filesample = ['AU_075_blink_bayessamples_samples',pc,'.mat'];
% pb = plot_bayesian;
% save = 1;
% show = 1;
% format = 'paper';
% savefolder = ['W:\LAB\FIGS\EXP_int-ext_noise\AU_075_blink_ac', pc];
% pb.setparameter(savefolder, format, save, show)
% %%
% pb.loadsamples(fullfile(folder, filesample));
% %%
% stat = pb.plot_hyperpriors([-1 22 -3 13],[0 4 20 -3 3 12]);
% % stat = pb.plot_hyperpriors([-1 13 -1 13],[0 2 12 0 2 12]);
% %%
% filestats = 'AU_075_blink_bayesstat60_result.mat';
% pb.loadstats(fullfile(folder, filestats));
% % %%
% % pb.plot_subjects;
% % %%
% fakename = 'bayesfit_datafake_bayesian60_10_result.mat';
% roname = 'ro_datafake_bayesian60.mat';
% pb.plot_recovery(fullfile(folder, fakename),fullfile(folder, roname));
% %% load behavior
% folder = 'S:\LAB\ANALYSIS\HORIZONTASK\DATASETS_RAW';
% filename = 'data_gpindmeasure.mat';
% pb.load_gpindmeasure(fullfile(folder, filename));
% pb.setupexp('AU_075_blink',0.6);
% %% correlation with behavior
% pb.plot_corrbehavior