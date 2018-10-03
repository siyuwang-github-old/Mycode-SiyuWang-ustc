clear all, clc;
s = cardstopping_modelfitting;
save = 1;
show = 0;
savefolder = 'W:\LAB\FIGS\Card_stopping';
savename = '';
s.setparameter(show, save, savefolder, savename);
s.loadall(60);
s.default_analysis(0);
%%
s.fitmodel_raw;
s.fitmodel_constantthreshold;
s.fitmodel_horizonthreshold;
s.fitmodel_horizonthresholdbetaprior;
s.fitmodel_samplingbernoulli;
s.fitmodel_samplingbernoullibeta;
%%
s.comparemodels;