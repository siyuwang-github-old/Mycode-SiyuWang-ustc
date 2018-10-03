%% load data
clear all, clc;
filename = 'sample_data.tsv';
eye = analysis_eyetribe;
eye.importdata(filename);
%%
eye.process;
%% get epoch
unique(eye.message.string);
markerlist = {'startgame','endgame'};
eye.get_epoch(markerlist); 
%% get ERP
marker = 'keypress';
tpre = 2;
tpost = 2;
eye.get_ERPtimes(marker, 5, tpre, tpost)
eye.get_ERP;
eye.get_px;
eye.get_py;

%% plot ERP
eye.plot_ERP(1:100);
%%
eye.plot_px(1:100);
%%
eye.plot_py(1:100);