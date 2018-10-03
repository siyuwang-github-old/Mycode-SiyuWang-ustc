function bobexcel2siyu(filename, savename)
    [num, txt, raw] = xlsread(filename);
    tt = raw(1,:);
    txt = txt(2:end,:);
    raw = raw(2:end,:);
    sub = unique(raw(:,2));
    exp = unique(raw(:,1));
    exp = exp{1};
    data = [];
    for li = 0:1
        for si = 1:length(sub)
            disp(sprintf('importing sub %d', si));
            idxi = strcmp(raw(:,2), sub{si}) & num(:,find(strcmp(tt(3:end), 'losses'))) == li;
            tn = num(idxi,:);
            data(si*2-li).subjectID = unique(num(idxi, find(strcmp(tt(3:end), 'subjectNumber'))));
            data(si*2-li).info_exp = exp;
            data(si*2-li).info_expsavename = ['Horizon___' exp];
            data(si*2-li).demo_age = unique(num(idxi, find(strcmp(tt(3:end), 'age'))));
            data(si*2-li).demo_gender = unique(num(idxi, find(strcmp(tt(3:end), 'gender'))));
            data(si*2-li).info_loss = unique(num(idxi, find(strcmp(tt(3:end), 'losses'))));
            game.RT_recorded = num(idxi, find(strcmp(tt(3:end), 'rt1')):find(strcmp(tt(3:end), 'rt10')));
            game.key = num(idxi, find(strcmp(tt(3:end), 'c1')):find(strcmp(tt(3:end), 'c10')));
            game.underlyingMean =  [num(idxi, find(strcmp(tt(3:end), 'm1'))) num(idxi, find(strcmp(tt(3:end), 'm2')))];
            R = num(idxi, find(strcmp(tt(3:end), 'r1')):find(strcmp(tt(3:end), 'r10')));
            for ci = 1:2
                game.rewards{ci} = nan(size(R));
                game.rewards{ci}(game.key == ci) = R(game.key == ci);
            end
            game.key = sign(game.key - 1.5);
            game.n_game = size(game.key,1);
            data(si*2-li).game = game;
            data(si*2-li).num_game = game.n_game;
        end
    end
    save(savename, 'data');
end