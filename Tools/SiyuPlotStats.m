classdef SiyuPlotStats < SiyuPlotSettings & SiyuStatistics
    properties
        isplotstar
        starloc
        sigstar_y_direction
        temp_starloc
        temp_sigstar_y_direction
    end
    methods
        function obj = SiyuPlotStats()
            obj.isplotstar = 2;
            obj.starloc = 0.05;
            obj.sigstar_y_direction = 1;
            obj.temp_starloc = obj.starloc;
        end
        function sigstar(obj, stats, x, y)
            if exist('x') ~= 1 || isempty(x)
                x = 1:length(y);
            end
            stars = obj.getstatstars(stats, ' ');
            text(x,y,stars,...
                'HorizontalAlignment','center',...
                'BackGroundColor','none',...
                'Tag','sigstar_stars','FontSize',20);
        end
        function varargout=sigstar_y(obj, groups, stats, nosort, side, xgroups, nolevel)
            % sigstar - Add significance stars to bar charts, boxplots, line charts, etc,
            %
            % H = sigstar(groups,stats,nsort)
            %
            % Purpose
            % Add stars and lines highlighting significant differences between pairs of groups.
            % The user specifies the groups and associated p-values. The function handles much of
            % the placement and drawing of the highlighting. Stars are drawn according to:
            %   * represents p<=0.05
            %  ** represents p<=1E-2
            % *** represents p<=1E-3
            %
            %
            % Inputs
            % groups - a cell array defining the pairs of groups to compare. Groups defined
            %          either as pairs of scalars indicating locations along the X axis or as
            %          strings corresponding to X-tick labels. Groups can be a mixture of both
            %          definition types.
            % stats -  a vector of p-values the same length as groups. If empty or missing it's
            %          assumed to be a vector of 0.05s the same length as groups. Nans are treated
            %          as indicating non-significance.
            % nsort -  optional, 0 by default. If 1, then significance markers are plotted in
            %          the order found in groups. If 0, then they're sorted by the length of the
            %          bar.
            %
            % Outputs
            % H - optionally return handles for significance highlights. Each row is a different
            %     highlight bar. The first column is the line. The second column is the text (stars).
            %
            %
            % Examples
            % 1.
            % bar([5,2,1.5])
            % sigstar({[1,2], [1,3]})
            %
            % 2.
            % bar([5,2,1.5])
            % sigstar({[2,3],[1,2], [1,3]},[nan,0.05,0.05])
            %
            % 3.  **DOESN'T WORK IN 2014b**
            % R=randn(30,2);
            % R(:,1)=R(:,1)+3;
            % boxplot(R)
            % set(gca,'XTick',1:2,'XTickLabel',{'A','B'})
            % H=sigstar({{'A','B'}},0.01);
            % ylim([-3,6.5])
            % set(H,'color','r')
            %
            % 4. Note the difference in the order with which we define the groups in the
            %    following two cases.
            % x=[1,2,3,2,1];
            % subplot(1,2,1)
            % bar(x)
            % sigstar({[1,2], [2,3], [4,5]})
            % subplot(1,2,2)
            % bar(x)
            % sigstar({[2,3],[1,2], [4,5]})
            %
            % ALSO SEE: demo_sigstar
            %
            % KNOWN ISSUES:
            % 1. Algorithm for identifying whether significance bar will overlap with
            %    existing plot elements may not work in some cases (see line 277)
            % 2. Bars may not look good on exported graphics with small page sizes.
            %    Simply increasing the width and height of the graph with the
            %    PaperPosition property of the current figure should fix things.
            %
            % Rob Campbell - CSHL 2013
            
            
            
            %Input argument error checking
            switch side
                case 'left'
                    side = -1;
                case 'right'
                    side = 1;
            end
            %If the user entered just one group pair and forgot to wrap it in a cell array
            %then we'll go easy on them and wrap it here rather then generate an error
            if exist('nolevel') ~= 1 || isempty(nolevel)
                nolevel = 0;
            end
            if exist('stats') ~= 1 || isempty(stats)
                stats = repmat(0.05,1,length(groups));
            end
            if exist('nosort') ~= 1 || isempty(nosort)
                nosort=0;
            end
            %Check the inputs are of the right sort
            if ~iscell(groups)
                error('groups must be a cell array')
            end
            if ~isvector(stats)
                error('stats must be a vector')
            end
            if length(stats) ~= length(groups)
                error('groups and stats must be the same length')
            end
            %Each member of the cell array groups may be one of three things:
            %1. A pair of indices.
            %2. A pair of strings (in cell array) referring to X-Tick labels
            %3. A cell array containing one index and one string
            %
            % For our function to run, we will need to convert all of these into pairs of
            % indices. Here we loop through groups and do this.
            xlocs = nan(length(groups),2); %matrix that will store the indices
%             xtl = get(gca,'XTickLabel');
            for ii=1:length(groups)
                grp = groups{ii};
                xlocs0(ii,:) = grp; %Just store the indices if they're the right format already
                xlocs(ii,:)=sort(xlocs0(ii,:));
            end
            %If there are any NaNs we have messed up.
            if any(isnan(xlocs(:)))
                error('Some groups were not found')
            end
            %Optionally sort sig bars from shortest to longest so we plot the shorter ones first
            %in the loop below. Usually this will result in the neatest plot. If we waned to
            %optimise the order the sig bars are plotted to produce the neatest plot, then this
            %is where we'd do it. Not really worth the effort, though, as few plots are complicated
            %enough to need this and the user can define the order very easily at the command line.
            if ~nosort
                [~,ind]=sort(xlocs(:,2)-xlocs(:,1),'ascend');
                xlocs = xlocs(ind,:);
                groups = groups(ind);
                stats = stats(ind);
            end
            %-----------------------------------------------------
            %Add the sig bar lines and asterisks
            holdstate = ishold;
            hold on
            H = ones(length(groups),2); %The handles will be stored here
            x = ylim;
            dist = 0.03;
            rg = range(xlim);
            yd = rg*dist; %separate sig bars vertically by 5%
            for ii=1:length(groups)
                thisY = obj.getmax_xlim(xlocs(ii,:), side);
                if nolevel == 0
                    thisY = thisY + side*yd;
                end
                if ii == 1
                    thisY = thisY + side*rg*0.1;
                end
                [H(ii,:), dist] = obj.makeSignificanceBar_y(thisY, xlocs(ii,:), side, stats(ii));
                for yj = 1:size(xlocs,2)
                    XXX = sort([thisY,xgroups(ii,yj)]);
                    XXX = XXX(1):0.05:XXX(2);
                    plot([XXX],repmat(xlocs0(ii,yj),size(XXX,1),size(XXX,2)),'.k','LineWidth',0.5);
                end
            end
            %-----------------------------------------------------
            %Now we can add the little downward ticks on the ends of each line. We are
            %being extra cautious and leaving this it to the end just in case the y limits
            %of the graph have changed as we add the highlights. The ticks are set as a
            %proportion of the y axis range and we want them all to be the same the same
            %for all bars.
            yd = range(xlim)*0.01; %Ticks are 1% of the y axis range
            for ii = 1:length(groups)
                x=get(H(ii,1),'XData');
                x(1)=x(1)-side*yd;
                x(4)=x(4)-side*yd;
                set(H(ii,1),'XData',x)
            end
            %Be neat and return hold state to whatever it was before we started
            if ~holdstate
                hold off
            elseif holdstate
                hold on
            end
            %Optionally return the handles to the plotted significance bars (first column of H)
            %and asterisks (second column of H).
            if nargout>0
                varargout{1}=H;
            end
        end %close sigstar
        function [H,dist]=makeSignificanceBar_y(obj,x,y,side,p)
            %makeSignificanceBar produces the bar and defines how many asterisks we get for a
            %given p-value
            stars = obj.getstatstars(p);
            x=repmat(x,4,1);
            y=repmat(y,2,1);
            H(1)=plot(x,y(:),'-k','LineWidth',0.5,'Tag','sigstar_bar');
            
            %Increase offset between line and text if we will print "n.s."
            %instead of a star.
            if ~isnan(p) && p <= 0.05
                offset=0.001;
                dist = 0.04;
            else
                offset=0.01;
                dist = 0.04;
            end
            
            starX = mean(x)+ side * range(xlim)*offset;
            H(2) = text(starX,mean(y(:)),stars,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','baseline',...
                'BackGroundColor','none',...
                'Tag','sigstar_stars','FontSize',20);
            set(H(2),'Rotation',180 + 90*side);
            
            X=xlim;
            if starX*side > side*(side*max(side*X)+side*range(X)*0.05) 
                xnew = sort([starX+side*range(X)*0.05 side*max(side*X)+side*range(X)*0.05 X]);
                xlim([xnew(1) xnew(3)]);
            end
            
            
        end %close makeSignificanceBar
        function Y=getmax_xlim(obj, x, side)
            % The significance bar needs to be plotted a reasonable distance above all the data points
            % found over a particular range of X values. So we need to find these data and calculat the
            % the minimum y value needed to clear all the plotted data present over this given range of
            % x values.
            %
            % This version of the function is a fix from Evan Remington
            oldXLim = get(gca,'XLim');
            oldYLim = get(gca,'YLim');
            axis(gca,'tight');
            set(gca,'ylim',x) %Matlab automatically re-tightens y-axis
            xLim = get(gca,'XLim'); %Now have max y value of all elements within range.
            Y = side*max(xLim*side);
            axis(gca,'normal')
            set(gca,'XLim',oldXLim,'YLim',oldYLim)
        end %close getmax_xlim

    end
end