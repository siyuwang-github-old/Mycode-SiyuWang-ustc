function game = import_EEHorizon(d)
    if (~isfield(d,'key'))
        warning('no response data');
        N = 0;
        game.n_game = 0;
        return
    end
    N = sum(cellfun(@(x)~isempty(x),{d.key}));
    game.n_game = N;
    d = d(1:N);
    st = SiyuTools;
    Mcell = arrayfun(@(x)st.getcolumn(x.mean',2),d,'UniformOutput',false);
    game.underlyingMean = vertcat(Mcell{:});
    
    if isfield(d(1), 'timeBanditOn')
        Tcell = arrayfun(@(x)st.getcolumn(x.timeBanditOn,10),d,'UniformOutput',false);
        tBanditOn = vertcat(Tcell{:});
        
        Tcell = arrayfun(@(x)st.getcolumn(x.timePressKey,10),d,'UniformOutput',false);
        tKey = vertcat(Tcell{:});
        
        Tcell = arrayfun(@(x)st.getcolumn(x.timeRewardOn,10),d,'UniformOutput',false);
        tRewardOn = vertcat(Tcell{:});
        
        tDelay(:,2:10) = tKey(:,2:10) - tRewardOn(:,1:9);
        tDelay(:,1) = NaN;
        game.delaytime_R2K = tDelay;
        
        tDelay(:,2:10) = tBanditOn(:,2:10) - tRewardOn(:,1:9);
        tDelay(:,1) = NaN;
        game.delaytime_R2B = tDelay;
        
        game.delaytime_B2K = tKey - tBanditOn;
        
        RTcell = arrayfun(@(x)st.getcolumn(x.RT,10),d,'UniformOutput',false);
        game.RT_recorded = vertcat(RTcell{:});
    else
        Tcell = arrayfun(@(x)st.getcolumn([x.time.trial.timeBanditOn],10),d,'UniformOutput',false);
        tBanditOn = vertcat(Tcell{:});
        
        Tcell = arrayfun(@(x)st.getcolumn([x.time.trial.timePressKey],10),d,'UniformOutput',false);
        tKey = vertcat(Tcell{:});
        
        Tcell = arrayfun(@(x)st.getcolumn([x.time.trial.timeRewardOn],10),d,'UniformOutput',false);
        tRewardOn = vertcat(Tcell{:});
        
        tDelay(:,2:10) = tKey(:,2:10) - tRewardOn(:,1:9);
        tDelay(:,1) = NaN;
        game.delaytime_R2K = tDelay;
        
        tDelay(:,2:10) = tBanditOn(:,2:10) - tRewardOn(:,1:9);
        tDelay(:,1) = NaN;
        game.delaytime_R2B = tDelay;
        
        game.delaytime_B2K = tKey - tBanditOn;
        
        
    end
    % key -1(left), 1(right)
    Keycell = arrayfun(@(x)st.getcolumn(x.key,10)*2 - 3, d,'UniformOutput',false);
    game.key = vertcat(Keycell{:});
    
    for ri = 1:2
        Rewardcell = arrayfun(@(x)st.getcolumn(x.rewards(ri,:),10),d,'UniformOutput',false);
        game.rewards{ri} = vertcat(Rewardcell{:});
    end
%     game.rawdata = {d};
end