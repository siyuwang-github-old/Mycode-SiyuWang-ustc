clear all, clc;
s = cardstopping_modelfitting;
save = 1;
show = 0;
savefolder = 'Card_stopping';
savename = '';
s.setparameter(show, save, savefolder, savename,1);
s.loadall(60);
s.temp_datai = 3;
s.isoverwrite = false;
s.default_analysis('full');
%%
clrs = {'AZblue','AZcactus','AZsand','AZsky','AZriver','AZbrick','lightred','lightblue','lightcactus'};
filename = 'failed';
s.comparemodels({'rulebased_threshold'},clrs([8]),filename);
%%
s.plotdist(3,3)
%%
clrs = {'AZblue','AZcactus','AZsand','AZsky','AZriver'};
filename = 'failed';
s.comparemodels({'constant_threshold','horizon_threshold','rulebased_threshold','samplingbernoulli'},clrs([1 2 3 4]),filename);
%%
filename = 'ac1';
s.comparemodels({'horizon_threshold'},clrs([2]),filename);
%%
filename = 'ac2';
s.comparemodels({'samplingbernoulli','horizon_threshold'},clrs([3 2]),filename);
%%
filename = 'ac3';
s.comparemodels({'samplingbernoulli_n','samplingbernoulli','horizon_threshold'},clrs([1, 3, 2]),filename);
%%
% s.plotdist_constantthreshold;
s.fitmodel('constant_threshold');
%%
s.fitmodel('horizon_threshold');
%%
s.fitmodel('samplingaverage');
%%
s.fitmodel('rulebased_threshold');
%%
s.fitmodel('samplingbernoulli');
%%
s.fitmodel('samplingbernoulli_n');
%%
s.fitmodel_horizonthresholdbetaprior;
s.fitmodel_samplingbernoullibeta;
%%
ns = s.modelfit(3).bestfit.samplingbernoulli;
ds = s.data{3};
clear rt;
for di = 1:length(ds)
    d = ds(di).task;
    trt = arrayfun(@(x)SiyuTools.getcolumn(d.rt_s(x).key(2:d.nstop_s(x)) - d.rt_s(x).draw(2:d.nstop_s(x)), max(d.nstop_s),'left'), 1:d.n_game, 'UniformOutput',false);
    trt = vertcat(trt{:});
    rt(di,:) = nanmean(trt);
    
%     trt = arrayfun(@(x)SiyuTools.getcolumn(d.rt_s(x).key(1:d.nstop_s(x)-1) - d.rt_s(x).draw(1:d.nstop_s(x)-1), max(d.nstop_s)), 1:d.n_game, 'UniformOutput',false);
%     trt = vertcat(trt{:});
%     rt(di,:) = nanmean(trt);
end
% s.isshow = true;
s.figure(2,2);
for i = 1:4
%     s.new;
    s.untitled_scattercorr(ns(:,i+1), rt(:,i+1), {'a','b'});
end
% s.figure;
% tns = ns(:,[1 1 1 1]);
% trt = rt(:,[2 3 4 5]);
% s.untitled_scattercorr(tns(:), trt(:), {'a','b'});
nanmean(ns)