close all, clear all, clc;
%%
sh = Siyuhandle;
fs = dir(fullfile(sh.siyupathdatabayes, 'intext_2noisemodel_a_18_smix*'));
%%
for fi = 1:length(fs)
%%
abe = analysis_bayesian(fs(fi).name);
%%
abe.analysis(0);
%%
abe.savesamples;
end
%%
% %%
% fname = ['AU_075_blink'];
% savefolder = 'W:\LAB\DATAMAT';
% folder = 'W:\LAB\DATAMAT';
% bayesname = 'AU_075_blink_bayesian';
% %%
% hz = plot_horizon;
% filename = 'data_4_gpindmeasure.mat';
% hz.load_gpindmeasure(fullfile(folder, filename));
% filename = 'data_3_withindmeasure.mat';
% hz.load_data(fullfile(folder, filename));
% hz.setupexp('AU_075_blink', 0.0);
% %%
% getbayesian(hz.temp_data, fullfile(savefolder, bayesname));
% 
% %%
% hz.new;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% fake
% n = 5;
% %%
% for i = (1:n)+5
% fname = ['datafake_', 'bayesian60_', num2str(i), '.mat'];
% savefolder = fullfile('W:\LAB\RESULT');
% if exist(savefolder) ~= 7
%     mkdir(savefolder);
% end
% folder = 'W:\LAB\DATAMAT';
% hz = horizon;
% filename = 'data_4_gpindmeasure.mat';
% hz.load_gpindmeasure(fullfile(folder, filename));
% %%
% filename = 'data_3_withindmeasure.mat';
% hz.load_data(fullfile(folder, filename));
% %%
% hz.setupexp('AU_075_blink',0.60);
% %%
% stat = importdata('W:\LAB\RESULT\AU_075_blink_bayesstat60_result.mat');
% As = stat.stats.mean.As;
% bs = stat.stats.mean.bs;
% nints = stat.stats.mean.dNs;
% nexts = stat.stats.mean.Eps;
% %%
% % ro = randperm(size(As,2));
% ro = 1:size(As,2);
% datafake = getfakechoices(hz.temp_data, As(:,ro), bs(:,ro), nints(:,ro), nexts(:,ro));
% % save(fullfile(savefolder, ['ro_', fname]),'ro','As','bs','nints','nexts');%,'datafake');
% % fname = ['datafake_', 'bayesian60_', num2str(i), '.mat'];
% %     load(fullfile(folder, fname));
% getbayesian(datafake, fullfile(savefolder,[fname]));
% end