classdef analysis_eyetribe < handle
    properties
        message
        data
        basic
        tm
        epoch
        ERP
        pd
        px
        py
    end
    methods
        function obj = analysis_eyetribe(data, message)
            obj.data = data;
            obj.message = message;
            obj.prepareforanalysis;
            obj.process
        end
        function prepareforanalysis(obj)
            t0 = min([obj.data.times;obj.message.times]);
            obj.basic.starttime = t0;
            obj.data.times = obj.data.times - t0;
            obj.message.times = obj.message.times - t0;
            tm = obj.data.times;
            obj.basic.totallength = range(tm)/60;
            obj.basic.samplingRate_measured = 1/mode(diff(tm));
            obj.tm = tm;
            obj.data.fix = strcmp('True',obj.data.fix);
            obj.basic.fixrate = sum(obj.data.fix)/length(obj.data.fix);
        end
        function process(obj)
            tpd = [obj.data.Lpsize, obj.data.Rpsize]; 
            obj.pd = obj.filter_out_blinks(tpd, 0.02);
            tpx = [obj.data.Lavgx, obj.data.Ravgx];
            obj.px = obj.filter_out_blinks(tpx, 0.02);
            tpy = [obj.data.Lavgy, obj.data.Ravgy];
            obj.py = obj.filter_out_blinks(tpy, 0.02);
        end
        function [clean_pd] = filter_out_blinks(obj, pd)
            pd(pd==0) = nan;
            
            % remove points where two pupil diameters are out of whack
            thresh = 0.02;
            [~, idx] = remove_pd_outliers_NEW(pd(:,1)-pd(:,2), thresh);
            pd(idx, :) =  nan;
            
            pd = nanmean(pd,2);
            
            % window
            
            win = 100;
            for i = win+1:(length(pd)-(win+1))
                data = pd(i-win:i+win);
                if pd(i)>(nanmedian(data)+3*mad(data))
                    data_ind(i) = true;
                elseif pd(i)<(nanmedian(data)-3*mad(data));
                    data_ind(i) = true;
                else data_ind(i) = false;
                end
            end
            
            pd(data_ind) = nan;
        end
        function [pdp, idx] = remove_pd_outliers_NEW(obj, pd, thresh)
            
            
            % remove top thresh and bottom thresh fraction of pds
            [s, ind] = sort(pd);
            t = [1:length(s)]/sum(~isnan(s));
            sp = s;
            sp((t<thresh) | (t>(1-thresh))) = nan;
            
            pdp(ind) = sp;
            idx = isnan(pdp);
        end
        function get_epoch(obj, markerlist)
            nm = length(markerlist);
            ind_list = [1:length(obj.message.string)]';
            tm = obj.message.times;
            for mi = 1:nm
                marker = markerlist{mi};
                ind{mi} = ind_list(strcmp(marker, obj.message.string));
                tms{mi} = tm(ind{mi});
            end
            flag = true;
            nepoch = 0;
            i = 0;
            mi = ones(nm, 1);
            tnow = 0;
            clear epoch;
            while flag
                i = i + 1;
                if i == 1
                    tepoch = [];
                end
                while mi(i) <= length(ind{i}) & (ind{i}(mi(i)) <= tnow)
                    mi(i) = mi(i) + 1;
                end
                if mi(i) <= length(ind{i})
                    tepoch = [tepoch ind{i}(mi(i))];
                    tnow = ind{i}(mi(i));
                else
                    flag = false;
                    continue;
                end
                if i == nm
                    nepoch = nepoch + 1;
                    epoch{nepoch} = tepoch;
                    i = 0;
                end
            end
            for ei = 1:nepoch
                obj.epoch(ei).marks = obj.message.string([epoch{ei}(1):epoch{ei}(end)]);
                obj.epoch(ei).basemark = obj.message.string([epoch{ei}]);;
                obj.epoch(ei).tm = obj.message.times([epoch{ei}(1):epoch{ei}(end)]);
            end
        end
        function plot_ERP(obj, ind)
            pd = obj.ERP.pd;
            if nargin < 2
                ind = length(pd);
            end
            tm = obj.ERP.tm;
            pd = pd(ind,:);
            tm = tm(ind,:);
            av_pd = nanmean(pd);
            av_tm = nanmean(tm);
            std_pd = nanstd(pd);
            col = [0 1 1];
            hold on;
            shadedErrorBars(av_tm, av_pd, std_pd, col);
            plot(av_tm, av_pd);
        end
        function plot_px(obj, ind)
            pd = obj.ERP.px;
            if nargin < 2
                ind = length(pd);
            end
            tm = obj.ERP.tm;
            pd = pd(ind,:);
            tm = tm(ind,:);
            av_pd = nanmean(pd);
            av_tm = nanmean(tm);
            std_pd = nanstd(pd);
            col = [0 1 1];
            hold on;
            shadedErrorBars(av_tm, av_pd, std_pd, col);
            plot(av_tm, av_pd);
        end
        function plot_py(obj, ind)
            pd = obj.ERP.py;
            if nargin < 2
                ind = length(pd);
            end
            tm = obj.ERP.tm;
            pd = pd(ind,:);
            tm = tm(ind,:);
            av_pd = nanmean(pd);
            av_tm = nanmean(tm);
            std_pd = nanstd(pd);
            col = [0 1 1];
            hold on;
            shadedErrorBars(av_tm, av_pd, std_pd, col);
            plot(av_tm, av_pd);
        end
        function get_ERP(obj)
            ERP = obj.ERP;
            fnms = fieldnames(ERP);
            for fi = 1:length(fnms)
                fname = fnms{fi};
                pd = obj.pd;
                ind = obj.ERP.(fname).ind;
                baseind = obj.ERP.(fname).baseind;
                obj.ERP.(fname).pdraw = arrayfun(@(x)pd(x), ind);
                basepd = cellfun(@(x)nanmean(pd(x)), baseind)';
                obj.ERP.(fname).pd = obj.ERP.(fname).pdraw - repmat(basepd,1,size(obj.ERP.(fname).pdraw,2));
            end
        end
        function get_px(obj)
            ERP = obj.ERP;
            fnms = fieldnames(ERP);
            for fi = 1:length(fnms)
                fname = fnms{fi};
                px = obj.px;
                ind = obj.ERP.(fname).ind;
                obj.ERP.(fname).px = arrayfun(@(x)px(x), ind);
            end
        end
        function get_py(obj)
            ERP = obj.ERP;
            fnms = fieldnames(ERP);
            for fi = 1:length(fnms)
                fname = fnms{fi};
                py = obj.py;
                ind = obj.ERP.(fname).ind;
                obj.ERP.(fname).py = arrayfun(@(x)py(x), ind);
            end
        end
        function get_ERPtimes(obj, marker, countm, tpre, tpost, baseline)
            epoch = obj.epoch;
            for mi = 1:length(epoch)
                indte = find(strcmp(marker, epoch(mi).marks));
                indte = indte(countm);
                tt = epoch(mi).tm(indte);
                indte = find(strcmp(baseline{1}, epoch(mi).marks));
                tb(1) = epoch(mi).tm(indte);
                indte = find(strcmp(baseline{2}, epoch(mi).marks));
                tb(2) = epoch(mi).tm(indte);
                tl = min(find(obj.tm >= tt - tpre));
                tr = max(find(obj.tm <= tt + tpost));
                tbl(mi) = min(find(obj.tm >= tb(1)));
                tbr(mi) = max(find(obj.tm <= tb(2)));
                tmi(mi) = find(obj.tm == tt);
                npre(mi) = tl - tmi(mi);
                npost(mi) = tr - tmi(mi); 
            end
            n1 = min(npre);
            n2 = max(npost);
            for mi = 1:length(epoch)
                ERP.ind(mi,:) = (tmi(mi) + n1) : (tmi(mi) + n2);  
                ERP.baseind{mi} = tbl(mi):tbr(mi);
                ERP.tm(mi,:) = [obj.tm((tmi(mi) + n1) : (tmi(mi) + n2))] - obj.tm(tmi(mi));  
                ERP.lapse(mi) = obj.tm(tmi(mi)) - obj.tm(tmi(mi) + n1);
            end
            ERP.t0 = mean(ERP.lapse);
            obj.ERP.(marker) = ERP;
        end
    end
end
%         function [clean_pd] = filter_out_blinks(obj, pd, thresh)
%             pd(pd==0) = nan;
%             % remove points where two pupil diameters are out of whack
%             [~, idx] = obj.remove_pd_outliers_NEW(pd(:,1)-pd(:,2), thresh);
%             pd(idx, :) =  nan;
%             
%             pd = nanmean(pd,2);
%             
%             % window
%             
% %             win = 100;
% %             for i = win+1:(length(pd)-(win+1))
% %                 data = pd(i-win:i+win);
% %                 if pd(i)>(nanmedian(data)+3*mad(data))
% %                     data_ind(i) = true;
% %                 elseif pd(i)<(nanmedian(data)-3*mad(data));
% %                     data_ind(i) = true;
% %                 else data_ind(i) = false;
% %                 end
% %             end
% %             pd(data_ind,:) = nan;
%             clean_pd = pd;
%         end

%         function [pdp, idx] = remove_pd_outliers_NEW(obj, pd, thresh)
%             % remove top thresh and bottom thresh fraction of pds
%             [s, ind] = sort(pd);
%             t = [1:length(s)]/sum(~isnan(s));
%             sp = s;
%             sp((t<thresh) | (t>(1-thresh))) = nan;
%             
%             pdp(ind) = sp;
%             idx = isnan(pdp);
%         end