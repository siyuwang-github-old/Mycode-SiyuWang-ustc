classdef plot_horizon < stat_horizon
    properties
        
    end
    methods
        function obj = plot_horizon()
        end
        function line_choicecurve(obj)
            obj.figure;
            rcurve = obj.temp_gp.rcurve.dfR4_empirical;
            bin = obj.temp_gp.rbin_kernel;
            data = {rcurve(1,5).p_r, rcurve(2,5).p_r};
            obj.now_color = {obj.colors.AZblue, obj.colors.AZred};
            obj.lineplot_raw(data);
            obj.label('difference of means', 'p(right)', {'H = 1','H = 6'});
            obj.lim([],[0 1]);
            obj.now_color = [];
            obj.save;
        end
        function line_trialns(obj)
            obj.figure(2,2);
            obj.line_trialn_h('p_hi', 'p(high info)');
            obj.line_trialn_h('p_lm', 'p(low mean)');
            obj.line_trialn_h('ac', 'accuracy');
            obj.line_trialn_h('RT', 'reaction time');
            obj.save;
        end
        function line_trialn_h(obj, fname, ylab)
            if ~exist('colors')
                colors = {obj.colors.AZblue obj.colors.AZred};
            end
            leg = {'H = 1','H = 6'};
            data = {obj.temp_gp.trialn.(fname)};
            obj.now_color = colors;
            obj.line_trialn(data);
            obj.label('free trial number', ylab, leg);
            obj.now_color = [];
        end
        
        function line_pattern_idx(obj, data, idx)
            if ~iscell(idx)
                idx = {idx};
            end
            data = arrayfun(@(x)data(idx{x},:), 1:length(idx), 'UniformOutput',false);
            obj.line_pattern(data);
        end
        function line_pattern(obj, data)
            order = [1 2 4 7 3 6 5];
            data = cellfun(@(x)x(:,order), data, 'UniformOutput', false);
            obj.lineplot_raw(data);
            obj.lim([0.5 7.5],[]);
            leg = {'AAAB','AABA','AABB','ABAA','ABAB','ABBA','ABBB'};
            set(gca, 'XTick', 1:7, 'XTickLabel',...
                leg(order),'XTickLabelRotation', 45);
        end
        
        
        function line_trialn_idx(obj, data, idx)
            if ~iscell(idx)
                idx = {idx};
            end
            data = arrayfun(@(x)data(idx{x},:), 1:length(idx), 'UniformOutput',false);
            obj.line_trialn(data);
        end
        function line_trialn(obj, data)
            data = cellfun(@(x)x(:,5:10), data, 'UniformOutput', false);
            obj.lineplot_raw(data);
            obj.lim([0.5 6.5],[]);
        end
        function stat = line_direct(obj)
            gp = obj.temp_gp;
            obj.now_color = {obj.colors.AZcactus};
            stat = obj.line2(gp.p_hi_13);
            obj.label('horizon', 'p(high info)');   
            obj.temp_legloc = 'SouthEast'; 
            obj.legend({'[1 3]'});
            obj.yautotick(1, 0.1);
            obj.now_color = [];
        end
        function stat = line_random(obj, is13)
            gp = obj.temp_gp;
            if ~exist('is13') || isempty(is13) || is13 == 0
                data = gp.p_lm_22;
                obj.now_color = {obj.colors.AZsand};
                leg = {'[2 2]'};
            else
                data = {gp.p_lm_13,gp.p_lm_22};
                obj.now_color = {obj.colors.AZcactus,obj.colors.AZsand};
                leg = {'[1 3]','[2 2]'};
            end
            stat = obj.line2(data);
            obj.yautotick(1, 0.1);
            obj.label('horizon', 'p(low mean)');
            obj.temp_legloc = 'SouthEast';
            obj.legend(leg);
            obj.now_color = [];
        end
        function out = line_disagree_theory(obj, ylimit)
            disp('ploting disagree theory');
            obj.figure(1,2);
            obj.new;
            gp = obj.temp_gp;
            obj.setcolor({'AZcactus','AZmesa','AZriver'});
            pdata = gp.p_da13;
            [av(1,:), err(1,:)] = obj.getmeanandse(pdata);
            lm = gp.p_lm_13;
            pext = zeros(size(pdata,1), 2);
            [av(3,:), err(3,:)] = obj.getmeanandse(pext);
            pint = 1-(lm.*lm + (1-lm).*(1-lm));
            [av(2,:), err(2,:)] = obj.getmeanandse(pint);
            [stat{1} out{1}] = obj.ttest([pdata(:,1), pint(:,1)]);
            [stat{2} out{2}] = obj.ttest([pdata(:,2), pint(:,2)]);
            [stat{3} out{3}] = obj.ttest([pdata(:,1), pext(:,1)]);
            [stat{4} out{4}] = obj.ttest([pdata(:,2), pext(:,2)]);
            obj.lineplot(av, err);
            obj.lim([0.5 2.5]);
            mylim = [ylimit];
            obj.lim([], mylim);
            obj.temp_legloc = 'southeast';
            obj.legend({'behavioral data','internal only','external only'});
            obj.title('[1 3] condition');
            set(gca, 'tickdir', 'out');
            set(gca, 'XTick', 1:2, 'XTickLabel', [1 6]);
            set(gca, 'YTick', mylim(1):0.1:mylim(2));
            obj.xlabel('horizon');
            obj.ylabel('p(inconsistent)');
            obj.new;
            gp = obj.temp_gp;
            obj.setcolor({'AZsand','AZmesa','AZriver'});
            pdata = gp.p_da22;
            [av(1,:), err(1,:)] = obj.getmeanandse(pdata);
            lm = gp.p_lm_22;
            pext = zeros(size(pdata,1), 2);
            [av(3,:), err(3,:)] = obj.getmeanandse(pext);
            pint = 1-(lm.*lm + (1-lm).*(1-lm));
            [av(2,:), err(2,:)] = obj.getmeanandse(pint);
            [stat{5} out{5}] = obj.ttest([pdata(:,1), pint(:,1)]);
            [stat{6} out{6}] = obj.ttest([pdata(:,2), pint(:,2)]);
            [stat{7} out{7}] = obj.ttest([pdata(:,1), pext(:,1)]);
            [stat{8} out{8}] = obj.ttest([pdata(:,2), pext(:,2)]);
            
            %             pr = gp.p_r22;
            %             [av(3,:), err(3,:)] = obj.getmeanandse(1-(pr.*pr + (1-pr).*(1-pr)));
            %             [av(5,:), err(5,:)] = obj.getmeanandse(gp.p_da22_compare);
            %             [av(6,:), err(6,:)] = obj.getmeanandse(gp.p_da22_compare2);
            obj.lineplot(av, err);
            obj.lim([0.5 2.5]);
            obj.lim([], mylim);
            obj.temp_legloc = 'southeast';
            obj.legend({'behavioral data','internal only','external only'});
            obj.title('[2 2] condition');
            set(gca, 'tickdir', 'out');
            set(gca, 'XTick', 1:2, 'XTickLabel', [1 6]);
            set(gca, 'YTick', mylim(1):0.1:mylim(2));
            obj.xlabel('horizon');
            obj.ylabel('p(inconsistent)');
            obj.BobaddABCs();
            obj.save('theory_da_info');
            
            p1 = obj.temp_gp.p_da13;
            p2 = obj.temp_gp.p_da22;
            n = size(p1,1);
            td = [p1(:,1);p1(:,2);p2(:,1);p2(:,2)];
            subid = [obj.temp_gp.subjectID];
            subid = [subid;subid;subid;subid];
            chorizon = [ones(n,1);ones(n,1)*6;ones(n,1);ones(n,1)*6];
            cinfo = [ones(n,1);ones(n,1);ones(n,1)*2;ones(n,1)*2];
            anovan(td, {subid, chorizon, cinfo}, 'model',[1 0 0;0 1 0; 0 0 1; 0 1 1],...
                'varnames',{'Subject','H','Info'},'random',1) 
        end
        function stat = line_modelfree(obj, is13, israndomfirst)
            disp('plotting modelfree');
            is13 = SiyuTools.iif(~exist('is13') || isempty(is13) || is13 == 1, 1, 0);
            obj.figure(1,2);
            if exist('israndomfirst')
                stat.random = obj.line_random(is13);
                stat.direct = obj.line_direct;
            else
                stat.direct = obj.line_direct;
                stat.random = obj.line_random(is13);
            end
            obj.BobaddABCs;
            obj.save('modelfree');
        end
    end
end