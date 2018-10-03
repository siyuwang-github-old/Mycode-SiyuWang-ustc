folder = 'W:\LAB\DATA\Horizon___Princeton_fMRI_sequential';
files = dir(fullfile(folder, '*.mat'));
for fi = 1:length(files)
    disp(sprintf('processing subject %d',fi));
    d = importdata(fullfile(files(fi).folder, files(fi).name));
    
    ng = length(unique(arrayfun(@(x)x.block*100+x.game,d.data)));
    game.n_game = ng -(d.data(end).trial ~= d.game(ng).gameLength);
    game.underlyingMean = horzcat(d.game.mean)';
    game.underlyingMean = game.underlyingMean(1:game.n_game,:);
    data(fi).num_game = game.n_game;
    for ri = 1:2
        r = arrayfun(@(x)SiyuTools.getcolumn(x.rewards(ri,:),10), d.game,'UniformOutput',false);
        game.rewards{ri} = vertcat(r{:});
        game.rewards{ri} = game.rewards{ri}(1:game.n_game,:);
    end
    as = [d.data.choice];
    gl = [d.game.gameLength];
    gl2 = cumsum(gl);
    gl1 = [1 gl2(1:end-1)+1];
    ass = arrayfun(@(x)SiyuTools.getcolumn(as(gl1(x):gl2(x)),10), 1:game.n_game,'UniformOutput',false);
    game.key = vertcat(ass{:})*2 - 3;
    rts = arrayfun(@(x)x.responseTime - x.banditOnTime, d.data);
    rtss = arrayfun(@(x)SiyuTools.getcolumn(rts(gl1(x):gl2(x)),10), 1:game.n_game,'UniformOutput',false);
    game.RT_recorded = vertcat(rtss{:});
    
    data(fi).info_exp = 'PUfMRIsequential';
    data(fi).info_expsavename = 'Horizon___PU_fMRIsequential';
    data(fi).game = game;
end
save('W:\LAB\DATAMAT\Horizon___PU_fMRIsequential','data');