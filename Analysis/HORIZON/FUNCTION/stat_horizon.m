classdef stat_horizon < horizon
    properties
    end
    methods
        function obj = stat_horizon()
        end
        function gethorizontaskcorr(obj)
            gp = obj.temp_gp;
            idx = obj.idxn;
            idxlb = obj.idxnlabel;
            hi = gp.p_hi_13;
            lm = gp.p_lm_22;
            di = diff(hi')';
            ra = diff(lm')';
            ac = [gp.trialn(2).ac(:,10)];
            RT = [gp.trialn(1).RT(:,5) gp.trialn(2).RT(:,5)];
            d = [hi lm di ra ac RT];
            lb = {'p(high info, h = 1)',...
                'p(high info, h = 6)','p(low mean, h = 1)','p(low mean, h = 6)',...
                'direct exploration','random exploration','accuracy','RT, h = 1','RT, h = 6'};
            nu = lb;
%             nu = arrayfun(@(x)num2str(x),1:length(lb),'UniformOutput',false);
%             lb = strcat(nu, {' '}, lb);
            if isempty(idx)
                obj.corrtable(d,d,lb,nu,1);
            else 
                n = length(idx);
                cs = combnk(1:n,2);
                for ci = 1:size(cs,1)
                    i1 = cs(ci,1);
                    i2 = cs(ci,2);
                    obj.corrtable(d(idx{i1},:), d(idx{i2},:), lb, nu, [],4);
                end
            end

        end
    end
end