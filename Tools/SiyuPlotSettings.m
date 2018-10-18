classdef SiyuPlotSettings < Siyuhandle
    properties
        colors
        issave
        isshow
        figsize
        figgap
        figmargin
        figsizet
        figgapt
        figmargint
        fontsize_face
        fontsize_leg
        temp_fontsize_leg
        fontsize_axes
        linewidth
        dotsize
        ebcapsize
        eblinewidth
        savedir
        savesuffix
        savename
        isbold
        temp_gf
        temp_axi
        temp_axes
        temp_legloc
        holdon
        leglist
        legloc
        legbox
        now_color
        hardylim
        hardxlim
        yceiling
        yfloor
        yisfixx
        yceilingfixx
        yfloorfixx
    end
    methods
        function obj = SiyuPlotSettings()
            obj.issave = 1;
            obj.isshow = 1;
            obj.temp_gf = [];
            obj.holdon = false;
            obj.now_color = [];
            obj.hardxlim = {};
            obj.hardylim = {};
            obj.setparameter_plotdefault;
        end
        function setparameter(obj, isshow, issave, savedir, savename)
            if issave
                obj.savedir = fullfile(obj.siyupathfigure, savedir);
                obj.savename = savename;
            end
            obj.issave = issave;
            obj.isshow = isshow;
        end
        function flag = new(obj)
            if isempty(obj.temp_gf) || (obj.temp_axi >= length(obj.temp_axes))
                obj.figure;
            end
            if (obj.holdon)
                set(obj.temp_gf, 'CurrentAxes', obj.temp_axes(obj.temp_axi));
                hold on;
                return;
            else
                obj.temp_axi =  obj.temp_axi + 1;
                set(obj.temp_gf, 'CurrentAxes', obj.temp_axes(obj.temp_axi));
                set(gca, 'FontSize', obj.fontsize_face);
                obj.leglist = [];
            end
            obj.yceiling = [];
            obj.yfloor = [];
            obj.yceilingfixx = [];
            obj.yfloorfixx = [];
            obj.yisfixx = 1;
        end
        function setparameter_plotdefault(obj)
            colors.AZred = [171,5,32]/256;
            colors.AZblue = [12,35,75]/256;
            colors.AZcactus = [92, 135, 39]/256;
            colors.AZsky = [132, 210, 226]/256;
            colors.AZriver = [7, 104, 115]/256;
            colors.AZsand = [241, 158, 31]/256;
            colors.AZmesa = [183, 85, 39]/256;
            colors.AZbrick = [74, 48, 39]/256;
            colors.lightred = 0.5*colors.AZred + 0.5*ones(1,3);
            colors.lightblue = 0.5*colors.AZblue + 0.5*ones(1,3);
            colors.lightsky = 0.5*colors.AZsky + 0.5*ones(1,3);
            colors.lightcactus = 0.5*colors.AZcactus + 0.5*ones(1,3);
            colors.black = [0 0 0];
            colors.white = [1 1 1];
            obj.colors = colors;
            obj.figsize{1,1} = [0.2 0.15 0.5 0.8];
            obj.figmargin{1,1} = [0.15, 0.15, 0.05, 0.05];
            obj.figgap{1,1} = [0.1 0.1];
            obj.fontsize_leg{1,1} = 18;
            obj.figsize{1,2} = [0.1 0.15 0.7 0.7];
            obj.figmargin{1,2} = [0.15, 0.1, 0.1, 0.05];
            obj.figgap{1,2} = [0.1 0.1];
            obj.figsizet{1,2} = [0.1 0.15 0.7 0.7];
            obj.figmargint{1,2} = [0.15, 0.1, 0.1, 0.05];
            obj.figgapt{1,2} = [0.1 0.1];
            obj.fontsize_leg{1,2} = 18;
            obj.figsize{2,2} = [0.15 0.05 0.6 0.9];
            obj.figmargin{2,2} = [0.12, 0.1, 0.05, 0.05];
            obj.figgap{2,2} = [0.15 0.1];
            obj.figsizet{2,2} = [0.15 0.05 0.6 0.9];
            obj.figmargint{2,2} = [0.12, 0.1, 0.05, 0.05];
            obj.figgapt{2,2} = [0.15 0.1];
            obj.fontsize_leg{2,2} = 10;
            obj.figsize{1,3} = [0.02 0.15 0.96 0.7];
            obj.figmargin{1,3} = [0.15, 0.07, 0.1, 0.02];
            obj.figgapt{1,3} = [0.06 0.1];
            obj.figsizet{1,3} = [0.02 0.15 0.96 0.7];
            obj.figmargint{1,3} = [0.15, 0.07, 0.1, 0.02];
            obj.figgap{1,3} = [0.06 0.1];
            
            obj.fontsize_leg{1,3} = 10;

            obj.fontsize_face = 20;
            obj.temp_fontsize_leg = obj.fontsize_leg{1,1};
            obj.fontsize_axes = 20;
            obj.linewidth = 2;
            obj.dotsize = 5;
            obj.ebcapsize = 6;
            obj.eblinewidth = 1;
            obj.isbold = false;
            obj.legloc = 'NorthEast';
            obj.legbox = 0;
        end
        function [ax, g] = figure(obj, nx, ny, istitle, gap, margin, rect)
            if ~exist('istitle') || isempty(istitle)
                istitle = 0;
            end
            if (exist('nx')~=1) || isempty(nx) || nx < 1
                nx = 1;
            end
            if (exist('ny')~=1) || isempty(ny) || ny < 1
                ny = 1;
            end
            obj.temp_fontsize_leg = obj.fontsize_leg{nx,ny};
            if (exist('rect')~=1) || isempty(rect)
                rect = SiyuTools.iif(istitle, obj.figsizet{nx,ny},obj.figsize{nx,ny});
            end
            if (exist('margin') ~= 1) || isempty(margin)
                margin = SiyuTools.iif(istitle, obj.figmargint{nx,ny},obj.figmargin{nx,ny});
            end
            if (exist('gap') ~= 1) || isempty(gap)
                gap = SiyuTools.iif(istitle, obj.figgapt{nx,ny},obj.figgap{nx,ny});
            end
            hg = ones(1, nx+1) * gap(1);
            wg = ones(1, ny+1) * gap(2);
            hg(1) = margin(1);
            wg(1) = margin(2);
            hg(end) = margin(3);
            wg(end) = margin(4);
            hb = (ones(nx,1)-sum(hg)) / nx;
            wb = (ones(ny,1)-sum(wg)) / ny;
            if (obj.isshow)
                g = figure('visible','on');
            else
                g = figure('visible','off');
            end
            set(g, 'units','normalized','outerposition',rect);
            count = 1;
            for i_high = nx:-1:1
                for i_wide = 1:ny
                    bx(1) = sum(wg(1:i_wide)) + sum(wb(1:i_wide-1));
                    bx(2) = sum(hg(1:i_high)) + sum(hb(1:i_high-1));
                    bx(3) = wb(i_wide);
                    bx(4) = hb(i_high);
                    rc{count} = bx;
                    count = count + 1;
                end
            end
            for i = 1:length(rc)
                axes('position', rc{i})
                ax(i) = gca;
                if obj.isbold
                    set(gca, 'FontSize',obj.fontsize_axes,'FontWeight','Bold');
                else
                    set(gca, 'FontSize',obj.fontsize_axes);
                end
            end
            obj.temp_gf = g;
            obj.temp_axes = ax;
            obj.temp_axi = 0;
        end
        
        function xlabel(obj, x)
            xlabel(x, 'FontSize', obj.fontsize_face);
        end
        function ylabel(obj, x)
            ylabel(x, 'FontSize', obj.fontsize_face);
        end
        function title(obj, str)
            title(str,'FontWeight','normal','FontSize', obj.fontsize_face);
        end
        function lim(obj, x, y)
            if (exist('x')==1) && ~isempty(x)
                xlim(x);
            end
            if (exist('y')==1) && ~isempty(y)
                ylim(y);
            end
        end
        function label(obj, xlab, ylab, legs, legorder)
            obj.xlabel(xlab);
            obj.ylabel(ylab);
            if ~exist('legorder')
                legorder = [];
            end
            if exist('legs')
                obj.legend(legs, legorder);
            end
        end
        function legend(obj, leg, legorder)
            if ~exist('legorder') || isempty(legorder)
                legorder = 1:length(leg);
            end
            if isempty(obj.temp_legloc)
                obj.temp_legloc = obj.legloc;
            end
            fontsize = obj.temp_fontsize_leg;
            lgd = legend(obj.leglist(legorder),leg(legorder), 'Location', obj.temp_legloc);
            obj.leglist = [];
            if obj.legbox
                legend('boxon')
            else
                legend('boxoff');
            end
            lgd.FontSize = fontsize;
            obj.temp_legloc = [];
        end
        function xautotick(obj, n, step)
            xtick = get(gca, 'XTick');
            xdf = max(diff(xtick));
            set(gca, 'YTick', unique(round([xtick(1)-xdf],n):step:round(xtick(end)+xdf, n)))      
        end
        function yautotick(obj, n, step)
            ytick = get(gca, 'YTick');
            ydf = max(diff(ytick));
            set(gca, 'YTick', unique(round([ytick(1)-ydf],n):step:round(ytick(end)+ydf, n)));
        end
        function save(obj, filename)
            if (obj.issave)
                if isempty(obj.savename) && ~ischar(obj.savename)
                    error('set up savename first');
                end
                if ~isempty(obj.savename)
                    tsavename = ['_', obj.savename];
                else
                    tsavename = '';
                end
                filefolder = fullfile(obj.savedir);
                filefullpath = fullfile(filefolder,strcat(filename,tsavename, obj.savesuffix,'.png'));
                if ~exist(filefolder)
                    mkdir(filefolder);
                end
                saveas(obj.temp_gf, filefullpath, 'png');
                obj.temp_gf = [];
            end
            obj.hardxlim = {};
            obj.hardylim = {};
        end
        function hardlim(obj)
            i = obj.temp_axi;
            if i > 0 && length(obj.hardxlim) >= i
                obj.hardxlim{i};
            end
            if i > 0 && length(obj.hardylim) >= i
                obj.lim([],obj.hardylim{i});
            end
        end
        function sethardlim(obj, x, y)
            if ~exist('y')
                y = cell(length(x));
            end
            if ~iscell(y)
                y = {y};
            end
            if isempty(x)
                x = cell(length(y));
            end
            if ~iscell(x)
                y = {y};
            end
            obj.hardxlim = x;
            obj.hardylim = y;
        end
        function color = str2color(obj, str)
            if ~iscell(str)
                str = {str};
            end
            color = cellfun(@(x)obj.colors.(x),str,'UniformOutput',false);
        end
        function setcolor(obj, str)
            obj.now_color = obj.str2color(str);
        end
        function strs = str2gstr(obj, strs)
            if ~iscell(strs)
                strs = {strs};
            end
            strs = cellfun(@(x)obj.assist__str2gstr(x), strs, 'UniformOutput', false);
        end
        function x = assist__str2gstr(obj, x)
            x(x == '_') = ' ';
        end
        function [tb, pos] = BobaddABCs(obj, ax, offset, fontsize, abcString)
            % tb = addABCs(ax, offset, fontsize, abcString)
            %
            % Add letters to axes
            % Inputs:
            %   ax        - axes handles
            %   offset    - 2x1 vector of x-offset and y-offset of letter relative to
            %               default location in normalized units (optional default no
            %               offset)
            %   fontsize  - (optional default 20) size of fonts!
            %   abcString - (optional, default A through Z) if you want non-standard
            %               lettering or numbering of axes or lower case
            %               e.g. abcString = 'abcd';
            %
            % Output
            %   tb        -  vector of handles to textboxes containing ABCs
            
            % Robert Wilson
            % rcw2@princeton.edu
            % 10-Nov-2011
            if ~exist('ax') || isempty(ax)
                ax = obj.temp_axes;
            end
            if ~exist('abcString') || isempty(abcString)
                abcString = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
            end
            if ~exist('fontsize') || isempty(fontsize)
                fontsize = 30;
            end
            if exist('offset') && ~isempty(offset)
                for i = 1:length(ax)
                    pos(i,:) = get(ax(i), 'outerposition');
                end
                ABCpos = [pos(:,1)+offset(:,1) pos(:,2)+pos(:,4)+offset(:,2)];
            else
                for i = 1:length(ax)
                    pos(i,:) = get(ax(i), 'outerposition');
                end
                ABCpos = [pos(:,1) pos(:,2)+pos(:,4)];
            end
            for i = 1:length(ax)
                tb(i) = annotation('textbox');
                set(tb(i), 'fontsize', fontsize, 'fontweight', 'normal', ...
                    'margin', 0, 'horizontalAlignment', 'center', ...
                    'verticalAlignment', 'top', 'lineStyle', 'none')
                set(tb(i), 'fontunits', 'normalized')
                fs = get(tb(i), 'fontsize');
                set(tb(i), 'fontunits', 'points')
                set(tb(i), 'string', abcString(i))
                rec = [ABCpos(i,1)-fs/2 ABCpos(i,2)-fs fs fs];
                set(tb(i), 'position', rec)
            end
        end

    end
end

% function autolim(obj, mlimx, mlimy)
%             % incomplete function, only did for ylim
%             if ~isempty(mlimy)
%                 y1 = mlimy(1);
%                 y2 = mlimy(2);
%                 gap = (y2-y1);
%                 if gap == 0 && y1 ~= 0
%                     gap = abs(y1/2);
%                 elseif gap == 0 && y1 == 0
%                     gap = 1;
%                 end
%                 y2_lim = ceil((y2 + gap)*100)/100;
%                 y1_lim = floor((y1 - gap)*100)/100;
%                 obj.lim([], [y1_lim, y2_lim]);
%             end
%         end
%         