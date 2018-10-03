clear all, clc;
s = cardstopping;
%%
save = 1;
show = 0;
savefolder = 'Card_stopping';
savename = '';
s.setparameter(show, save, savefolder, savename);
%%
clc;
s.loadall(60);
%%
simu = 0;
s.default_analysis(simu);
%%
s.plot_choicecurves;
s.plot_choicecurves_diff;
s.plot_choicecurve_initial;
% s.plot_choicecurve_ntrial;
s.plot_choicecurve_h5;
s.plot_mle;
s.plot_mle_initial;
s.plot_mle_h5;
%%
% s.tempthrs = [];
% s.main_simulation;
% %%
% s.get_pfit;
% 
% %%
% s.main_simulation_sub;
% %%
% [av1, err1] = s1.plot_mle_v1_5only;
% %%
% [av, err] = s.plot_mle_v1_5only;
% 
% %%
% s.get_pfit_sub;
% %%
% pp = s.pfit_sub.p50;
% maxpp = max(pp')';
% te = pp == repmat(maxpp,1,4);
% te = te.*repmat([1 2 3 4], length(maxpp),1);
% te(te == 0) = NaN;
% gp = nanmean(te')';
% RT = s.RT.max;
% idx = maxpp>0;
% s.scattercorr(RT(idx)',{gp(idx)},{'gp'},{s.colors.red});
% %%
% s.plot_policy;
% %%
% s.fakemle;
% %%            
% d = s.simudata;
% idx = [1 2 3 8];
% thres = cellfun(@(x)x.thres, d(idx), 'UniformOutput',false);
% thres = vertcat(thres{:});
% threserr = cellfun(@(x)x.threserr, d(idx), 'UniformOutput',false);
% threserr = vertcat(threserr{:});
% noise = cellfun(@(x)x.noise, d(idx), 'UniformOutput',false);
% noise = vertcat(noise{:});
% noiseerr = cellfun(@(x)x.noiseerr, d(idx), 'UniformOutput',false);
% noiseerr = vertcat(noiseerr{:});
% %%
% s.figure;clf;
% %  obj.leglist = [];
%  hold on;
%  hi = 5;
%  clrs = {s.colors.sky, s.colors.cactus, s.colors.sand, s.colors.red};
%  clrs = clrs(end:-1:1);
%  s.leglist(end+1) = plot(1:4,s.opthrs(5:-1:2), '*','LineWidth', s.linewidth);%,'Color',clrs{3});
%  s.lineplot(thres(:,2:5),threserr(:,2:5),[hi-1:-1:1],clrs(1:4));
% %  obj.lineplot(av1{1},err1{1},[hi-1:-1:1],clrs(1));
%  legs = {'Optimal','Simulate','#sample = 2','#sample = 4','#sample = 8'};
% %  legs{end+1} = ['Experiment 1'];
% %  legs{end+1} = ['Experiment 2'];
%  s.legend(legs);
%  set(gca, 'XTick', 1:4, 'XTickLabels', 5:-1:2);
%  xlabel('number of cards left');
%  ylabel('threshold');
%  set(gca, 'FontSize',s.fontsize_face);
%  s.lim([0.5 4.5],[45 90]);
%  s.save('mle_thres_simu');
%  %%
%  s.figure;clf;
% %  s.new;
% % s.leglist = [];
%  hold on;
%  hi = 5;
%  clrs = {s.colors.sky, s.colors.cactus, s.colors.sand, s.colors.red};
%  clrs = clrs(end:-1:1);
%  %  obj.leglist(end+1) = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);%,'Color',clrs{3});
%  s.lineplot(noise(:,2:5),noiseerr(:,2:5),[hi-1:-1:1],clrs(1:4));
% %  obj.lineplot(av1{1},err1{1},[hi-1:-1:1],clrs(1));
%  legs = {'Simulate','#sample = 2','#sample = 3','#sample = 4'};
% %  legs{end+1} = ['Experiment 1'];
% %  legs{end+1} = ['Experiment 2'];
%  s.legend(legs);
%  set(gca, 'XTick', 1:4, 'XTickLabels', 5:-1:2);
%  xlabel('number of cards left');
%  ylabel('variability');
%  set(gca, 'FontSize',s.fontsize_face);
%  s.lim([0.5 4.5],[0 12]);
%  s.save('mle_thres_simu');
 