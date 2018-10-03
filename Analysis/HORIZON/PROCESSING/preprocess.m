function data = preprocess(data)
    disp('Preprocessing');
    % datadir = 'W:\LAB\DATAMAT';
    % data = importdata(fullfile(datadir, 'data_1_compiled.mat'));
    % exps = unique(arrayfun(@(x)x.info_exp, data, 'UniformOutput', false));
    startdate = [20150126 20150831 20160125 20160829 20170124 20170828 20180122 20180827];
    enddate = [20150506 20151209 20160504 20161207 20170503 20171206 20180502 20181205];
    for si = 1:length(data)
        disp(sprintf('...processing subject %d/%d', si, length(data)));
        d = data(si);
        ddate = d.datestr_dateonfile;
        [data(si).day data(si).year] = SiyuTools.date2day(ddate);
        if ~isempty(ddate)
            idxdate1 = sum(startdate <= ddate);
            idxdate2 = sum(enddate < ddate) + 1;
            if idxdate1 ~= idxdate2
                data(si).dcount = NaN;
                warning('the running time is outside any regular semester');
            else
                data(si).dcount = data(si).day - SiyuTools.date2day(startdate(idxdate1));
            end
        else
            data(si).dcount = NaN;
        end
        data(si).time = SiyuTools.time2hour(d.timestr_timeonfile);
        game = d.game;
        if ~isnumeric(d.info_session)
            data(si).info_session = NaN;
            warning('info_session not numeric');
        end
        %%active/passive
        RT = game.RT_recorded;
        if (isempty(RT)) || size(RT,2) < 10 || any(any(isnan(RT(:,1:4))))
            data(si).cond_exp = 'Missing';
            data(si).num_cond_exp = NaN;
        elseif sum(any(RT(:,1:4)~=0)) == 0
            data(si).cond_exp = 'Passive';
            data(si).num_cond_exp = 0;
        elseif sum(any(RT(:,1:4)==0)) == 0
            data(si).cond_exp = 'Active';
            data(si).num_cond_exp = 1;
        else
            data(si).cond_exp = 'Error';
            data(si).num_cond_exp = inf;
        end
        delaytimes = strcat('delaytime_',{'R2K','B2K','R2B'});
        for delayi = 1:length(delaytimes)
            delaytime = delaytimes{delayi};
            if isempty(game.(delaytime))
                data(si).(strcat('cond_',delaytime)) = NaN;
            else
                data(si).(strcat('cond_',delaytime)) = nanmean(game.(delaytime)(:,5));
            end
        end
        key = game.key;
        game.cond_horizon = sum(~isnan(key),2); % horizon condition
        rewards = game.rewards;
        for i = 1:2 %bandit number
            rewards{i} = rewards{i} + key * 0;
            rewards{i}(isnan(rewards{i}) & ~isnan(key)) = 0;
            %%gained reward
            R{i} = rewards{i}.*(key == sign(i-1.5));
            cumR{i} = cumsum(R{i},2);
            cumKey{i} = cumsum((key == sign(i-1.5)),2) + 0*key;
            %%mean reward
            avR{i} = cumR{i}./cumKey{i};
        end
        game.R_chosen = R{1} + R{2};
        game.R_unchosen = rewards{1} + rewards{2} - game.R_chosen;
        game.R = R;
        game.cumR = cumR;
        game.cumKey = cumKey;
        game.avR = avR;
        game.dfR_empirical = avR{2} - avR{1};
        game.dfcumKey = cumKey{2} - cumKey{1};
        game.cond_info = -sign(game.dfcumKey(:,4)); % more informative
        %%choice low mean
        lm = -sign(game.dfR_empirical);
        lm(lm == 0) = NaN;
        game.lm = lm;
        c_lm = 1 - abs(lm(:,1:end-1) - game.key(:,2:end))/2;
        game.c_lm = [repmat(NaN,size(c_lm,1),1) c_lm];
        %%choice high info
        info = -sign(game.dfcumKey);
        info(info == 0) = NaN;
        game.hi = info;
        c_hi = 1 - abs(info(:,1:end-1) - game.key(:,2:end))/2;
        game.c_hi = [repmat(NaN,size(c_hi,1),1) c_hi];
        %%choice correct
        correct = diff(game.underlyingMean')';
        correct = sign(correct);
        correct(correct == 0) = NaN;
        c_ac = 1 - abs(correct - game.key)/2;
        %%choice right
        game.c_ac = c_ac;
        game.c_r = (game.key == 1) + (0 * game.key);
        game.dfR4_empirical = game.dfR_empirical(:,4);
        game.dfR_chosen = game.dfR_empirical.*key;
        game.dfR4_chosen = game.dfR_chosen(:,5);
        game.dfR_info = game.dfR_empirical.*game.hi;
        game.dfR4_info = game.dfR_info(:,4);
        %%pattern
        game.c_sw = [repmat(NaN,size(key,1),1) (diff(key')' ~= 0)];
        game.pattern_directional = (key(:,1:4) == 1)*([8 4 2 1]');
        game.pattern = min([game.pattern_directional,15 - game.pattern_directional], [],2);
        %%repeated
        [game.repeat_id,game.repeat_order] = assist__preprocess_getrepeatedID(rewards);
%         idx_gamerp1 = (game.repeat_id > 0) & (game.repeat_order == 1);
%         idx_gamerp2 = (game.repeat_id > 0) & (game.repeat_order == 2);
        game.repeat_agree = assist__preprocess_getrepeatedagree(game.repeat_id, key(:,5));

        data(si).game = game;
    end
% save(fullfile(datadir, 'data_2_preprocessed'),'data');
% delete(fullfile(datadir, 'data_3_withindmeasure.mat'));
% delete(fullfile(datadir, 'data_4_gpindmeasure.mat'));
% disp('completed');
end
%%


%     game.c_acempirical = c_ac;
%     game.c_ac = 1-abs(game.key - sign(diff(game.underlyingMean')'))/2;

%    
%    if ~isempty(game.underlyingMean)
%         [~, ~, game.repeat_similar_id] = unique([game.pattern_directional, ...
%             game.underlyingMean, game.repeat_order], 'row');
%         tid = arrayfun(@(x)sum(x == game.repeat_similar_id) ~= 2,game.repeat_similar_id);
%         game.repeat_similar_id(tid) = -game.repeat_similar_id(tid);
%         game.repeat_compare_agree = preprocess_getrepeatedagree(game.repeat_similar_id, key(:,5));
%     end
%  
%     if ~isempty(game.startT)
%         st = game.startT(:,1);
%         st1 = st(idx_gamerp1);
%         st2 = st(idx_gamerp2);
%         game.dt_repeat = (st2-st1);
%         data(si).avdt_repeat = mean(game.dt_repeat);
%     end
%     d4 = game.dfavR4;
%  pt = [game.pattern_directional];
%     rpid = [game.repeat_id];
%     [teod, tid] = sortrows([d4, pt, rpid], [2 1]);
%     newpair = NaN(length(tid),1);
%     count = 1;
%     for ti = 1:(length(tid))
%         trow = tid(ti);
%         if ~isnan(newpair(trow))
%             continue;
%         end
%         j = ti + 1;
%         while (j <= length(tid)) && (~isnan(newpair(tid(j))) || rpid(trow) == rpid(tid(j)))
%             j = j + 1;
%         end
%         if j > length(tid)
%             newpair(trow) = -count;
%             count = count + 1;
%             continue;
%         end
%         trow2 = tid(j);
%         if (pt(trow) == pt(trow2)) && abs(d4(trow) - d4(trow2)) <= 3 && rpid(trow) ~= rpid(trow2)
%             newpair(trow) = count;
%             newpair(trow2) = count;
%             count = count + 1;
%             continue;
%         end
%         newpair(trow) = -count;
%         count = count + 1;
%     end
%     game.repeat_compare_agree2 = preprocess_getrepeatedagree(newpair, key(:,5));
% %     tt = [game.repeat_id, game.pattern_directional, game.dfavR4, newpair, game.repeat_compare_agree];
% 

%   data(si).num_exp = find(strcmp(exps, data(si).exp));
%     %%demographic info
%     if length(d.age) == 0
%         data(si).age = NaN;
%     end
%     if ischar(d.age)
%         data(si).age = str2num(d.age);
%     end
%     if length(d.race) == 0
%         data(si).race = NaN;
%     elseif length(d.race) > 1
%         data(si).race = inf;
%     end
%     if length(d.gender) == 0
%         data(si).gender = NaN;
%     elseif length(d.gender) > 1
%         data(si).gender = inf;
%     end
%     if length(d.ethnicity) == 0
%         data(si).ethnicity = NaN;
%     elseif length(d.ethnicity) > 1
%         data(si).ethnicity = inf;
%     end
%     if strcmp(data(si).site, 'Arizona')
%         data(si).num_site = 1;
%     elseif strcmp(data(si).site, 'Princeton')
%         data(si).num_site = 2;
%     else
%         data(si).num_site = NaN;
%     end