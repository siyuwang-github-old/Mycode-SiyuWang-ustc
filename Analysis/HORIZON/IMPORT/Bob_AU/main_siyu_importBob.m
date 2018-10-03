%%
clear all, clc;
addpath(pwd);
datadir = 'W:\LAB\DATA\Horizon___AU_2015_testRetestAndPersonality';
savedir = 'W:\LAB\DATAMAT';
savename = 'Horizon___AU15S_001_testretest';
expname = '15S001';
dd = group_testRetest(datadir);
dd.load;
ddata = dd.sub;
bobAU2Siyuv1(ddata, savedir, savename, expname);
%%
clear all, clc;
addpath(pwd);
datadir = 'W:\LAB\DATA\Horizon___AU_2015_personality';
savedir = 'W:\LAB\DATAMAT';
savename = 'Horizon___AU15S_002_personality';
expname = '15S002';
dd = group_BIS(datadir);
dd.load;
ddata = dd.sub;
bobAU2Siyuv1(ddata, savedir, savename, expname);
%%
clear all, clc;
addpath(pwd);
datadir = 'W:\LAB\DATA\Horizon___AU_ControlCond_Emily';
savedir = 'W:\LAB\DATAMAT';
savename = 'Horizon___AU15F16F_000_Emily';
expname = '15F16FEmily';
dd = group_testRetest(datadir);
dd.load;
ddata = dd.sub;
bobAU2Siyuv1(ddata, savedir, savename, expname);
%%