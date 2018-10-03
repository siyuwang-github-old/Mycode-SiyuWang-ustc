function [gID, gIDorder] = assist__preprocess_getrepeatedID(rewards)
    n_trial = unique([size(rewards{1},1),size(rewards{2},1)]);
    gID = zeros(n_trial, 1);
    IDi = 0;
    gIDorder = zeros(n_trial, 1);
    for gi = 1:n_trial
        if gID(gi) == 0
            IDi = IDi + 1;
            gID(gi) = -IDi;
            gIDorder(gi) = 1;
            torder = 1;
            tlist = [gi];
            for gj = 1:n_trial
                if (gID(gj) == 0) && compare_exampletrial(rewards,gi,gj)
                    torder =  torder + 1;
                    gID(gi) = abs(gID(gi));
                    gID(gj) = gID(gi);
                    gIDorder(gj) = torder;
                    tlist = [tlist, gj];
                end
            end
        end
    end
end
function same = compare_exampletrial(rewards, gi, gj)
    ri = [rewards{1}(gi,1:4),rewards{2}(gi,1:4)];
    rj = [rewards{1}(gj,1:4),rewards{2}(gj,1:4)];
    if all(ri == rj)
        same = true;
    else
        same = false;
    end
end