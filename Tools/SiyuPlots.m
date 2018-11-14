classdef SiyuPlots < SiyuBasicPlots
    properties
    end
    methods
        function obj = SiyuPlots()
        end
        function statshade(obj, stats, x, y, w)
            if length(stats) ~= length(x)
                error('mismatch of length of x and stat');
                return;
            end
            n = length(stats);
            for ni = 1:n
                xi = x(ni);
                si = stats(ni);
                if si < 0.001
                    color = [obj.colors.AZsand];
                elseif si< 0.01
                    color = [obj.colors.AZcactus];
                elseif si < 0.05
                    color = [obj.colors.AZsky];
                else
%                     color = [obj.colors.red alpha];
                    continue;
                end
                obj.shade(xi,y,w,color);
            end
        end
        function shade(obj, x, y, w, color)
            hold on;
            fill([x-w x-w x+w x+w],[y(1) y(2) y(2) y(1)],color,'LineStyle','none');
            alpha(0.2);
            
        end

        function untitled_scatterbin(obj, x, y, xstr, xbins, clrs)
            obj.new;
            hold on;
            legs = [];
            color = obj.now_color;
            if ~iscell(color)
                color = {color};
            end
            if ~iscell(x)
                x = {x};
            end
%             obj.leglist = [];
            for xi = 1:length(x)
                tx = reshape(x{xi},[],1);
                ty = reshape(y,[],1);
                if ~isempty(color)
%                     scatter(tx, ty, obj.dotsize, color{xi}, 'filled');
                else
%                     scatter(tx, ty, obj.dotsize, 'filled');
                end
                hold on;
                [yy xx] = obj.bin_average(ty, tx, xbins);
                obj.now_color = clrs;
                obj.lineplot(yy.y, yy.err, xx);
                legs{xi*3 - 2} = 'lineplot';
                legs{xi*3 - 1} = xstr{xi};
                
%                 stat = obj.untitled_regression(tx, y);
%                 obj.leglist(end+1) = plot(stat.x, stat.ymodel, 'Color', 'r', 'LineWidth', obj.linewidth/2);
%                 legs{xi*3} = stat.str;
            end
        end
        function untitled_scattercorr(obj, y, x, xstr)
            obj.new;
            hold on;
            legs = [];
            color = obj.now_color;
            if ~iscell(x)
                x = {x};
            end
            for xi = 1:length(x)
                tx = reshape(x{xi},[],1);
                ty = reshape(y,[],1);
                if ~isempty(color)
                    sp = scatter(tx, ty, obj.dotsize, color{xi}, 'filled');
                else
                    sp = scatter(tx, ty, obj.dotsize, 'filled');
                end
                obj.leglist(end+1) = sp;
                legs{xi*2 - 1} = xstr{xi};
                stat = obj.untitled_regression(tx, y);
                obj.leglist(end+1) = plot(stat.x, stat.ymodel, 'Color', 'r', 'LineWidth', obj.linewidth/2);
                legs{xi*2} = stat.str;
            end
            obj.legend(legs);
        end
        function old_scatterdiag(obj, x, y, color, scalefactor)
            if ~exist('scalefactor') || isempty(scalefactor)
                scalefactor = 1;
            end
            if ~obj.holdon
                obj.new;
            end
            hold on;
            mi = min(min(x),min(y));
            ma = max(max(x),max(y));
            mi = mi - (ma-mi) * 0.1;
            ma = ma + (ma-mi) * 0.1;
            plot([mi, ma],[mi ma],'--k','LineWidth', obj.linewidth*scalefactor/5);
            sp = scatter(x, y, obj.dotsize*scalefactor*3, color, 'filled');
            obj.leglist = sp;
            stat = obj.old_correlation(x, y);
            obj.lim([mi,ma],[mi,ma])
            set(gca, 'tickdir', 'out');
%             obj.text(mi+0.05*(ma-mi), mi+0.9*(ma-mi), [stat.str]);
        end

        function lineplot_bin(obj, data, x, xbins)
            if ~obj.holdon
                obj.new;
            end
            color = obj.now_color;
            if ~iscell(color)
                color = {color};
            end
            if ~iscell(data)
                data = {data};
            end
            for di = 1:length(data)
                [te, xx] = SiyuTools.bin_average(data{di}, x{di}, xbins);
                [av(di,:), err(di,:)]  = deal(te.y, te.err);
            end
            obj.lineplot(av, err, xx);
        end
        function [av, err] = lineplot_raw(obj, data, x)
            if ~obj.holdon
                obj.new;
            end
            if ~iscell(data)
                data = {data};
            end
            if ~exist('x')
                x = 1:size(data{1},2);
            end
            for di = 1:length(data)
                [av(di,:), err(di,:)] = SiyuTools.getmeanandse(data{di});
            end
            obj.lineplot(av, err, x);
            if obj.isplotstar == 2 && length(data) == 2
                mm = obj.yceiling - obj.yfloor;
                for yi = 1:size(data{1},2)
                    d = arrayfun(@(x)data{x}(:,yi), 1:length(data),'UniformOutput',false);
                    stat(yi) = obj.ttest(d);
                end
                stars = obj.getstatstars(stat,' ');
                obj.sigstar(stat, x, obj.yceilingfixx + mm*obj.temp_starloc);
            end
            set(gca, 'tickdir','out');
            obj.holdon = false;
            obj.temp_starloc = obj.starloc;
        end
        function out = line2(obj, data)
            [av] = obj.lineplot_raw(data);
            if obj.isplotstar
                data = SiyuTools.iif(iscell(data), data, {data});
                if isempty(obj.temp_sigstar_y_direction)
                    di = repmat(obj.sigstar_y_direction,1,length(data));
                else
                    di = obj.temp_sigstar_y_direction;
                end
                for yi = 1:length(data)
                    [stat(yi) out(yi)] = obj.ttest(data{yi},1);
                    obj.sigstar_y({av(yi,:)},[stat(yi)],0,di(yi),[1 2], 0);
                end
            end
            set(gca, 'XTick', 1:2, 'XTickLabel', [1 6]);
            obj.lim([0.5 2.5]);
        end
    end
end