clear all; clc;
disp('Group indivisual measures');
datadir = 'W:\LAB\DATAMAT';
data = importdata(fullfile(datadir, 'data_horizon_compiled.mat'));
st = SiyuTools;
%%
names = st.getstructures(data);
names = cellfun(@(x)x(2:end),names,'UniformOutput',false);
idx_level = cellfun(@(x)length(strfind(x, '\')), names);
names0 = names(idx_level == 0);
% pull out string data
idx_str = cellfun(@(x)any(arrayfun(@(t)ischar(getfield(t, x)), ...
    data)), names0);
names0str = names0(idx_str);
gp = [];
for ni = 1:length(names0str)
    te = arrayfun(@(x)getfield(x, names0str{ni}), data, 'UniformOutput', ...
        false)';
    gp = setfield(gp, names0str{ni}, te);
end
% pull out numerical data
idx_num = cellfun(@(x)all(arrayfun(@(t)isnumeric(getfield(t,x)), ...
    data)), names0);
names0num = names0(idx_num);
idx_row1 = cellfun(@(x)all(arrayfun(@(t)size(getfield(t,x),1) <= 1, ...
    data)), names0num);
names0num_r1 = names0num(idx_row1);

gpmat = [];
namemat = {};
for ni = 1:length(names0num_r1)
    name = names0num_r1{ni};
    n_col = max(arrayfun(@(x)size(getfield(x,name),2), data)); 
    tgp = arrayfun(@(x)st.getcolumn(getfield(x, name),n_col), data, 'UniformOutput', false);
    tgp = vertcat(tgp{:});
    gp = setfield(gp, name, tgp);
    if (n_col == 1)
        str_col = {''};
    else
        str_col = arrayfun(@(i)num2str(i), 1:n_col, 'UniformOutput', false);
    end
    namemat = [namemat, strcat(repmat({name}, 1, n_col), '_', str_col)];
    gpmat = [gpmat, tgp];
end


idx_row2 = cellfun(@(x)any(arrayfun(@(t)size(getfield(t,x),1) == 2, ...
    data)), names0);
name2 = names0(idx_row2);
for ni = 1:length(name2)
    name = name2{ni}(1:end);
    tgp = arrayfun(@(x)getfield(x, name), data, 'UniformOutput', false);
    ise = cellfun(@(x)isempty(x), tgp);
    for hi = 1:2
        tgp2(ise) = arrayfun(@(x)NaN(1,7), tgp(ise), 'UniformOutput', false);
        tgp2(~ise) = cellfun(@(x)x(hi,:), tgp(~ise), 'UniformOutput', false);
%         n_col = max(arrayfun(@(x)size(getfield(x,name),2), data));
%         idx_empty = cellfun(@(x)isempty(x), tgp);
%         tgp(idx_empty) = {repmat(NaN, 1, n_col)};
        tgp3{hi} = vertcat(tgp2{:});
    end
    gp = setfield(gp, name, tgp3);
end

idx_trialn = cellfun(@(x)length(x) > 0,strfind(names, 'trialn\'));
names_trialn = cellfun(@(x)x(8:end),names(idx_trialn),'UniformOutput',false);
for ni = 1:length(names_trialn)
    tname = names_trialn{ni};
    for hi = 1:2
        ttrialn = arrayfun(@(x)x.trialn.(tname)(hi,:), data, ...
            'UniformOutput', false);
        trialn(hi).(tname) = vertcat(ttrialn{:});
    end
end
gp.trialn = trialn;

rbins = arrayfun(@(x)x.bin_rcurve.kernel, data, 'UniformOutput', false);
rbins = vertcat(rbins{:});
gp.rbin_kernel = mean(rbins);

rnames = arrayfun(@(x)fieldnames(x.rcurve), data, 'UniformOutput', false);
rnames = vertcat(rnames{:});
rnames = unique(rnames);

for ri = 1:length(rnames)
    rname = rnames{ri};
    for hi = 1:2
        ynames = arrayfun(@(x)fieldnames(x.rcurve.(rname){hi}), data, 'UniformOutput', false);
        ynames = vertcat(ynames{:});
        ynames = unique(ynames);
        for yi = 1:length(ynames)
            yname = ynames{yi};
            for ni = 1:10
                if size(data(1).rcurve.(rname){hi}.(yname),2) >= ni
                    trc = arrayfun(@(x)x.rcurve.(rname){hi}.(yname)(:,ni)', data, ...
                        'UniformOutput', false);
                    rcurve.(rname)(hi,ni).(yname) = vertcat(trc{:});
                end
            end
        end
    end
end
gp.rcurve = rcurve;

save(fullfile(datadir, 'data_horizon_gpindmeasure'),'gp','gpmat','namemat'); 