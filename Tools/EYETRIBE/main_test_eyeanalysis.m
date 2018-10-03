%% load data
clear all, clc;
filename = 'sample_data.tsv';
es = eyetribe_single;
es.load(filename);
%% step 1 - preprocess 
% set 0 to NaNs
% remove outliers 
% remove odd points using a moving windows
% zscore
es.preprocess;
%% step 2 - epoch data
markerlist = {'start_game','end_game'};
es.get_epoch(markerlist);
%% step 3 - get ERP time locked 
n = 4;
fname = 'KeyPress';
es.get_ERP(fname, n, [-1 2]);
%% example
subplot(2,1,1);
plot(nanmean(es.ERP.(fname){n}.tm),nanmean(es.ERP.(fname){n}.px))
hold on
plot(nanmean(es.ERP.(fname){n}.tm),nanmean(es.ERP.(fname){n}.py))
subplot(2,1,2);
plot(nanmean(es.ERP.(fname){n}.tm),nanmean(es.ERP.(fname){n}.pd))

