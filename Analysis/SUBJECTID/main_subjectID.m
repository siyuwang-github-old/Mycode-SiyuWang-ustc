close all, clear all, clc;
%%
pt = plot_subjectID();
exps0 = pt.exps;
exps = exps0([1 2 6 7 8 12 13]);
pt.acthres = 0;
savedir = 'SubjectID';
pt.setupexps(exps, [], [], 1);
%%
pt.savetoshare('data_subID');
%%
pt.plot_daytimes;
%%
% pt.showstat = false;
% folder = 'W:\LAB\DATAMAT';
% filename = 'data_4_gpindmeasure.mat';
% pt.load_gpindmeasure(fullfile(folder, filename));
% %%
% save = 1;
% show = 1;
% format = 'paper';
% savefolder = 'W:\LAB\FIGS\EXP_passive-active';
% pt.setparameter(savefolder, format, save, show)
% %%
% pt.ispairedttest = false;
% pt.savesuffix = 'all';
% nums = pt.setupexps({'AU_075_blink','AU_017','AU_042','AU_060','AU_073',...
%     'AU_2015_testRetestAndPersonality','AU_2015_personality'},0,1);
% startdate = [20160125, 20160829, 20150831, 20150831, 20160125, 20150126, 20150126];
% year = floor(startdate/10000);
% startdate = mod(startdate, 10000);
% month = floor(startdate/100);
% day = mod(startdate,100);
% months = [0 31 28 31 30 31 30 31 31 30 31 30];
% months = cumsum(months);
% startdate = arrayfun(@(x)months(month(x)) + day(x), 1:length(year))';
% 
% %%
% time = pt.temp_gp.time;
% time = cellfun(@(x)pt.all2num(x), time);
% time = floor(time/10000) + floor(mod(time,10000)/100)/60 + floor(mod(time,100))/3600;
% %%
% date = pt.temp_gp.date;
% date = cellfun(@(x)tempdateconverter(x), date);
% year = floor(date/10000);
% date = mod(date, 10000);
% month = floor(date/100);
% day = mod(date,100);
% months = [0 31 28 31 30 31 30 31 31 30 31 30];
% months = cumsum(months);
% date = arrayfun(@(x)months(month(x)) + day(x), 1:length(year))';
% %%
% exps = cellfun(@(x)find(strcmp({'AU_075_blink','AU_017','AU_042','AU_060','AU_073',...
%      'AU_2015_testRetestAndPersonality','AU_2015_personality'},x)),pt.temp_gp.exp);
% dcount = date - arrayfun(@(x)startdate(x), exps);
% %%
% names = {'hi1','hi6','di','lm1','lm6','ra','ac5','ac10'};
% horizons = [pt.temp_gp.p_hi13 diff(pt.temp_gp.p_hi13')' pt.temp_gp.p_lm22 diff(pt.temp_gp.p_lm22')' ...
%     pt.temp_gp.trialn(1).p_ac(:,5) pt.temp_gp.trialn(2).p_ac(:,10)];
% %%
% st = SiyuPlots;
% st.corrall(horizons, [dcount time], names, {'date','time'});
% %%
% st.corrtable(horizons, [dcount time], {'date','time'},names );
%%
% subID = pt.temp_gp.subID;
% clear save
% save('datetime.mat','subID','date','time')