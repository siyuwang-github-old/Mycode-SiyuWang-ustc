function out = f18F017(data)
    d = data.game;
    key = d.key(:,5);
    rawdata = d.rawdata{1};
%     sc = sign([rawdata.smallbanditchoice]'-1.5);
%     horizons = unique(d.cond_horizon);
%     cc = sc == key;
%     for hi = 1:length(horizons)
%         idxh = d.cond_horizon == horizons(hi);
%         fcopy(hi) = mean(cc(idxh));
%         idxfcac = sc == sign(diff(d.underlyingMean')');
%         out.ac_social(hi)= mean(idxfcac(idxh));
%         out.fc_ac.ys(hi) = mean(cc(idxh & idxfcac));
%         out.fc_ac.no(hi) = mean(cc(idxh & ~idxfcac));
%         
%         ishi = -sign(d.cumInfo(:,4));
%         ishi(ishi == 0) = NaN;
%         idxfchi = sc == ishi;
%         out.fc_hi.ys(hi) = mean(cc(idxh & idxfchi & ~isnan(ishi)));
%         out.fc_hi.no(hi) = mean(cc(idxh & ~idxfchi & ~isnan(ishi)));
%         
%         islm = -sign(d.dfavR(:,4));
%         idxfclm = sc == islm;
%         out.fc_lm.ys(hi) = mean(cc(idxh & idxfclm & isnan(ishi)));
%         out.fc_lm.no(hi) = mean(cc(idxh & ~idxfclm & isnan(ishi)));
%     end
%     out.fcopy = fcopy;

end