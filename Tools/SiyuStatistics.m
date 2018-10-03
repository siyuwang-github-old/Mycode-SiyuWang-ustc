classdef SiyuStatistics < SiyuTools
    properties
        ispairedttest
    end
    methods
        function obj = SiyuStatistics()
            obj.ispairedttest = [false false];
        end
        function stats = untitled_getgpanova(obj, gps)
            n = length(gps);
            if n == 1
                stats = nan(1,size(gps{1},2));
                return;
            elseif n == 0
                stats = [];
                return;
            end
            nx = cellfun(@(x)size(x,2), gps);
%             if length(unique(nx)) > 1
%                 stats = [];
%                 error('number of columns mismatch for anova')
%                 return;
%             else
%                 nx = unique(nx);
%             end
            nx = unique(nx);
            maxx = max(nx);
            minx = min(nx);
            gps = cellfun(@(x)obj.getcolumn(x, maxx), gps, 'UniformOutput', false);
            for xi = 1:maxx
                ys = cellfun(@(x)x(:,xi), gps, 'UniformOutput', false);
                ys = vertcat(ys{:});
                xs = cellfun(@(x)ones(size(x,1),1), gps, 'UniformOutput', false);
                xs = arrayfun(@(x)xs{x}*x, 1:n, 'UniformOutput',false);
                xs = vertcat(xs{:});
                xs = xs(~isnan(ys));
                ys = ys(~isnan(ys));
                if ~isempty(xs)
                    [tp, ta, tstat] = anova1(ys, xs, 'off');
                    stats(1,xi) = tp;
                    stats(2,xi) = ta{2,5};
                else
                    stats(1,xi) = NaN;
                    stats(2,xi) = NaN;
                end
            end
%             stats = obj.extendnan(stats, maxx);
        end

        function stars1 = getstatstars(obj, p0, nons)
            if ~exist('nons') 
                nons = 'n.s.';
            end
            for i = 1:size(p0,1)
                for j = 1:size(p0,2)
                    p = p0(i,j);
                    if p<=1E-3
                        stars='***';
                    elseif p<=1E-2
                        stars='**';
                    elseif p<=0.05
                        stars='*';
                    elseif p > 0.05
                        stars=nons;
                    else
                        stars=' ';
                    end
                    stars1{i,j} = stars;
                end
            end
        end

        function out = untitled_correlation(obj, x, y)
            x = reshape(x,[],1);
            y = reshape(y,[],1);
            [r,p] = corr(x,y);
            out.r = r;
            out.r2 = r*r;
            out.p = p;
%             out.str = sprintf('R^2 = %.2f, p  = %.2g',out.r2,p);
            out.str = sprintf('R = %.2f, p  = %.2g',out.r,p);
        end
        
        function out = untitled_regression(obj, x, y)
            x = reshape(x,[],1);
            y = reshape(y,[],1);
            [r,m,b] = regression(x',y');
            out = obj.untitled_correlation(x,y);
            out.m = m;
            out.b = b;
            out.x = x;
            out.y = y;
            out.ymodel = x*m + b;
        end
        function [p out] = ttest(obj, data, hv)
            if ~exist('hv')
                hv = 2;
            end
            if obj.ispairedttest(hv)
                if iscell(data)
                    data = [data{1}, data{2}];
                end
                [~,p,~,stat] = ttest(diff(data')');
            else
                [~,p,~,stat] = ttest2(data{1}, data{2});
            end
            out.p = p;
            out.t = stat.tstat;
            out.df = stat.df;
            out.str = sprintf('t(%d) = %.2f, p = %.3g', out.df, out.t, out.p);
        end

    end
end