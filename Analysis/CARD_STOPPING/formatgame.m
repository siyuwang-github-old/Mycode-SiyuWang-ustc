function out = formatgame(g)
    if isempty(g)
        out = [];
        return;
    end
    ng = length(g.nstop_s);
    ns = g.nstop_s;
    hs = arrayfun(@(x)repmat(g.horizon(x),1,ns(x)), 1:ng,'UniformOutput',false);
    out.h = horzcat(hs{:})';
    ls = arrayfun(@(x)g.horizon(x):-1:(g.horizon(x)+1-ns(x)), 1:ng,'UniformOutput',false);
    out.n = horzcat(ls{:})';
    vs = arrayfun(@(x)g.cards(x, 1:ns(x)), 1:ng, 'UniformOutput',false);
    out.v = horzcat(vs{:})';
    as = arrayfun(@(x)SiyuTools.iif(ns(x)==0,[],[zeros(1,ns(x)-1) 1]), 1:ng, 'UniformOutput',false);
    out.a = horzcat(as{:})';
end