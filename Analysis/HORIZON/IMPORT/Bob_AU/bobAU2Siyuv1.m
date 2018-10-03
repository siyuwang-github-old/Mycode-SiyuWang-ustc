function bobAU2Siyuv1(ddata, savedir, savename, expname)
% try
    for datai = 1:length(ddata)
        disp(['processing data', num2str(datai)]);
        dd = ddata(datai);
        d = dd.game;
        N = length(d);
        d = d(1:N);   
        game.num_game = N;
        game.info_exp = expname;
        game.info_expsavename = savename;
        game.info_site = 'Arizona';
        game.subjectID = dd.subjectID;
        tm = ddata(datai).savename(end-15:end);
        if strcmp(tm(1),'_')
            tm = tm(2:end);
            [game.datestr_dateonfile,game.timestr_timeonfile] = SiyuTools.datestr2num(tm);
        else
            game.datestr_dateonfile = SiyuTools.datestr2num(datestr(tm(1:9),30));
            game.timestr_timeonfile = str2num(tm(end-5:end));
        end
        if isstruct(dd.answers)
            game.demo_age = dd.answers.age;
            if ischar(game.demo_age)
                game.demo_age = str2num(game.demo_age);
            elseif isempty(game.demo_age)
                game.demo_age = NaN;
            end
            if game.demo_age >= 1990
                [~,year] = SiyuTools.date2day(game.datestr_dateonfile);
                game.demo_age = year - game.demo_age;
            end
            if game.demo_age >= 115 && game.demo_age <= 119
                game.demo_age = game.demo_age - 100;
            end
            game.demo_gender = dd.answers.gender.answer;
            game.demo_race = dd.answers.race.answer;
            game.demo_ethnicity = dd.answers.ethnicity.answer;
        else
            game.demo_age = NaN;
            game.demo_gender = NaN;
            game.demo_race = NaN;
            game.demo_ethnicity = NaN;
        end
        game.info_session = dd.sessionNum;

        st = SiyuTools;
        
        Mcell = arrayfun(@(x)st.getcolumn(x.mean',2),d,'UniformOutput',false);
        game.game.underlyingMean = vertcat(Mcell{:});
        
        RTcell = arrayfun(@(x)st.getcolumn(x.RT,10),d,'UniformOutput',false);
        game.game.RT_recorded = vertcat(RTcell{:});

        % key -1(left), 1(right)
        Keycell = arrayfun(@(x)st.getcolumn(x.a,10)*2 - 3, d,'UniformOutput',false);
        game.game.key = vertcat(Keycell{:});

        for ri = 1:2
            Rewardcell = arrayfun(@(x)st.getcolumn(x.rewards(ri,:),10),d,'UniformOutput',false);
            game.game.rewards{ri} = vertcat(Rewardcell{:});
        end        
        game.game.n_game = N;
        data(datai) = game;
    end
    save(fullfile(savedir, savename), 'data');
    disp('Complete!');
% catch
    
% end
end