classdef eyetribe_single < handle
    properties
        temp_data
        temp_message
        pd
        px
        py
        epoch
        ERP
    end
    methods
        function obj = eyetribe_single()
            obj.temp_data = [];
            obj.temp_message = [];
        end
        function load(obj, filename)
            obj.temp_data = [];
            obj.temp_message = [];
            disp(sprintf('importing %s', filename));
            ind_filename = max(strfind(filename, '.'));
            if isempty(ind_filename)
                filename = [filename, '.tsv'];
            end
            fid = fopen(filename);
            X = textscan(fid, '%s', 'delimiter', '\n');
            fclose(fid);
        %     X = {X{1}(1:end-1)};
            Y = strvcat(X{1});
            ind_mess = Y(:,1) == 'M';
            M = {X{1}{ind_mess}};
            Z = {X{1}{~ind_mess}};
            data.var_names = strsplit(strvcat(Z(1)))';
            M = {M};
            Z = {Z(2:end)};
        %     Nd = size(Z{1},2);
        %     Nm = size(M{1},2);
            A = strvcat(Z{:});
            B = textscan(A','%s%s%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');
            data.date = B{1};
            for i = 3:size(B,2)
                ts = data.var_names(i-1);
                data.(ts{1}) = B{i};
            end
            E = strvcat(B{2});
            sc = str2num(E(:,end-5:end));
            mn = str2num(E(:,end-8:end-7));
            hr = str2num(E(:,end-11:end-10));
        %     if (size(mn,1) < size(hr,1))
        %         mn(end+1) = nan;
        %     end
        %     if (size(sc,1) < size(hr,1))
        %         sc(end+1) = nan;
        %     end
            tm = hr*3600+mn*60+sc;
            data.hour = hr;
            data.minute = mn;
            data.second = sc;
            data.times = tm;
            C = strvcat(M{:});
            C(:,size(C,2)+1) = repmat(' ',size(C,1),1);
            D = textscan(C','%s%s%s%f%s');
            E = strvcat(D{3});
            sc = str2num(E(:,end-5:end));
            mn = str2num(E(:,end-8:end-7));
            hr = str2num(E(:,end-11:end-10));
        %     if (size(mn,1) < size(hr,1))
        %         mn(end+1) = nan;
        %     end
        %     if (size(sc,1) < size(hr,1))
        %         sc(end+1) = nan;
        %     end
            tm = hr*3600+mn*60+sc;
            message.date = D{2};
            message.second = sc;
            message.minute = mn;
            message.hour = hr;
            message.times = tm;
            message.time = D{4};
            message.string = D{5};
            obj.temp_data = data;
            obj.temp_message = message;
        end
        function preprocess(obj)
            tpd = [obj.temp_data.Lpsize, obj.temp_data.Rpsize]; 
            pd = obj.filter_out_blinks(tpd, 0.02);
            obj.pd = (pd-nanmean(pd))/nanstd(pd);
            tpx = [obj.temp_data.Lavgx, obj.temp_data.Ravgx];
            obj.px = obj.filter_out_blinks(tpx, 0);
            tpy = [obj.temp_data.Lavgy, obj.temp_data.Ravgy];
            obj.py = obj.filter_out_blinks(tpy, 0);
        end
        function [clean_pd] = filter_out_blinks(obj, pd, thresh)
            pd(pd==0) = nan;
            % remove points where two pupil diameters are out of whack
            if ~exist('thresh')
                thresh = 0.02;
            end
            [pdp, idx] = obj.remove_pd_outliers_NEW(diff(pd')', thresh);
            pd(idx, :) =  nan;
            
            pd = nanmean(pd,2);
            
            % window
            
            win = 100;
            for i = win+1:(length(pd)-(win))
                data = pd(i-win:i+win);
                if pd(i)>(nanmedian(data)+3*mad(data))
                    data_ind(i) = true;
                elseif pd(i)<(nanmedian(data)-3*mad(data));
                    data_ind(i) = true;
                else data_ind(i) = false;
                end
            end
            
            pd(data_ind) = nan;
            clean_pd = pd;
        end
        function [pdp, idxnan] = remove_pd_outliers_NEW(obj, pd, thresh)
            % remove top thresh and bottom thresh fraction of pds
            [s, ind] = sort(pd);
            t = [1:length(s)]/sum(~isnan(s));
            sp = s;
            sp((t<thresh) | (t>(1-thresh))) = nan;
            
            pdp(ind) = sp;
            idxnan = isnan(pdp);
        end
        function get_epoch(obj, markerlist)
            nm = length(markerlist);
            ind_list = [1:length(obj.temp_message.string)]';
            tm = obj.temp_message.times;
            for mi = 1:nm
                marker = markerlist{mi};
                ind{mi} = ind_list(strcmp(marker, obj.temp_message.string));
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
                obj.epoch(ei).marks = obj.temp_message.string([epoch{ei}(1):epoch{ei}(end)]);
                obj.epoch(ei).basemark = obj.temp_message.string([epoch{ei}]);;
                obj.epoch(ei).tm = obj.temp_message.times([epoch{ei}(1):epoch{ei}(end)]);
            end
        end
        function get_ERP(obj, marker, countm, tofinterest)%, baseline
            [tpre, tpost] = deal(tofinterest(1), tofinterest(2));
            epoch = obj.epoch;
            for mi = 1:length(epoch)
                indte = find(strcmp(marker, epoch(mi).marks));
                if length(indte) < countm
                    tt = NaN;
                    tmi(mi) = NaN;
                    tl = NaN;
                    tr = NaN;
                else
                    indte = indte(countm);
                    tt = epoch(mi).tm(indte);
                    tl = dsearchn(obj.temp_data.times, tt+tpre);
                    tr = dsearchn(obj.temp_data.times, tt+tpost);
                    tmi(mi) = dsearchn(obj.temp_data.times, tt);
                end
%                 indte = find(strcmp(baseline{1}, epoch(mi).marks));
%                 tb(1) = epoch(mi).tm(indte);
%                 indte = find(strcmp(baseline{2}, epoch(mi).marks));
%                 tb(2) = epoch(mi).tm(indte);
%                 tl = min(find(obj.tm >= tt - tpre));
%                   tr = max(find(obj.tm <= tt + tpost));
                
%                 tbl(mi) = min(find(obj.tm >= tb(1)));
%                 tbr(mi) = max(find(obj.tm <= tb(2)));
                npre(mi) = tl - tmi(mi);
                npost(mi) = tr - tmi(mi); 
            end
            n1 = round(nanmean(npre));
            n2 = round(nanmean(npost));
            for mi = 1:length(epoch)
                if isnan(tmi(mi))
                    ERP.ind(mi,:) = NaN(1, n2 - n1 + 1);
                    ERP.tm(mi,:) = NaN(1, n2 - n1 + 1);
                    ERP.pd(mi,:) = NaN(1, n2 - n1 + 1);
                    ERP.px(mi,:) = NaN(1, n2 - n1 + 1);
                    ERP.py(mi,:) = NaN(1, n2 - n1 + 1);
                else
                    ERP.ind(mi,:) = (tmi(mi) + n1) : (tmi(mi) + n2);
                    %                 ERP.baseind{mi} = tbl(mi):tbr(mi);
                    ERP.tm(mi,:) = [obj.temp_data.times(ERP.ind(mi,:))] - obj.temp_data.times(tmi(mi));
                    %                 ERP.lapse(mi) = obj.tm(tmi(mi)) - obj.tm(tmi(mi) + n1);
                    ERP.pd(mi,:) = obj.pd(ERP.ind(mi,:));
                    ERP.px(mi,:) = obj.px(ERP.ind(mi,:));
                    ERP.py(mi,:) = obj.py(ERP.ind(mi,:));
                end
            end
%             ERP.t0 = mean(ERP.lapse);
            obj.ERP.(marker){countm} = ERP;
        end
    end
end