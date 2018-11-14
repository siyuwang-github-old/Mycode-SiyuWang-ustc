classdef plot_subjectID < plot_horizonn
    properties
    end
    methods
        function obj = plot_subjectID()
        end
        function plot_daytime(obj, y, ylabel)
            if ischar(y)
                y = obj.temp_gp.(y);
            else
            end
            gp = obj.temp_gp;
            dcount = gp.dcount;
            time = gp.time;
            for yi = 1:size(y,2)
%                 obj.figure(1,2);
                obj.untitled_scatterbin(dcount, y(:,yi), {ylabel}, [0 20 40 60 80 100]);
                obj.xlabel('dcount');
                obj.ylabel(ylabel);
                obj.untitled_scatterbin(time, y(:,yi), {ylabel}, [6 10 12 14 16 20]);
                obj.xlabel('time');
                obj.ylabel(ylabel);
            end
        end
        function plot_daytimes(obj)
            obj.figure(2,2);
            obj.plot_daytime('p_hi_13','p(high info)');
            obj.plot_daytime('p_lm_22','p(low mean)');
            obj.figure(1,2);
            obj.plot_daytime( diff(obj.temp_gp.('p_hi_13')')', 'direct');
            obj.plot_daytime( diff(obj.temp_gp.('p_lm_22')')', 'random');
%             ac = obj.temp_gp.trialn(2).ac(:,10);
%             obj.plot_daytime(ac,'accuracy');
            gp = obj.temp_gp;
            hd = [gp.p_hi_13, gp.p_lm_22, diff(gp.p_hi_13')', ...
                diff(gp.p_lm_22')', gp.trialn(2).ac(:,10)];
            label1 = {'p(high info), h = 1', 'p(high info), h = 6', 'p(low mean), h = 1',...
                'p(low mean), h = 6', 'direct exploration', 'random exploration', 'accuracy'};
            dt = [gp.dcount gp.time];
            label2 = {'day count', 'time'};
%             mycorrplot_2(hd, dt, label1, label2);
            obj.corrtable(hd, dt, label1, label2);
        end
    end
end