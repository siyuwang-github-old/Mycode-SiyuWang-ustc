clear all, clc, close all;
pt = plot_horizonn;
exps = pt.exps;
exps = exps([13 15 18]);
savedir = 'Full_feedback';
%% active vs passive
for analysisi = [1]
    switch analysisi
        case 1 % between
            pt.setupexps(exps, [], [], [], []);
            pt.setupcolorn({'AZred', 'AZblue', 'AZcactus'},{{'lightred', 'lightblue', 'lightcactus'},{'AZred', 'AZblue', 'AZcactus'}});
            pt.setcompareidx('info_exp',{[3 1 2]},{'No feedback', 'Feedback', 'Full feedback'}, 0, {@(x)min(find(strcmp({'18F031','17S026',x}, x)))});
            pt.setparameter(1, 1, fullfile(savedir,'fullfeedback'), 'between')
            mylim.modelfree = {[0.2 0.65],[0.0 0.45]};
            mylim.trialn = {[0.5 1],[0 1.5],[0 0.6],[0 0.6]};
            pt.ispairedttest = [true false];
            pt.temp_sigstar_y_direction = [-1, 1, -1];
    end
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