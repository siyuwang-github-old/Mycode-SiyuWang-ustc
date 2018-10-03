clear all, clc;
folder = 'W:\LAB\DATA\Horizon___BOB___MCMClifespan';
filename = 'benAndreaLifeSpan.csv';
savedir = 'W:\LAB\DATAMAT';
savename = 'Horizon___BenAndreaLifespan';
%%
bobexcel2siyu(fullfile(folder, filename), fullfile(savedir, savename));
%%