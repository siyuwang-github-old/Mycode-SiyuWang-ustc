classdef plot_horizon < SiyuPlots & stat_horizon
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
        function line_direct(obj)
            gp = obj.temp_gp;
            obj.now_color = {obj.colors.AZcactus};
            obj.line2(gp.p_hi_13);
            obj.label('horizon', 'p(high info)');
            obj.now_color = [];
        end
        function line_random(obj, is13)
            gp = obj.temp_gp;
            if ~exist('is13') || isempty(is13) || is13 == 0
                data = gp.p_lm_22;
                obj.now_color = {obj.colors.AZsand};
            else
                data = {gp.p_lm_22, gp.p_lm_13};
                obj.now_color = {obj.colors.AZsand, obj.colors.AZcactus};
            end
            obj.line2(data);
            obj.label('horizon', 'p(low mean)');
            obj.now_color = [];
        end
        function line_modelfree(obj, is13)
            is13 = SiyuTools.iif(~exist('is13') || isempty(is13) || is13 == 1, 1, 0);
            obj.figure(1,2);
            obj.line_direct;
            obj.line_random(is13);
            obj.save;
        end
    end
end