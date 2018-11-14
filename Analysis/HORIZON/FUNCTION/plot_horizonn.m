classdef plot_horizonn < plot_horizon
    properties
        colorn
        colornh
    end
    methods
        function obj = plot_horizonn()
            obj.setupcolorn();
        end
        function setupcolorn(obj, colorn, colornh)
            if exist('colorn') && ~isempty(colorn)
                obj.colorn = obj.str2color(colorn);
            else
                obj.colorn =  obj.str2color({'AZred','AZblue'});
            end
            if exist('colornh') && ~isempty(colornh)
                obj.colornh{1} = obj.str2color(colornh{1});
                obj.colornh{2} = obj.str2color(colornh{2});
            else
                obj.colornh{1} = obj.str2color({'lightred','lightblue'});
                obj.colornh{2} = obj.str2color({'AZred','AZblue'});
            end
        end
        function line_modelfreebyagen(obj, agebin)
            gp = obj.temp_gp;
            if ~exist('agebin')
                agebin = [0, 13, 18, 25, 40, 70, 100];
            end
            obj.figure(1,2);
            age = arrayfun(@(x)gp.demo_age(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            datahi = arrayfun(@(x)gp.p_hi_13(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            datalm = arrayfun(@(x)gp.p_lm_22(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            count = 0;
            for gpi = 1:length(obj.idxn)
                for hi = 1:2
                    count = count + 1;
                    ages{count} = age{gpi};
                    datahis{count} = datahi{gpi}(:,hi);
                    datalms{count} = datalm{gpi}(:,hi);
                end
            end
            obj.now_color = {obj.colors.lightred, obj.colors.AZred, ...
                obj.colors.lightblue, obj.colors.AZblue};
            obj.lineplot_bin(datahis, ages, agebin);
            obj.temp_legloc = 'NorthWest';
            obj.legend({'Gain, h = 1','Gain, h = 6','Loss, h = 1','Loss, h = 6'});
            obj.label('age','p(high info)');
            obj.now_color = {obj.colors.lightred, obj.colors.AZred, ...
                obj.colors.lightblue, obj.colors.AZblue};
            obj.lineplot_bin(datalms, ages, agebin);
            obj.temp_legloc = 'NorthWest';
            obj.legend({'Gain, h = 1','Gain, h = 6','Loss, h = 1','Loss, h = 6'});
            obj.label('age','p(low mean)');
            obj.save('modelfreebyage');
        end
        function line_disagreen(obj)
            gp = obj.temp_gp;
            obj.figure(1,2);
            obj.now_color = obj.colorn;
            data = arrayfun(@(x)gp.p_da13(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            obj.line2(data);
            obj.temp_legloc = 'NorthWest';
            obj.label('horizon', 'p(high info)', obj.idxnlabel);
            obj.yautotick(1, 0.1);
            obj.title('[1 3]');
            
            obj.now_color = obj.colorn;
            data = arrayfun(@(x)gp.p_da22(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            obj.line2(data);
            obj.temp_legloc = 'NorthWest';
            obj.label('horizon', 'p(high info)', obj.idxnlabel);
            obj.yautotick(1, 0.1);
            obj.title('[2 2]');
            obj.save('disagreen');
        end
        function line_directn(obj)
            gp = obj.temp_gp;
            obj.now_color = obj.colorn;
            data = arrayfun(@(x)gp.p_hi_13(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            obj.line2(data);
            obj.temp_legloc = 'NorthWest';
            obj.label('horizon', 'p(high info)', obj.idxnlabel);
            obj.yautotick(1, 0.1);
        end
        function line_randomn(obj)
            gp = obj.temp_gp;
            obj.now_color = obj.colorn;
            data = arrayfun(@(x)gp.p_lm_22(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            obj.line2(data);
            obj.temp_legloc = 'NorthWest';
            obj.label('horizon', 'p(low mean)', obj.idxnlabel);
            obj.yautotick(1, 0.1);
        end
        function line_random13n(obj)
            gp = obj.temp_gp;
            obj.now_color = obj.colorn;
            data = arrayfun(@(x)gp.p_lm_13(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            obj.line2(data);
            obj.temp_legloc = 'NorthWest';
            obj.label('horizon', 'p(low mean, [1 3])', obj.idxnlabel);
            obj.yautotick(1, 0.1);
        end
        function line_modelfreen(obj, is13)
            disp('plotting...modelfreen');
            obj.figure(1,2);
            obj.line_directn;
            if ~exist('is13')
                obj.line_randomn;
            else
                obj.line_random13n;
            end
            obj.BobaddABCs();
            obj.save('modelfreen');
        end
        function plot_trialnsn(obj, lateronly)
            if ~exist('lateronly')
                lateronly = length(obj.idxn) > 3;
            end
            disp('plotting...trialnsn');
            fnames = {'ac','RT','p_hi','p_lm'};
            ylbs = {'accuracy','reaction time', 'p(high info)', 'p(low mean)'};
            ytks = [0.1, 0.5, 0.1, 0.1];
            legloc = {'NorthWest', [],[],[]};
            addabcindent = [0.01,0];
            savename = 'trialnn';
            obj.figure(2,2);
            obj.plot_trialnsns(fnames, ylbs, ytks, legloc, addabcindent, savename, lateronly);
        end
        function plot_trialn_acRT(obj, lateronly)
            if ~exist('lateronly')
                lateronly = length(obj.idxn) > 3;
            end
            disp('plotting...trialnacRT');
            fnames = {'ac','RT'};
            ylbs = {'accuracy','reaction time'};
            ytks = [0.1, 0.5];
            legloc = {'NorthWest', []};
            addabcindent = [0.01,0];
            savename = 'trialnn_acRT';
            obj.figure(1,2);
            obj.plot_trialnsns(fnames, ylbs, ytks, legloc, addabcindent, savename, lateronly);
        end
        function plot_trialn_hilm(obj, lateronly)
            if ~exist('lateronly')
                lateronly = length(obj.idxn) > 3;
            end
            disp('plotting...trialnhilm');
            fnames = {'p_hi','p_lm'};
            ylbs = {'p(high info)', 'p(low mean)'};
            ytks = [0.1, 0.1];
            legloc = {[],[]};
            addabcindent = [0.01,0];
            savename = 'trialnn_hilm';
            obj.figure(1,2);
            obj.plot_trialnsns(fnames, ylbs, ytks, legloc, addabcindent, savename, lateronly);
        end
        function plot_trialnsns(obj, fnames, ylbs, ytks, legloc, addabcindent, savename, lateronly)
            if lateronly
                latertrial = 2;
                leg = [obj.idxnlabelh{2}];
                colornh{1} = obj.colornh{2};
            else
                latertrial = 1;
                leg = [obj.idxnlabelh{1} obj.idxnlabelh{2}];
                colornh = obj.colornh;
            end
            idx = obj.idxn;
            hs = latertrial:2;
            for hi = 1:length(hs)
                nt{hi} = obj.temp_gp.trialn(hs(hi));
            end
            for fi = 1:length(fnames)
                fname = fnames{fi};
                for hi = 1:length(nt)
                    obj.holdon = SiyuTools.iif(hi == 1, false, true);
                    obj.isplotstar = SiyuTools.iif(hi == 1 & length(nt) > 1, 0, 2);
                    obj.now_color = colornh{hi};
                    obj.line_trialn_idx(nt{hi}.(fname) , idx)
                end
                obj.temp_legloc = legloc{fi};
                obj.label('free choice trial number', ylbs{fi}, leg);
                obj.yautotick(1, ytks(fi))
                set(gca, 'XTick', 1:6);
            end
            obj.BobaddABCs([],addabcindent);
            if ~isempty(savename)
                obj.save(savename);
            end
        end
        function plot_choicecurve2(obj)
            disp('plotting...choicecurve2');
            idx = obj.idxn;
            leg = {'H = 1','H = 6'};
            obj.figure(1,2,1);
            rcurve = obj.temp_gp.rcurve.dfR4_empirical;
            bin = obj.temp_gp.rbin_kernel;
            titles = obj.idxnlabel;
            for hi = 1:2
                data = arrayfun(@(x)rcurve(x,5).p_r(idx{hi},:), 1:2,...
                    'UniformOutput',false);
                obj.now_color = cellfun(@(x)x{hi}, obj.colornh, 'UniformOutput', false);
                obj.lineplot_raw(data, bin);
                obj.temp_legloc = 'NorthWest';
                obj.label('difference of means', 'p(right)', leg);
                obj.lim([],[0 1]);
                obj.title(titles{hi});
                obj.now_color = [];
            end
            obj.BobaddABCs();
            obj.save('choicecurve2');
            obj.yautotick(1, 0.2)
            
        end
        function plot_choicecurven(obj)
            disp('plotting...choicecurven');
            idx = obj.idxn;
            if length(idx) == 2
                obj.plot_choicecurve2;
            end
            leg = obj.idxnlabel;
            obj.figure(1,2,1);
            rcurve = obj.temp_gp.rcurve.dfR4_empirical;
            bin = obj.temp_gp.rbin_kernel;
            titles = {'h = 1','h = 6'};
            for hi = 1:2
                data = arrayfun(@(x)rcurve(hi,5).p_r(idx{x},:), 1:length(idx),...
                    'UniformOutput',false);
                obj.now_color = obj.colornh{hi};
                obj.lineplot_raw(data, bin);
                obj.temp_legloc = 'NorthWest';
                obj.label('difference of means', 'p(right)', leg);
                obj.lim([],[0 1]);
                obj.title(titles{hi});
            end
            obj.BobaddABCs();
            obj.save('choicecurven');
            obj.yautotick(1, 0.2)
        end
        function line_switchn(obj)
            obj.figure(1,2);
            gp = obj.temp_gp;
            obj.now_color = obj.colorn;
            data = arrayfun(@(x)gp.p_sw(obj.idxn{x},:), 1:length(obj.idxn),...
                'UniformOutput',false);
            obj.line2(data);
            obj.temp_legloc = 'NorthWest';
            obj.label('horizon', 'p(switch)', obj.idxnlabel);
            obj.yautotick(1, 0.1);
            
            fnames = {'p_sw'};
            ylbs = {'p(switch)'};
            ytks = [0.1];
            legloc = {[]};
            obj.plot_trialnsns(fnames, ylbs, ytks, legloc, [], [], 1);
            
            obj.save('switchn');
            obj.yautotick(1, 0.2)
            
        end
        function line_bypatternn(obj)
            gp = obj.temp_gp;
            obj.figure(2,2,1);
            fields = {'p_hip','p_lmp','p_swp','RTp'};
            names = {'p(high info)','p(low mean)','p(switch)','RT'};
            for fi = 1:length(fields)
                name = fields{fi};
                te = gp.(name);
                for hi = 1:length(te)
                    obj.holdon = SiyuTools.iif(hi == 1, false, true);
                    obj.isplotstar = SiyuTools.iif(hi == 1, 0, 2);
                    obj.now_color = obj.colornh{hi};
                    obj.line_pattern_idx(te{hi} , obj.idxn)
                end
                title(names{fi});
            end
            obj.save('patternn');
            obj.yautotick(1, 0.2)
        end
    end
end