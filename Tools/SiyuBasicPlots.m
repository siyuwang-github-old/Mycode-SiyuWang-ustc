classdef SiyuBasicPlots < SiyuPlotStats
    properties
    end
    methods
        function obj = SiyuBasicPlots()
        end
        function scatter(obj, x, y, color)
            if (exist('color')~=1)
                color = [];
            end
            if ~iscell(y)
                y = {y};
            end
            obj.new;
            hold on;
            legs = [];
            for yi = 1:length(y)
                ty = reshape(y{yi},[],1);
                tx = reshape(x,[],1);
                if isempty(color)
                    sp = scatter(tx, ty, obj.dotsize, 'filled');
                else
                    sp = scatter(tx, ty, obj.dotsize, color{yi}, 'filled');
                end
                obj.leglist(end+1) = sp;
            end
        end

        function lineplot(obj, av, err, x)
            if (exist('x')~=1) || isempty(x)
                x = 1:size(av, 2);
            end
            color = obj.now_color;
            hold on;
            for li = 1:size(av,1)
                eb = errorbar(x, av(li,:), err(li,:), 'o-', ...
                    'LineWidth', obj.eblinewidth);
                if ~isempty(color) && length(color) == size(av,1)
                    eb.Color = color{li};
                    eb.MarkerFaceColor = color{li};
                end
                eb.CapSize = obj.ebcapsize;
                obj.leglist(end + 1) = eb;
            end
            maxy = max(av(:)+err(:));
            miny = min(av(:)-err(:));
            if obj.yisfixx
                obj.yceilingfixx = max(vertcat(obj.yceilingfixx, maxy),[],1);
                obj.yfloorfixx = min(vertcat(obj.yfloorfixx, miny),[],1);
            else
                obj.yceilingfixx = maxy;
                obj.yfloorfixx = miny;
            end
            obj.yceiling = max(horzcat(obj.yceiling, maxy));
            obj.yfloor = min(horzcat(obj.yfloor, miny));
            
%             hold off;
            obj.hardlim;
            obj.now_color = [];
        end

    end
end