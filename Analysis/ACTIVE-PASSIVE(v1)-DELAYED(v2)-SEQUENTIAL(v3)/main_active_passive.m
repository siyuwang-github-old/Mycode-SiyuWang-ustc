clear all, clc, close all;
pt = plot_horizonn;
exps0 = pt.exps;
exps = exps0([1 2 6 7 8 12 13]);
exps2 = exps0([6 7 13 19]);
pt.acthres = 0;
% exps = exps([1 2 8 12 13]);
savedir = 'W:\LAB\FIGS\Active_passive_sequential';
%% active vs passive
clc;
for analysisi = [1:1:10]
    switch analysisi
        case 1 % within - active vs passive(no delay)
            pt.setupexpwithin('16F019', [], 1);
            pt.setupcolorn;
            pt.setcompareidx('cond_exp',{{'Active','Passive'}},{'Active', 'Passive'}, 1);
            pt.setparameter(0, 1, fullfile(savedir,'active_passive_within'), 'within')
            mylim.modelfree = {[0.35 0.65],[0.2 0.45]};
            mylim.trialn = {[0.55 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true true];
            pt.temp_sigstar_y_direction = [-1, 1];
        case 2 % between - active vs all passive
            pt.setupexps(exps, [], 1, 1);
            pt.setupcolorn;
            pt.setcompareidx('cond_exp',{{'Active','Passive'}},{'Active', 'Passive'});
            pt.setparameter(0, 1, fullfile(savedir,'active_passive_all'), 'between_all_delay_included')
            mylim.modelfree = {[0.4 0.6],[0.2 0.35]};
            mylim.trialn = {[0.6 0.8],[0 1.2],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1];
        case 3 % between - active vs passive(no delay)
            pt.setupexps(exps, [], 1, 1, NaN);
            pt.setupcolorn;
            pt.setcompareidx('cond_exp',{{'Active','Passive'}},{'Active', 'Passive'});
            pt.setparameter(0, 1, fullfile(savedir,'active_passive_nodelay'), 'between_no_delay')
            mylim.modelfree = {[0.35 0.6],[0.2 0.35]};
            mylim.trialn = {[0.6 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1];
        case 4 % between - passive(no delay) vs passive(delay)
            pt.setupexps(exps, 0, 1, 1);
            pt.setupcolorn({'AZblue','AZsky'},{{'lightblue','lightsky'},{'AZblue','AZsky'}});
            pt.setcompareidx('cond_delaytime_R2B',[0 1],{'no delay', 'delay'},[],{@(x)SiyuTools.iif(isnan(x), 0, floor(x) == 3)});
            pt.setparameter(0, 1, fullfile(savedir,'passive_delay_nodelay'), 'between_passive')
            mylim.modelfree = {[0.35 0.6],[0.2 0.35]};
            mylim.trialn = {[0.6 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1];
        case 5 % between - active vs passive(no delay) vs passive(delay)
            pt.setupexps(exps, [], 1, 1);
            pt.setupcolorn({'AZred','AZblue','AZsky'},{{'lightred','lightblue','lightsky'},{'AZred','AZblue','AZsky'}});
            pt.setcompareidx({'cond_exp','cond_delaytime_R2B'},{{'Active','Passive'},[0 1]},{{'Active', 'Passive'}, {'no delay', 'delay'}},[],{[],@(x)SiyuTools.iif(isnan(x), 0, floor(x) == 3)});
            pt.setparameter(0, 1, fullfile(savedir,'active_passive3'), 'between3')
            mylim.modelfree = {[0.35 0.6],[0.2 0.35]};
            mylim.trialn = {[0.6 0.8],[0 1.2],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1, 1];
        case 6 % within - passive, only the first order
            idx_special = (mod(pt.data_gp.subjectID,2) == 0) == cellfun(@(x)strcmp(x, 'Active'), pt.data_gp.cond_exp);
            pt.setupexpwithin('16F019', [], 1, idx_special);
            pt.setupcolorn;
            pt.setcompareidx('cond_exp',{{'Active','Passive'}},{'Active', 'Passive'});
            pt.setparameter(0, 1, fullfile(savedir,'active_passive_1st'), 'within_order')
            mylim.modelfree = {[0.35 0.65],[0.2 0.45]};
            mylim.trialn = {[0.55 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1];
        case 7 % within - passive order
            pt.setupexpwithin('16F019', [], 1);
            leg = {{'Active', 'Passive'},{'a1','p1'}};
            pt.setparameter(0, 1, fullfile(savedir,'active_passive_order'), 'ordereffect')
            pt.setupcolorn({'AZred','lightred','lightblue','AZblue'},{{'AZred','lightred','lightblue','AZblue'},{'AZred','lightred','lightblue','AZblue'}});
            pt.setcompareidx({'cond_exp','subjectID'},{{'Active','Passive'},[0 1]},leg,[],{[],@(x)mod(x,2)});
            mylim.modelfree = {[0.35 0.65],[0.2 0.45]};
            mylim.trialn = {[0.55 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1, -1, 1];
        case 8 % within - sequential
            pt.setupexpwithin('18F018', [], []);
            pt.setupcolorn({'AZred','AZcactus'},{{'lightred','lightcactus'},{'AZred','AZcactus'}});
            pt.setcompareidx('info_session',[2 1],{'Active','Sequential'});
            pt.setparameter(0, 1, fullfile(savedir,'active_sequential_within'), 'sequential')
            mylim.modelfree = {[0.4 0.65],[0.15 0.45]};
            mylim.trialn = {[0.55 0.8],[0 1.8],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true true];
            pt.temp_sigstar_y_direction = [-1, 1];
        case 9 % within - sequential, only the first order
            idx_special = (mod(pt.data_gp.subjectID,2) == 1) == arrayfun(@(x)x == 2, pt.data_gp.info_session);
            pt.setupexpwithin('18F018', [], [], idx_special);
            pt.setupcolorn({'AZred','AZcactus'},{{'lightred','lightcactus'},{'AZred','AZcactus'}});
            leg = {'Active','Sequential'};
            pt.setcompareidx('info_session',[2 1],{'Active','Sequential'});
            pt.setparameter(0, 1, fullfile(savedir,'active_sequential_1st'), 'sequential_within_order')
            mylim.modelfree = {[0.35 0.65],[0.2 0.45]};
            mylim.trialn = {[0.55 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1];
        case 10 % within - sequential order
            pt.setupexpwithin('18F018', [], []);
            leg = {{'Active', 'Sequential'},{'a1','s1'}};
            pt.setparameter(0, 1, fullfile(savedir,'active_sequential_order'), 'sequential_ordereffect')
            pt.setupcolorn({'AZred','lightred','lightcactus','AZcactus'},{{'AZred','lightred','lightcactus','AZcactus'},{'AZred','lightred','lightcactus','AZcactus'}});
            pt.setcompareidx({'info_session','subjectID'},{[2 1],[1 0]},leg,[],{[],@(x)mod(x,2)});
            mylim.modelfree = {[0.35 0.65],[0.2 0.45]};
            mylim.trialn = {[0.55 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1, -1, 1];
        case 11 % between - sequential
            pt.setupexps(exps2, [], NaN, NaN);
            pt.setupcolorn;
            pt.setcompareidx('cond_exp',{{'Active','Missing'}},{'Active', 'Sequential'});
            pt.setparameter(0, 1, fullfile(savedir,'active_sequential_between'), 'active_sequential_between')
            mylim.modelfree = {[0.4 0.65],[0.15 0.45]};
            mylim.trialn = {[0.6 0.8],[0 1.5],[0.2 0.6],[0.2 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1];
    end
    pt.line_disagreen;
    pt.line_switchn;
    pt.line_bypatternn;
    pt.sethardlim([],mylim.modelfree);
    pt.line_modelfreen;
    pt.sethardlim([],mylim.trialn);
    pt.plot_trialnsn;
    pt.sethardlim([],mylim.trialn([1,2]));
    pt.plot_trialn_acRT;
    pt.sethardlim([],mylim.trialn([3,4]));
    pt.plot_trialn_hilm;
    pt.plot_choicecurven;
end
%%
pt.setupexpwithin('18F018', [], []);
pt.setupcolorn({'AZred','AZcactus'},{{'lightred','lightcactus'},{'AZred','AZcactus'}});
pt.setcompareidx('info_session',[2 1],{'Active','Sequential'});
idx = mean([pt.temp_gp.trialn(1).RT(pt.idxn{2},1:4),pt.temp_gp.trialn(2).RT(pt.idxn{2},1:4)]')...
    < mean([pt.temp_gp.trialn(1).RT(pt.idxn{1},1:4), pt.temp_gp.trialn(2).RT(pt.idxn{1},1:4)]');

i1 = [pt.idxn{1}(idx);pt.idxn{2}(idx)];
i2 = [pt.idxn{1}(~idx);pt.idxn{2}(~idx)];
pt.temp_gp.tempmark(i1,1) = 1;
pt.temp_gp.tempmark(i2,1) = 0;

% pt.temp_gp.tempmark2 = (mod(pt.temp_gp.subjectID,2) == 1) == arrayfun(@(x)x == 2, pt.temp_gp.info_session);

pt.setupcolorn({'AZred','AZcactus','lightred','lightcactus'},{{'AZred','AZcactus','lightred','lightcactus'},{'AZred','AZcactus','lightred','lightcactus'}});
% leg = {'Active','Sequential'};
pt.setupgroup(pt.temp_gp.info_session == 1, 1);
pt.setcompareidx({'tempmark','subjectID'},{[1 0],[1 0]},...
    {{'ac>seq','ac<seq'},{'a1','s1'}},[],{[],@(x)mod(x,2)});


pt.setparameter(0, 1, fullfile(savedir,'active_sequential_RTsplit'), 'active_sequential_RTsplit')
pt.ispairedttest = [true false];
pt.temp_sigstar_y_direction = [-1, 1, -1 ,1];

pt.line_switchn;
pt.line_bypatternn;
pt.sethardlim([],mylim.modelfree);
pt.line_modelfreen;
pt.plot_trialnsn;
