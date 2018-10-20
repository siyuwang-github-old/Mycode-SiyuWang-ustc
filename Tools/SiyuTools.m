classdef SiyuTools < Siyuhandle
    properties
    end
    methods
        function obj = SiyuTools()
            
        end
        function x = chancexp(obj, n, p)
            ps = arrayfun(@(x)nchoosek(n,x)/2^n, 1:n);
            x = sum(cumsum(ps) <= 1-p)/n;
        end
    end
    methods(Static)
        function out = realnchoosek(n, k)
            out = gamma(n+1)/(gamma(n-k+1)*gamma(k+1));
        end
        function x = siyubound(x, LB, UB)
            if exist('LB') && ~isempty('LB')
                x(x < LB) = LB;
            end
            if exist('UB') && ~isempty('UB')
                x(x > UB) = UB;
            end 
        end
        function x = getnum(str)
            idx = regexp(str, '\d');
            if isempty(idx)
                x = NaN;
            else
                x = str2num(str(idx));
            end
        end
        function [result xx] = bin_average(y, x, bins)
            if size(bins,1) <= 2 && size(bins, 2) > 2;
                bins = bins';
            end
            if size(bins,2) == 1
                bins = [bins(1:end-1), bins(2:end)];
            end
            xx = mean(bins')';
            for bi = 1:size(bins,1)
                idx = x >= bins(bi,1) & x < bins(bi,2);
                [result.y(bi), result.err(bi)] = SiyuTools.getmeanandse(y(idx));
                result.num(bi) = sum(~isnan(y(idx)));
            end
        end
        function out = weightaverage(xs, w0)
            for xi = 1:size(xs,2)
                x = xs(:,xi);
                idxnan = isnan(x);
                x = x(~idxnan);
                w = w0(~idxnan);
                out(:, xi) = SiyuTools.iif(isempty(x), NaN, dot(x, w./sum(w)));
            end
        end
        function [av, se] = getmeanandse(a)
            if size(a,1) == 1 && size(a,2) > 1
                a = a';
            end
            if size(a,2) == 0
                a = NaN;
            end
            % get the mean and se for every column
            av = nanmean(a);
            se = nanstd(a)./sqrt(sum(~isnan(a),1));
        end
        function out = structurearraycat(a, names)
            if ~iscell(a)
                a = {a};
            end
            if ~exist('names')
                names = SiyuTools.getstructures(a);
            end
            out = [];
            for i = 1:length(a)
                if isempty(out)
                    out = SiyuTools.fillstructures(a{i}, names);
                else
                    tout = SiyuTools.fillstructures(a{i}, names);
                    out = horzcat(out, tout);
                end
            end
        end
        function out = fillstructures(a, names)
            out = arrayfun(@(x)SiyuTools.fillstructure(x, names), a);
        end
        function out = fillstructure(a, names)
            na = SiyuTools.getstructure(a);
            tidx = cellfun(@(x)sum(strcmp(na, x)), names);
            names = names(tidx == 0);
            for ni = 1:length(names)
                name = split(names{ni},'\');
                name = name(2:end);
                i = 1;
                t{1} = a;
                while isfield(t{i}, name{i})
                    t{i+1} = getfield(t{i}, name{i});
                    i = i + 1;
                end
                t{i} = setfield(t{i}, name{i},[]);
                j = i - 1;
                while(j>=1)
                    t{j} = setfield(t{j}, name{j}, t{j+1});
                    j = j - 1;
                end
                a = t{1}; 
            end
            out = a;
        end
        function names = getstructures(a)
            if ~iscell(a)
                a = {a};
            end
            names = {};
            for i = 1:length(a)
                if isempty(names)
                    names = SiyuTools.getstructure(a{i});
                else
                    tname = SiyuTools.getstructure(a{i});
                    tidx = cellfun(@(x)sum(strcmp(names, x)), tname);
                    names = [names; tname(tidx == 0)];
                end
            end
        end
        function out = getstructure(a)
            q = {a};
            i = 1;
            names = {''};
            while i <= length(q)
                aold = q{i};
                nameold = names{i};
                if (isstruct(aold))
                    fields = fieldnames(aold);
                    nfields = strcat(nameold, '\', fields);
                    tidx = cellfun(@(x)sum(strcmp(names, x)), nfields);
                    fields = fields(tidx == 0);
                    nfields = nfields(tidx == 0);
                    names = [names; nfields];
                    qnew = cellfun(@(x)getfield(aold, x), fields, 'UniformOutput', false);
                    q = [q; qnew];
                else
                end
                i = i + 1;
            end
            out = names(2:end);
        end

        function out = nanunique(x, arg) % not complete, can only take one argument
            x(isnan(x)) = inf;
            if ~exist('arg') || isempty(arg)
                x = unique(x);
            else 
                x = unique(x, arg);
            end
            x(x == inf) = NaN;
            out = x;
        end

        function out = iif(x, a, b)
            if (x)
                out = a;
            else
                out = b;
            end
        end
        function [rep, idx] = getrowindex(d0, d1) 
            % the number of occurences of rows of d1 in d0
            % d0(idx,:) = d1
            if isempty(d0)
                warning('the first matrix is empty');
                idx = cell(size(d1,1),0);
                rep = zeros(size(d1,1),0);
                return;
            end
            if (size(d0,2) ~= size(d1,2))
                error('two matrixes have to have the same number of columns');
            end
            idx = arrayfun(@(x)find(sum(abs(d0 - d1(x,:)),2) == 0),1:size(d1,1),'UniformOutput', false);
            rep = cellfun(@(x)length(x), idx);
        end
        function idx = getpermidx(a, b)
            % a(idx) = b;
            idx = arrayfun(@(x)SiyuTools.getcolumn(find(ismember(a, x)),1), b);
        end
        function y = getcolumn(x, n) 
            % extend columns with nans
            % exception 1: when there is 0 row, we flip row and column
            % exception 2: when there is 0 row and 0 column, we set the row
            % to be one
            if size(x,1) == 0 && size(x,2) ~= 0
                x = x';
            end
            if size(x,1) == 0
                y = nan(1,n);
            elseif size(x,2) < n
                y = [x nan(size(x,1), n- size(x,2))];
            else
                y = x(:,1:n);
            end
        end
        function d = addrow(d0, d1)
            % add a row to the end of a matrix
            if isempty(d0)
                d = d1;
                return;
            end
            d = vertcat(d0,d1);
        end
        function hour = time2hour(time)
            % convert timestamp of a task file to time of the day in hours
            % input: matrix
            % example:
            % time2hour(153000) = 15.5;
            hour = floor(time/10000) + floor(mod(time,10000)/100)/60 + ...
                floor(mod(time,100))/3600;
        end
        function [date time] = datestr2num(str)
            % convert datestr of a task file to date and time
            % input: a cell array
            % example:
            % datestr2num(20180911T144100) = [20180911 114100];
            if ischar(str)
                str = {str};
            end
            date = cellfun(@(x)str2num(x(1:8)), str);
            time = cellfun(@(x)str2num(x(10:15)), str);
        end
        function [day year] = date2day(date)
            % convert datestamp of a task file to day of the year
            % input: vector
            % output: vector
            % example:
            % date2day(20180201) = 32;
            year = floor(date/10000);
            date = mod(date, 10000);
            month = floor(date/100);
            day = mod(date,100);
            months = arrayfun(@(x)cumsum([0 31 28+leapyear(x) 31 30 31 30 ...
                31 31 30 31 30]),year,'UniformOutput',false);
            day = arrayfun(@(x)months{x}(month(x)) + day(x), 1:length(year));
            day = reshape(day, size(year));
        end
    end
end