% 
% %         function compare_choicecurve(obj)
% %             te = [];
% %             colors = {obj.colors.cactus, obj.colors.red};
% %             ax = obj.figure(2,2);
% %             for hi = 2:5
% %                 axes(ax(hi-1));
% %                 obj.glist = [];
% %                 av(1,:) = obj.avs{1}.av.choicecurve(hi,:);
% %                 av(2,:) = obj.avs{2}.av.choicecurve(hi,:);
% %                 err(1,:) = obj.avs{1}.err.choicecurve(hi,:);
% %                 err(2,:) = obj.avs{2}.err.choicecurve(hi,:);
% %                 obj.lineplot(av,err,mean(obj.avs{1}.xbins_reward'),colors);
% %                 ylim([0 1]);
% %                 obj.legend(obj.glist, {'H = 5', 'H = 10'}, 'Northwest', ['h = ' num2str(hi)]);
% %                 if hi >= 4
% %                     xlabel('reward');
% %                 end
% %                 if mod(hi,2) == 0
% %                     ylabel('p(stop)');
% %                 end
% %                 set(gca, 'FontSize',obj.fontsize.face);
% %             end
% %         end
% 
% %         function plot_mle(obj)
% %             horizons = obj.horizons;
% %             obj.figure; clf;
% %             legs = {'optimal'};
% %             obj.leglist = [];
% %             hold on;
% %             avs = obj.avs;
% %             clrs = { obj.colors.river, obj.colors.cactus, obj.colors.sand, obj.colors.red};
% %             plot(1:10,obj.opthrs(end:-1:1), '*','LineWidth', obj.linewidth);
% %             for i = 1:length(horizons)
% %                 hi = horizons(i);
% %                 obj.lineplot(avs{hi}.av.thresvsntrial,avs{hi}.err.thresvsntrial,[10:-1:11-hi],clrs(i));
% %                 legs{end+1} = ['H = ',num2str(hi)];
% %                 %                 obj.lineplot(avs{10}.av.thresvsntrial,avs{10}.err.thresvsntrial,[10:-1:1],clrs(2));
% %             end
% %             obj.legend(legs);
% %             set(gca, 'XTick', 1:10, 'XTickLabels', 10:-1:1);
% %             xlabel('number of cards left');
% %             ylabel('threshold');
% %             set(gca, 'FontSize',obj.fontsize_face);
% %             obj.save('mle_thres');
% %             obj.figure; clf;
% %             obj.leglist = [];
% %             legs = {};
% %             hold on;
% %             avs = obj.avs;
% %             clrs = { obj.colors.river, obj.colors.cactus, obj.colors.sand, obj.colors.red};
% %             for i = 1:length(horizons)
% %                 hi = horizons(i);
% %                 obj.lineplot(avs{hi}.av.noisevsntrial,avs{hi}.err.noisevsntrial,[10:-1:11-hi],clrs(i));
% %                 legs{end+1} = ['H = ',num2str(hi)];
% %                 %                 obj.lineplot(avs{10}.av.thresvsntrial,avs{10}.err.thresvsntrial,[10:-1:1],clrs(2));
% %             end
% %             %             obj.lineplot(avs{10}.av.noisevsntrial,avs{10}.err.noisevsntrial,[10:-1:1],clrs(2));
% %             obj.legend(legs);
% %             set(gca, 'XTick', 1:10, 'XTickLabels', 10:-1:1);
% %             xlabel('number of cards left');
% %             ylabel('noise');
% %             set(gca, 'FontSize',obj.fontsize_face);
% %             obj.save('mle_noise');
% %             %
% %             %             obj.figure; clf;
% %             %             obj.glist = [];
% %             %             legs = {'h = 5','h = 10'};
% %             %             hold on;
% %             %             avs = obj.avs;
% %             %             clrs = {obj.colors.cactus, obj.colors.red};
% %             %             obj.lineplot(avs{1}.av.kbestvsntrial(2:end),avs{1}.err.kbestvsntrial(2:end),[9:-1:6],clrs(1));
% %             %             obj.lineplot(avs{2}.av.kbestvsntrial(2:end),avs{2}.err.kbestvsntrial(2:end),[9:-1:1],clrs(2));
% %             %             obj.legend(obj.glist, legs);
% %             %             set(gca, 'XTick', 1:9, 'XTickLabels', 10:-1:2);
% %             %             xlabel('number of cards left');
% %             %             ylabel('k_best');
% %             %             set(gca, 'FontSize',obj.fontsize.face);
% %             %
% %             %              obj.figure; clf;
% %             %             obj.glist = [];
% %             %             legs = {'h = 5','h = 10'};
% %             %             hold on;
% %             %             avs = obj.avs;
% %             %             clrs = {obj.colors.cactus, obj.colors.red};
% %             %             obj.lineplot(avs{1}.av.kpastvsntrial(2:end),avs{1}.err.kpastvsntrial(2:end),[9:-1:6],clrs(1));
% %             %             obj.lineplot(avs{2}.av.kpastvsntrial(2:end),avs{2}.err.kpastvsntrial(2:end),[9:-1:1],clrs(2));
% %             %             obj.legend(obj.glist, legs);
% %             %             set(gca, 'XTick', 1:9, 'XTickLabels', 10:-1:2);
% %             %             xlabel('number of cards left');
% %             %             ylabel('k_past');
% %             %             set(gca, 'FontSize',obj.fontsize.face);
% %             %
% %             %              obj.figure; clf;
% %             %             obj.glist = [];
% %             %             legs = {'h = 5','h = 10'};
% %             %             hold on;
% %             %             avs = obj.avs;
% %             %             clrs = {obj.colors.cactus, obj.colors.red};
% %             %             obj.lineplot(avs{1}.av.kworstvsntrial(2:end),avs{1}.err.kworstvsntrial(2:end),[9:-1:6],clrs(1));
% %             %             obj.lineplot(avs{2}.av.kworstvsntrial(2:end),avs{2}.err.kworstvsntrial(2:end),[9:-1:1],clrs(2));
% %             %             obj.legend(obj.glist, legs);
% %             %             set(gca, 'XTick', 1:9, 'XTickLabels', 10:-1:2);
% %             %             xlabel('number of cards left');
% %             %             ylabel('k_worst');
% %             %             set(gca, 'FontSize',obj.fontsize.face);
% %         end
% 
% 
% %         function plot_mle_v2(obj)
% %             obj.figure; clf;
% %             legs = {'optimal'};
% %             obj.leglist = [];
% %             hold on;
% %             avs = obj.avs;
% %             clrs = { obj.colors.river, obj.colors.red};
% %             obj.leglist = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);
% %             for hi = 2:5
% %                 av(hi-1) = avs{hi}.av.thresvsntrial(hi);
% %                 err(hi-1) = avs{hi}.err.thresvsntrial(hi);
% %             end
% %             obj.lineplot(av,err,[hi-1:-1:1],clrs(2));
% %             legs{end+1} = ['behavior'];
% %             obj.legend(legs);
% %             set(gca, 'XTick', 1:4, 'XTickLabels', 5:-1:2);
% %             xlabel('number of cards left');
% %             ylabel('threshold');
% %             set(gca, 'FontSize',obj.fontsize_face);
% %             obj.lim([0.5 4.5],[45 90]);
% %             obj.save('mle_thres_v2');
% %
% %             obj.figure; clf;
% %             legs = {'optimal'};
% %             obj.leglist = [];
% %             hold on;
% %             avs = obj.avs;
% %             clrs = { obj.colors.river, obj.colors.red};
% %             %             obj.leglist = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);
% %             for hi = 2:5
% %                 av(hi-1) = avs{hi}.av.noisevsntrial(hi);
% %                 err(hi-1) = avs{hi}.err.noisevsntrial(hi);
% %             end
% %             obj.lineplot(av,err,[hi-1:-1:1],clrs(2));
% %             legs{end+1} = ['behavior'];
% %             obj.legend(legs);
% %             set(gca, 'XTick', 1:4, 'XTickLabels', 5:-1:2);
% %             xlabel('number of cards left');
% %             ylabel('threshold');
% %             set(gca, 'FontSize',obj.fontsize_face);
% %             obj.lim([0.5 4.5],[0 15]);
% %             obj.save('mle_noise_v2');
% %         end
% 

% function default_analysis(obj, issimu, isskipim)
% if nargin < 2
%     issimu = 0;
% end
% if ~exist('isskipim')
%     isskipim = 0;
% end
% if ~isempty(issimu) && issimu
%     obj.main_simulation;
% end
% simucdf = obj.simucdf;
% 
% for di = obj.temp_datai
%     data = obj.data{di};
%     %             obj.main_simulation;
%     task = data.task;
%     horizons = unique(task.h);
%     obj.horizons{di} = horizons;
%     xbins_ntrial = [0.5:9.5; 1.5:10.5]';
%     xbins_reward = [0:10:90; 10:10:100]';
%     xbins_simucdf = [0:0.1:0.9; 0.1:0.1:1]';
%     if ~isskipim
%         im = [];
%         gp = [];
%         avs = [];
%         imfull = [];
%         for si = 1:length(data)
%             
%             game = data(si).task;
%             for ni = 1:max(horizons)
%                 criticaltrial = arrayfun(@(x)x + 1 - ni, horizons);
%                 criticaltrial(criticaltrial <= 0) = NaN;
%                 idx_n = arrayfun(@(x)game.nstop_s == x, criticaltrial, 'UniformOutput', false);
%                 idx_nall = arrayfun(@(x)game.nstop_s >= x, criticaltrial, 'UniformOutput', false);
%                 idx = idx_nall;
%                 try
%                     y = arrayfun(@(x)idx_n{x}(idx{x})', find(cellfun(@(x)sum(x)>0, idx)),'UniformOutput',false); % stopped on critical trial
%                     x = arrayfun(@(x)game.cards(idx{x},criticaltrial(x)), find(cellfun(@(x)sum(x)>0, idx)),'UniformOutput',false);
%                     y = vertcat(y{:});
%                     x = vertcat(x{:});
%                 catch
%                     
%                 end
%                 %                         if criticaltrial == 1
%                 xbest = zeros(size(y,1),size(y,2));
%                 xpast = zeros(size(y,1),size(y,2));
%                 xworst = zeros(size(y,1),size(y,2));
%                 %                         elseif criticaltrial == 2
%                 %                             xbest = arrayfun(@(x)game.cards(idx{x}, 1),1:length(idx),'UniformOutput',false);
%                 %                             xbest = vertcat(xbest{:});
%                 %                             xpast = arrayfun(@(x)game.cards(idx{x}, 1),1:length(idx),'UniformOutput',false);
%                 %                             xpast = vertcat(xpast{:});
%                 %                             xworst = arrayfun(@(x)game.cards(idx{x}, 1),1:length(idx),'UniformOutput',false);
%                 %                             xworst = vertcat(xworst{:});
%                 %                         else
%                 %                             xbest = max(game.cards(idx, 1:criticaltrial-1)');
%                 %                             xpast = game.cards(idx, criticaltrial-1);
%                 %                             xworst = min(game.cards(idx, 1:criticaltrial-1)');
%                 %                         end
%                 x = reshape(x, size(y,1), size(y,2));
%                 xbest = reshape(xbest, size(y,1), size(y,2));
%                 xpast = reshape(xpast, size(y,1), size(y,2));
%                 xworst = reshape(xworst, size(y,1), size(y,2));
%                 if ~obj.isxfit
%                     te = obj.thresfit(x, y, xbest, xpast, xworst);
%                     imfull{si}.thresvsntrialfull(ni) = te.t;
%                     imfull{si}.noisevsntrialfull(ni) = te.n;
%                     imfull{si}.kbestvsntrialfull(ni) = te.k;
%                     imfull{si}.kpastvsntrialfull(ni) = te.kp;
%                     imfull{si}.kworstvsntrialfull(ni) = te.kw;
%                 end
%                 te = obj.bin_average(y,x,xbins_reward);
%                 imfull{si}.choicecurvefull(ni,:) = te.y;
%             end
%             
%             for hhi = 1:length(horizons)
%                 hi = horizons(hhi);
%                 idx_h = game.horizon == hi;
%                 te = obj.bin_average(game.reward_s(idx_h), game.nstop_s(idx_h), xbins_ntrial);
%                 im{si}.rewardvsntrial{hi} = te.y;
%                 im{si}.rewardvsntrial_num{hi} = te.num;
%                 for ni = 1:hi
%                     criticaltrial = hi + 1 - ni;
%                     idx_n = game.nstop_s == criticaltrial;
%                     idx_nall = game.nstop_s >= criticaltrial;
%                     idx = idx_nall & idx_h;
%                     y = idx_n(idx); % stopped on critical trial
%                     x = game.cards(idx,criticaltrial);
%                     if criticaltrial == 1
%                         xbest = zeros(size(y,1),size(y,2));
%                         xpast = zeros(size(y,1),size(y,2));
%                         xworst = zeros(size(y,1),size(y,2));
%                     elseif criticaltrial == 2
%                         xbest = game.cards(idx, 1);
%                         xpast = game.cards(idx, 1);
%                         xworst = game.cards(idx, 1);
%                     else
%                         xbest = max(game.cards(idx, 1:criticaltrial-1)');
%                         xpast = game.cards(idx, criticaltrial-1);
%                         xworst = min(game.cards(idx, 1:criticaltrial-1)');
%                     end
%                     x = reshape(x, size(y,1), size(y,2));
%                     xbest = reshape(xbest, size(y,1), size(y,2));
%                     xpast = reshape(xpast, size(y,1), size(y,2));
%                     xworst = reshape(xworst, size(y,1), size(y,2));
%                     if ~obj.isxfit
%                         te = obj.thresfit(x, y, xbest, xpast, xworst);
%                         im{si}.thresvsntrial{hi}(ni) = te.t;
%                         im{si}.noisevsntrial{hi}(ni) = te.n;
%                         im{si}.kbestvsntrial{hi}(ni) = te.k;
%                         im{si}.kpastvsntrial{hi}(ni) = te.kp;
%                         im{si}.kworstvsntrial{hi}(ni) = te.kw;
%                     else
%                         %                             im{si}.thresvsntrial{hi}(ni) = te.t;
%                         %                             im{si}.noisevsntrial{hi}(ni) = te.n;
%                         %                             im{si}.kbestvsntrial{hi}(ni) = te.k;
%                         %                             im{si}.kpastvsntrial{hi}(ni) = te.kp;
%                         %                             im{si}.kworstvsntrial{hi}(ni) = te.kw;
%                     end
%                     te = obj.bin_average(y,x,xbins_reward);
%                     im{si}.choicecurve{hi}(ni,:) = te.y;
%                     if (ni <= 5)
%                         %                             for pi = 1:4
%                         %                                 x_p = arrayfun(@(t)simucdf{pi}(ni, t), x);
%                         %                                 te = obj.bin_average(y,x_p,xbins_simucdf);
%                         %                                 im{si}.choicecurve_p{hi,pi}(ni, :) = te.y;
%                         %                             end
%                     end
%                     %                         result{horizonname/5}(hi, si).x=x;
%                     %                         result{horizonname/5}(hi, si).xx=xx;
%                     %                         result{hi}(hi, si).y=y;
%                     
%                 end
%             end
%         end
%         obj.im{di} = im;
%         obj.imfull{di} = imfull;
%     else
%         im = obj.im{di};
%         imfull = obj.imfull{di};
%     end
%     gpfull = [];
%     te = cellfun(@(x)obj.getcolumn(x.thresvsntrialfull,max(horizons)), imfull, 'UniformOutput', false);
%     gpfull.thresvsntrialfull = vertcat(te{:});
%     te = cellfun(@(x)obj.getcolumn(x.noisevsntrialfull,max(horizons)), imfull, 'UniformOutput', false);
%     gpfull.noisevsntrialfull = vertcat(te{:});
%     te = cellfun(@(x)obj.getcolumn(x.kbestvsntrialfull,max(horizons)), imfull, 'UniformOutput', false);
%     gpfull.kbestvsntrialfull = vertcat(te{:});
%     te = cellfun(@(x)obj.getcolumn(x.kpastvsntrialfull,max(horizons)), imfull, 'UniformOutput', false);
%     gpfull.kpastvsntrialfull = vertcat(te{:});
%     te = cellfun(@(x)obj.getcolumn(x.kworstvsntrialfull,max(horizons)), imfull, 'UniformOutput', false);
%     gpfull.kworstvsntrialfull = vertcat(te{:});
%     for ni = 1:max(horizons)
%         te = cellfun(@(x)x.choicecurvefull(ni,:), imfull, 'UniformOutput', false);
%         gpfull.choicecurvefull{ni} = vertcat(te{:});
%     end
%     for hhi = 1:length(horizons)
%         hi = horizons(hhi);
%         te = cellfun(@(x)x.rewardvsntrial{hi}, im, 'UniformOutput', false);
%         gp{hi}.rewardvsntrial = vertcat(te{:});
%         te = cellfun(@(x)x.thresvsntrial{hi}, im, 'UniformOutput', false);
%         gp{hi}.thresvsntrial = vertcat(te{:});
%         te = cellfun(@(x)x.noisevsntrial{hi}, im, 'UniformOutput', false);
%         gp{hi}.noisevsntrial = vertcat(te{:});
%         te = cellfun(@(x)x.kbestvsntrial{hi}, im, 'UniformOutput', false);
%         gp{hi}.kbestvsntrial = vertcat(te{:});
%         te = cellfun(@(x)x.kpastvsntrial{hi}, im, 'UniformOutput', false);
%         gp{hi}.kpastvsntrial = vertcat(te{:});
%         te = cellfun(@(x)x.kworstvsntrial{hi}, im, 'UniformOutput', false);
%         gp{hi}.kworstvsntrial = vertcat(te{:});
%         for ni = 1:hi
%             te = cellfun(@(x)x.choicecurve{hi}(ni,:), im, 'UniformOutput', false);
%             gp{hi}.choicecurve{ni} = vertcat(te{:});
%             if ni <= 5
%                 for pi = 1:4
%                     %                             te = cellfun(@(x)x.choicecurve_p{hi,pi}(ni,:), im, 'UniformOutput', false);
%                     %                             gp{hi}.choicecurve_p{ni,pi} = vertcat(te{:});
%                 end
%             end
%         end
%     end
%     obj.gp{di} = gp;
%     obj.gpfull{di} = gpfull;
%     avsfull = [];
%     for ni = 1:max(horizons)
%         [avsfull.av.choicecurvefull(ni,:), avsfull.err.choicecurvefull(ni,:)] = obj.averr(gpfull.choicecurvefull{ni});
%     end
%     
%     [avsfull.av.thresvsntrialfull, avsfull.err.thresvsntrialfull] = obj.averr(gpfull.thresvsntrialfull);
%     [avsfull.av.noisevsntrialfull, avsfull.err.noisevsntrialfull] = obj.averr(gpfull.noisevsntrialfull);
%     [avsfull.av.kbestvsntrialfull, avsfull.err.kbestvsntrialfull] = obj.averr(gpfull.kbestvsntrialfull);
%     [avsfull.av.kpastvsntrialfull, avsfull.err.kpastvsntrialfull] = obj.averr(gpfull.kpastvsntrialfull);
%     [avsfull.av.kworstvsntrialfull, avsfull.err.kworstvsntrialfull] = obj.averr(gpfull.kworstvsntrialfull);
%     for hhi = 1:length(horizons)
%         hi = horizons(hhi);
%         [avs{hi}.av.rewardvsntrial, avs{hi}.err.rewardvsntrial] = obj.averr(gp{hi}.rewardvsntrial);
%         [avs{hi}.av.thresvsntrial, avs{hi}.err.thresvsntrial] = obj.averr(gp{hi}.thresvsntrial);
%         [avs{hi}.av.noisevsntrial, avs{hi}.err.noisevsntrial] = obj.averr(gp{hi}.noisevsntrial);
%         [avs{hi}.av.kbestvsntrial, avs{hi}.err.kbestvsntrial] = obj.averr(gp{hi}.kbestvsntrial);
%         [avs{hi}.av.kpastvsntrial, avs{hi}.err.kpastvsntrial] = obj.averr(gp{hi}.kpastvsntrial);
%         [avs{hi}.av.kworstvsntrial, avs{hi}.err.kworstvsntrial] = obj.averr(gp{hi}.kworstvsntrial);
%         for ni = 1:hi
%             [avs{hi}.av.choicecurve(ni,:), avs{hi}.err.choicecurve(ni,:)] = obj.averr(gp{hi}.choicecurve{ni});
%             %                     if ni <= 5
%             %                         for pi = 1:4
%             % %                             [avs{hi}.av.choicecurve_p{pi}(ni,:), avs{hi}.err.choicecurve_p{pi}(ni,:)] = obj.averr(gp{hi}.choicecurve_p{ni,pi});
%             %                         end
%             %                     end
%         end
%         avs{hi}.xbins_reward = xbins_reward;
%         avs{hi}.xbins_ntrial = xbins_ntrial;
%         avs{hi}.xbins_simucdf = xbins_simucdf;
%     end
%     obj.avs{di} = avs;
%     obj.avsfull{di} = avsfull;
% end
% end
% function get_pfit(obj)
% data = obj.data;
% horizons = obj.horizons;
% scdf = obj.simucdf;
% teye = eye(5);
% for si = 1:length(data)
%     game = data(si).task;
%     idx5 = game.horizon == 5;
%     %                 tRT = game.rt_s(idx5);
%     cards = game.cards(idx5,:);
%     st = game.nstop_s(idx5);
%     idxst = st >= 1 & st <= 5;
%     st = st(idxst);
%     cards = cards(idxst,:);
%     %                 tRT = tRT(idxst);
%     st = 6-st;
%     c = [];
%     c = arrayfun(@(x)teye(x,:), st, 'UniformOutput', false);
%     c = vertcat(c{:});
%     c = c(:,2:5);
%     %                 t1 = arrayfun(@(x)obj.extendnan(x.key,5), tRT, 'UniformOutput', false);
%     %                 t1 = vertcat(t1{:});
%     %                 t2 = arrayfun(@(x)obj.extendnan(x.draw,5), tRT, 'UniformOutput', false);
%     %                 t2 = vertcat(t2{:});
%     %                 tt = t1 - t2;
%     %                 tt = tt(:);
%     %                 RT.max(si) = nanmax(tt(:));
%     %                 RT.mean(si) = nanmean(tt(:));
%     %                 RT.mid(si) = nanmedian(tt(:));
%     %                 tts = sort(tt(~isnan(tt)));
%     %                 l = length(tts);
%     %                 RT.mean90(si) = nanmean(tts(round(0.1*l):round(0.9*l)));
%     %                 RT.mid75(si) = tts(round(0.75*l));
%     %                 RT.p(si) = nanmean(tt(:)>1);
%     for pi = 1:4
%         tcdf = scdf{pi};
%         pcards = [];
%         for hi = 2:5
%             pcards(:,hi-1) = arrayfun(@(x)tcdf(hi,x),cards(:,6-hi));
%         end
%         pp = c.* pcards + (1-pcards).* (1-c);
%         logpp = log(pp);
%         pfit.ll{pi}(si,:) = sum(logpp);
%         pfit.pav{pi}(si,:) = nanmean(pp);
%         pfit.p50{pi}(si,:) = nanmean(pp >= 0.5);
%     end
% end
% %             obj.RT = RT;
% obj.pfit = pfit;
% end
% function get_pfit_sub(obj)
% data = obj.data;
% horizons = obj.horizons;
% scdf0 = obj.simucdfs;
% te = eye(5);
% for si = 1:length(data)
%     scdf = scdf0{si};
%     game = data(si).task;
%     idx5 = game.horizon == 5;
%     tRT = game.rt_s(idx5);
%     cards = game.cards(idx5,:);
%     st = game.nstop_s(idx5);
%     idxst = st >= 1 & st <= 5;
%     st = st(idxst);
%     cards = cards(idxst,:);
%     tRT = tRT(idxst);
%     st = 6-st;
%     t1 = arrayfun(@(x)obj.extendnan(x.key,5), tRT, 'UniformOutput', false);
%     t1 = vertcat(t1{:});
%     t2 = arrayfun(@(x)obj.extendnan(x.draw,5), tRT, 'UniformOutput', false);
%     t2 = vertcat(t2{:});
%     tt = t1 - t2;
%     RT.max(si) = nanmax(tt(:));
%     RT.mean(si) = nanmean(tt(:));
%     RT.mid(si) = nanmedian(tt(:));
%     tts = sort(tt(~isnan(tt)));
%     l = length(tts);
%     RT.mean90(si) = nanmean(tts(round(0.1*l):round(0.9*l)));
%     RT.mid75(si) = tts(round(0.75*l));
%     for pi = 1:4
%         tcdf = scdf{pi};
%         pcards = [];
%         c = [];
%         c = arrayfun(@(x)te(x,:), st, 'UniformOutput', false);
%         c = vertcat(c{:});
%         c = c(:,2:5);
%         for hi = 2:5
%             pcards(:,hi-1) = arrayfun(@(x)tcdf(hi,x),cards(:,6-hi));
%         end
%         pp = c.* pcards + (1-pcards).* (1-c);
%         logpp = log(pp(:));
%         pfit.ll(si,pi) = sum(logpp);
%         pfit.pav(si,pi) = nanmean(pp(:));
%         pfit.p50(si,pi) = nanmean(pp(:) >= 0.5);
%     end
% end
% obj.RT = RT;
% obj.pfit_sub = pfit;
% end
% function out = getpall(obj, thres,noise,kbest,kp, kw, rewards, c, rbest, rp, rw)
% kbest = 0;
% kp = 0;
% kw = 0;
% p(c == 1) = log(1./(1+exp(-(rewards(c == 1) - thres + kbest*rbest(c == 1)+ kp*rp(c == 1)+ kw*rw(c == 1))/noise)));
% p(c == 0) = log(1 - 1./(1+exp(-(rewards(c == 0) - thres + kbest*rbest(c == 0)+ kp*rp(c == 0)+ kw*rw(c == 0))/noise)));
% out = sum(p);
% end
% 
% function re = thresfit(obj, rewards, c, bestrewards, pastr, worstr)
% func = @(x)-obj.getpall(x(1), x(2), x(3), x(4), x(5), ...
%     rewards, c, bestrewards, pastr, worstr);
% X0 = [50 10 0 0 0];
% LB = [0 0.01 -100 -100 -100];
% UB = [100 100 100 100 100];
% te = fmincon(func, X0, [],[],[],[],LB, UB);
% re.t = te(1);
% re.n = te(2);
% re.k = te(3);
% re.kp = te(4);
% re.kw = te(5);
% end
% function re = getreward(obj)
% x0 = obj.tskpara.x0;
% x1 = obj.tskpara.x1;
% M = obj.tskpara.M;
% re = floor(x0 + rand()*M);
% end
% function [reward, nstop] = simuR(obj, n)
% i = n;
% nstop = NaN;
% reward = 0;
% if isempty(obj.tempthrs)
%     obj.tempthrs = obj.opthrs;
% end
% thres = obj.tempthrs;
% while (i>0)
%     r = obj.getreward();
%     if r >= thres(i)
%         nstop = i;
%         reward = r;
%         break;
%     else
%         i = i - 1;
%     end
% end
% end
% function [dist, x] = simudistribution(obj, n, m, nPolicy)
% % n - number of cards left
% % m - number of simulations
% % nPolicy - how many samples to take in each simulation
% q = zeros(1, m) ;
% greaterReward = 0 ;
% for i = 1:m
%     for j = 1:nPolicy
%         tq(j) = obj.simuR(n-1);
%     end
%     q(i) = mean(tq);
% end
% [dist, x] = ecdf(q);
% x(1) = 0;
% end
% function plot_policy(obj, overlay)
% if nargin < 2 || overlay == 0
%     colors = {obj.colors.red, obj.colors.mesa, obj.colors.sand, obj.colors.cactus, obj.colors.river};
%     for pi = 1:4
%         obj.figure; clf;
%         %                     obj.glist = [];
%         tcdf = obj.simucdf{pi};
%         obj.lineplot(tcdf,zeros(size(tcdf,1),size(tcdf,2)),0:100,colors);
%         ylim([0 1]);
%         obj.legend({'H = 1', 'H = 2', 'H = 3', 'H = 4', 'H = 5'}, 'Northwest');
%         xlabel('reward');
%         ylabel('cumulative distributive function');
%         title([num2str(pi) '-sample policy']);
%         set(gca, 'FontSize',obj.fontsize_face);
%     end
% else
%     col = obj.colors.sky;
%     color1 = {col*0.2, col*0.4,col*0.6,col*0.8,col};
%     col = obj.colors.sand;
%     color2 = {col*0.2, col*0.4,col*0.6,col*0.8,col};
%     for pi = 1:4
%         obj.figure; clf;
%         obj.glist = [];
%         tcdf = obj.simucdf{pi};
%         obj.lineplot(tcdf,zeros(size(tcdf,1),size(tcdf,2)),0:100,color1);
%         obj.lineplot(obj.avs{1}.av.choicecurve(1:5,:),obj.avs{1}.err.choicecurve(1:5,:),mean(obj.avs{1}.xbins_reward'),color2);
%         ylim([0 1]);
%         lgd = obj.legend(obj.glist, {'model','model','model','model','model',...
%             'data, H = 1', 'data, H = 2', 'data, H = 3', 'data, H = 4', 'data, H = 5'}, 'Northwest');
%         lgd.NumColumns = 2;
%         xlabel('reward');
%         ylabel('cumulative distributive function');
%         title([num2str(pi) '-sample policy']);
%         set(gca, 'FontSize',obj.fontsize.face);
%     end
% end
% end
% function main_simulation(obj)
% m_inf = 10000;
% for pi = [1:4 8]
%     for n = 1:5
%         [tcdf, tx] = obj.simudistribution(n, m_inf, pi);
%         cdf{pi}(n,:) = arrayfun(@(x)tcdf(sum(tx<=x)),0:100);
%     end
% end
% obj.temp_simucdf = cdf;
% if sum(abs(obj.tempthrs - obj.opthrs)) == 0
%     obj.simucdf = obj.temp_simucdf;
%     disp('overwritten');
% end
% end
% function main_simulation_sub(obj)
% im = obj.im;
% for si = 1:length(im)
%     tt = obj.im{si}.thresvsntrial{5};%obj.im{si}.rewardvsntrial{5};
%     obj.tempthrs = obj.extendnan(tt,10);
%     disp(['simulate for subject ', num2str(si)]);
%     obj.main_simulation;
%     obj.simucdfs{si} = obj.temp_simucdf;
% end
% end
% function fakemle(obj)
% for pi = [1 2 4 8]
%     clc;
%     obj.simulatebehavior(pi);
%     obj.default_analysis(1,0);
%     obj.simudata{pi}.thres = obj.avs{5}.av.thresvsntrial;
%     obj.simudata{pi}.threserr = obj.avs{5}.err.thresvsntrial;
%     obj.simudata{pi}.noise = obj.avs{5}.av.noisevsntrial;
%     obj.simudata{pi}.noiseerr = obj.avs{5}.err.noisevsntrial;
% end
% end
% function simulatebehavior(obj, pi)
% data = obj.dataraw;
% scdf = obj.simucdf{pi};
% for si = 1:length(data)
%     game = data(si).task;
%     game.nstop_s = [];
%     game.reward_s = [];
%     for gi = 1:length(game.horizon)
%         h = game.horizon(gi);
%         if h > 5
%             game.nstop_s(gi) = NaN;
%             game.reward_s(gi) = NaN;
%             continue;
%         end
%         cards = game.cards(gi,:);
%         c = 1;
%         while c < h
%             r = cards(c);
%             p = scdf(6-c,r+1);
%             if (rand < p)
%                 break;
%             else
%                 c = c+1;
%             end
%         end
%         game.nstop_s(gi) = c;
%         game.reward_s(gi) = cards(c);
%     end
%     data(si).task = game;
% end
% obj.simudata{pi}.behavior = data;
% obj.data = data;
% end
% function simulatebehavior_sub(obj, pi)
% data = obj.dataraw;
% for si = 1:length(data)
%     scdf = obj.simucdfs{si}{pi};
%     game = data(si).task;
%     game.nstop_s = [];
%     game.reward_s = [];
%     for gi = 1:length(game.horizon)
%         h = game.horizon(gi);
%         if h > 5
%             game.nstop_s(gi) = NaN;
%             game.reward_s(gi) = NaN;
%             continue;
%         end
%         cards = game.cards(gi,:);
%         c = 1;
%         while c < h
%             r = cards(c);
%             p = scdf(6-c,r+1);
%             if (rand < p)
%                 break;
%             else
%                 c = c+1;
%             end
%         end
%         game.nstop_s(gi) = c;
%         game.reward_s(gi) = cards(c);
%     end
%     data(si).task = game;
% end
% obj.simudata{pi}.behavior = data;
% obj.data = data;
% end
% function plot_choicecurves_diff(obj)
% for expi = 1:length(obj.data)
%     horizons = obj.horizons{expi};
%     avs = obj.avs{expi};
%     h2max = max(horizons(horizons ~= max(horizons)));
%     obj.figure(2,2);
%     for hhi = 2:h2max
%         thorizons = horizons(horizons >= hhi);
%         obj.now_color = obj.colorh(thorizons);
%         legs = arrayfun(@(x)['Horizon = ',num2str(x)],thorizons,'UniformOutput',false);
%         av = arrayfun(@(x)avs{x}.av.choicecurve(hhi,:), thorizons,'UniformOutput',false);
%         av = vertcat(av{:});
%         err = arrayfun(@(x)avs{x}.err.choicecurve(hhi,:), thorizons,'UniformOutput',false);
%         err = vertcat(err{:});
%         obj.new;
%         obj.leglist = [];
%         gps = cellfun(@(x)x.choicecurve(hhi), obj.gp{expi}(thorizons));
%         stats = obj.untitled_getgpanova(gps);
%         obj.statshade(stats(1,:), mean(avs{thorizons(1)}.xbins_reward'),[0 1], 5);
%         obj.lineplot(av,err,mean(avs{thorizons(1)}.xbins_reward',1));
%         ylim([0 1]);
%         obj.temp_legloc = 'Northwest';
%         obj.legend(legs);
%         xlabel('reward');
%         ylabel('p(stop)');
%         set(gca, 'FontSize',obj.fontsize_face);
%         set(gca, 'XTick', [0:20:100]);
%         
%     end
%     obj.save(['Choicecurve_diff',obj.savesuffixs{expi}]);
% end
% end
% function plot_choicecurves(obj)
% for i = 1:length(obj.data)
%     obj.expi = i;
%     obj.plot_choicecurve;
% end
% obj.expi = [];
% end
% function plot_choicecurve(obj)
% expi = obj.expi;
% horizons = obj.horizons{expi};
% avs = obj.avs{expi};
% obj.figure(2,2);
% gp = obj.gp{expi};
% %             tfontleg = obj.fontsize_leg;
% %             obj.fontsize_leg = round(obj.fontsize_leg*2/3);
% for hhi = 1:length(horizons)
%     obj.new;
%     %                 colors = colors(10:-1:1);
%     hi = horizons(hhi);
%     obj.now_color = obj.colorh(1:hi);
%     th = min(hi,5);
%     legs = arrayfun(@(x)[num2str(x), ' cards remaining'],1:hi,'UniformOutput',false);
%     %                 obj.figure; clf;
%     obj.leglist = [];
%     gps = gp{hi}.choicecurve(2:th);
%     stats = obj.untitled_getgpanova(gps);
%     obj.statshade(stats(1,:), mean(avs{hi}.xbins_reward'),[0 1], 5);
%     obj.lineplot(avs{hi}.av.choicecurve(1:th,:),avs{hi}.err.choicecurve(1:th,:),mean(avs{hi}.xbins_reward'));
%     ylim([0 1]);
%     obj.temp_legloc =  'Northwest';
%     obj.legend(legs(1:th));
%     xlabel('reward');
%     ylabel('p(stop)');
%     set(gca, 'FontSize',obj.fontsize_face);
%     set(gca, 'XTick', [0:20:100]);
%     %                 obj.save(['Choicecurve_h',num2str(hi), obj.savesuffixs{expi}]);
%     if hi == 10
%         %                     obj.figure; clf;
%         obj.new;
%         obj.leglist = [];
%         obj.now_color = obj.colorh(5:10);
%         gps = gp{hi}.choicecurve(5:10);
%         stats = obj.untitled_getgpanova(gps);
%         obj.statshade(stats(1,:), mean(avs{hi}.xbins_reward'), [0 1],5);
%         obj.lineplot(avs{hi}.av.choicecurve(5:10,:),avs{hi}.err.choicecurve(5:10,:),mean(avs{hi}.xbins_reward'));
%         ylim([0 1]);
%         ylim([0 1]);
%         legs = arrayfun(@(x)[num2str(x), ' cards remaining'],5:10,'UniformOutput',false);
%         obj.temp_legloc =  'Northwest';
%         obj.legend(legs(1:6));
%         xlabel('reward');
%         ylabel('p(stop)');
%         set(gca, 'FontSize',obj.fontsize_face);
%         set(gca, 'XTick', [0:20:100]);
%     end
% end
% %             obj.fontsize_leg = tfontleg;
% obj.save(['Choicecurve', obj.savesuffixs{expi}]);
% end
% function plot_choicecurve_ntrial(obj)
% colors = {obj.colors.red, obj.colors.mesa, obj.colors.sand, obj.colors.cactus, obj.colors.river};
% horizons = obj.horizons;
% temph = sort(horizons);
% maxh = temph(end-1);
% for thi = 1:maxh
%     count = 0;
%     legs = [];
%     av = [];
%     err = [];
%     for hhi = 1:length(horizons)
%         hi = horizons(hhi);
%         if hi < thi
%             continue;
%         else
%             count = count + 1;
%         end
%         legs{count} = ['H = ', num2str(hi)];
%         av(count,:) = obj.avs{hi}.av.choicecurve(thi,:);
%         err(count,:) = obj.avs{hi}.err.choicecurve(thi,:);
%     end
%     obj.figure; clf;
%     obj.leglist = [];
%     obj.lineplot(av,err,mean(obj.avs{horizons(1)}.xbins_reward'),colors(6-count:end));
%     ylim([0 1]);
%     obj.legend(legs, 'Northwest');
%     xlabel('reward');
%     ylabel('p(stop)');
%     set(gca, 'FontSize',obj.fontsize_face);
%     obj.save(['Choicecurve_ntrial_h',num2str(thi), obj.savesuffix,'.mat']);
%     
% end
% end
% function plot_choicecurve_initial(obj)
% for expi = 1:length(obj.data)
%     horizons = obj.horizons{expi};
%     gp = obj.gp{expi};
%     avs = obj.avs{expi};
%     h2max = max(horizons(horizons ~= max(horizons)));
%     obj.figure;
%     hh = 1:length(horizons);
%     thorizons = horizons(hh);
%     obj.now_color = obj.colorh(thorizons);
%     legs = arrayfun(@(x)['Horizon = ',num2str(x)],thorizons,'UniformOutput',false);
%     av = arrayfun(@(x)avs{x}.av.choicecurve(x,:), thorizons,'UniformOutput',false);
%     av = vertcat(av{:});
%     err = arrayfun(@(x)avs{x}.err.choicecurve(x,:), thorizons,'UniformOutput',false);
%     err = vertcat(err{:});
%     obj.new;
%     gps = arrayfun(@(x)gp{x}.choicecurve{x}, thorizons,'UniformOutput',false);
%     stats = obj.untitled_getgpanova(gps);
%     obj.statshade(stats(1,:), mean(avs{thorizons(1)}.xbins_reward',1),[0 1], 5);
%     
%     obj.leglist = [];
%     obj.lineplot(av,err,mean(avs{thorizons(1)}.xbins_reward',1));
%     ylim([0 1]);
%     obj.temp_legloc = 'Northwest';
%     obj.legend(legs);
%     xlabel('reward');
%     ylabel('p(stop)');
%     set(gca, 'FontSize',obj.fontsize_face);
%     set(gca, 'XTick', [0:20:100]);
%     obj.save(['Choicecurve_initial_', obj.savesuffixs{expi}]);
% end
% end

% function plot_choicecurve_h5(obj)
% obj.figure(2,2);
% avs = obj.avs;
% nexp = length(obj.data);
% for hi = 2:5
%     obj.now_color = {obj.colors.AZred, obj.colors.AZblue, obj.colors.AZcactus};
%     legs = {'Exp 1','Exp 2','Exp 3'};
%     
%     av = arrayfun(@(x)avs{x}{5}.av.choicecurve(hi,:), 1:nexp,'UniformOutput',false);
%     av = vertcat(av{:});
%     err = arrayfun(@(x)avs{x}{5}.err.choicecurve(hi,:), 1:nexp,'UniformOutput',false);
%     err = vertcat(err{:});
%     gps = arrayfun(@(x)obj.gp{x}{5}.choicecurve(hi), 1:length(obj.data));
%     stats = obj.untitled_getgpanova(gps);
%     obj.new;
%     obj.statshade(stats(1,:), mean(avs{1}{5}.xbins_reward',1),[0 1], 5);
%     
%     obj.leglist = [];
%     obj.lineplot(av,err,mean(avs{1}{5}.xbins_reward',1));
%     ylim([0 1]);
%     obj.temp_legloc = 'NorthWest';
%     obj.legend(legs);
%     xlabel(['reward, H = ', num2str(hi)]);
%     ylabel('p(stop)');
%     set(gca, 'FontSize',obj.fontsize_face);
%     set(gca, 'XTick', [0:20:100]);
% end
% obj.save(['Choicecurve_h5']);
% 
% end
% function plot_choicecurve_p(obj)
% colors = {obj.colors.red, obj.colors.mesa, obj.colors.sand, obj.colors.cactus, obj.colors.river};
% for hi = 1:2
%     for pi = 1:4
%         obj.figure; clf;
%         obj.glist = [];
%         obj.lineplot(obj.avs{hi}.av.choicecurve_p{pi}(1:5,:),obj.avs{hi}.err.choicecurve_p{pi}(1:5,:),mean(obj.avs{hi}.xbins_simucdf'),colors);
%         ylim([0 1]);
%         obj.legend(obj.glist, {'H = 1', 'H = 2', 'H = 3', 'H = 4', 'H = 5'}, 'Northwest');
%         xlabel(['cdf, ', num2str(pi), '-sample policy']);
%         ylabel('p(stop)');
%         set(gca, 'FontSize',obj.fontsize.face);
%     end
% end
% 
% end
% function [av, err] = plot_mle_v1_5only(obj, suffixstr)
% if ~exist('suffixstr')
%     suffixstr = '';
% end
% obj.figure; clf;
% legs = {'Optimal'};
% obj.leglist = [];
% hold on;
% avs = obj.avs;
% clrs = { obj.colors.river, obj.colors.red};
% obj.leglist = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);
% hi = 5;
% av{1} = avs{hi}.av.thresvsntrial(2:5);
% err{1} = avs{hi}.err.thresvsntrial(2:5);
% obj.lineplot(av{1},err{1},[hi-1:-1:1],clrs(2));
% legs{end+1} = ['Experiment 1'];
% obj.legend(legs);
% set(gca, 'XTick', 1:4, 'XTickLabels', 5:-1:2);
% xlabel('number of cards left');
% ylabel('threshold');
% set(gca, 'FontSize',obj.fontsize_face);
% obj.lim([0.5 4.5],[45 90]);
% obj.save(['mle_thres_v1_5only' suffixstr]);
% 
% obj.figure; clf;
% %             legs = {'optimal'};
% obj.leglist = [];
% hold on;
% avs = obj.avs;
% clrs = { obj.colors.cactus, obj.colors.red};
% %             obj.leglist = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);
% hi = 5;
% av{2} = avs{hi}.av.noisevsntrial(2:5);
% err{2} = avs{hi}.err.noisevsntrial(2:5);
% obj.lineplot(av{2},err{2},...
%     [hi-1:-1:1],clrs(2));
% legs = {['Experiment 1']};
% obj.legend(legs);
% set(gca, 'XTick', 1:4, 'XTickLabels', 5:-1:2);
% xlabel('number of cards left');
% ylabel('variability');
% set(gca, 'FontSize',obj.fontsize_face);
% obj.lim([0.5 4.5],[2 12]);
% obj.save(['mle_noise_v1_5only' suffixstr]);
% 
% end
% function plot_mle(obj)
% for expi = 1:length(obj.data)
%     obj.figure(1,2);
%     obj.new;
%     legs = {'optimal'};
%     horizons = obj.horizons{expi};
%     obj.leglist = [];
%     hold on;
%     avs = obj.avs{expi};
%     obj.now_color = obj.colorh(horizons);
%     av = [];
%     err = [];
%     obj.leglist = plot(2:max(horizons),obj.opthrs(max(horizons):-1:2), '*','LineWidth', obj.linewidth);
%     for hhi = 1:length(horizons)
%         hi = horizons(hhi);
%         av(hhi,:) = obj.getcolumn(avs{hi}.av.thresvsntrial(2:hi),max(horizons)-1);
%         err(hhi,:) = obj.getcolumn(avs{hi}.err.thresvsntrial(2:hi),max(horizons)-1);
%         legs{end+1} = ['H = ', num2str(hi)];
%     end
%     
%     gps = arrayfun(@(x)obj.gp{expi}{x}.thresvsntrial, horizons,'UniformOutput',false);
%     stats = obj.untitled_getgpanova(gps);
%     obj.statshade(stats(1,2:end), [max(horizons):-1:2],[0 100], 0.5);
%     obj.lineplot(av,err,[max(horizons):-1:2]);
%     
%     obj.legend(legs);
%     set(gca, 'XTick', 2:max(horizons), 'XTickLabels', max(horizons):-1:2);
%     xlabel('number of cards left');
%     ylabel('threshold');
%     set(gca, 'FontSize',obj.fontsize_face);
%     obj.lim([1.5 max(horizons)+0.5],[]);
%     %                 obj.save(['mle_thres',obj.savesuffixs{expi}]);
%     
%     obj.new;
%     gps = arrayfun(@(x)obj.gp{expi}{x}.noisevsntrial, horizons,'UniformOutput',false);
%     stats = obj.untitled_getgpanova(gps);
%     obj.statshade(stats(1,2:end), [max(horizons):-1:2],[0 100], 0.5);
%     
%     legs = {};
%     horizons = obj.horizons{expi};
%     obj.leglist = [];
%     hold on;
%     av = [];
%     err = [];
%     avs = obj.avs{expi};
%     obj.now_color = obj.colorh(horizons);
%     for hhi = 1:length(horizons)
%         hi = horizons(hhi);
%         av(hhi,:) = obj.getcolumn(avs{hi}.av.noisevsntrial(2:hi),max(horizons)-1);
%         err(hhi,:) = obj.getcolumn(avs{hi}.err.noisevsntrial(2:hi),max(horizons)-1);
%         legs{end+1} = ['H = ', num2str(hi)];
%     end
%     obj.lineplot(av,err,[max(horizons):-1:2]);
%     
%     obj.legend(legs);
%     set(gca, 'XTick', 2:max(horizons), 'XTickLabels', max(horizons):-1:2);
%     xlabel('number of cards left');
%     ylabel('variability');
%     set(gca, 'FontSize',obj.fontsize_face);
%     obj.lim([1.5 max(horizons)+0.5],[]);
%     obj.save(['mle',obj.savesuffixs{expi}]);
% end
% end
% function plot_thresvsnoise(obj)
% for expi = 1:length(obj.data)
%     horizons = obj.horizons{expi};
%     for hoi = horizons
%         obj.figure(2,2);
%         obj.holdon = false;
%         obj.leglist = [];
%         avs = obj.avs{expi};
%         now_color = obj.colorh(1:5);
%         gps1 = arrayfun(@(x)obj.gp{expi}{x}.rewardvsntrial, hoi,'UniformOutput',false);
%         gps2 = arrayfun(@(x)obj.getcolumn(obj.gp{expi}{x}.noisevsntrial,10), hoi,'UniformOutput',false);
%         for hi = 2:5
%             legs = {};
%             a1 = cellfun(@(x)x(:,hi),gps1,'UniformOutput',false);
%             a1 = vertcat(a1{:});
%             a2 = cellfun(@(x)x(:,hi),gps2,'UniformOutput',false);
%             a2 = vertcat(a2{:});
%             obj.now_color = now_color(hi);
%             obj.untitled_scattercorr(a2,a1, {['#card left = ', num2str(hi)]});
%             xlabel('threshold');
%             ylabel('noise');
%             set(gca, 'FontSize',obj.fontsize_face);
%         end
%         obj.save(['thresnoise',obj.savesuffixs{expi},'_h',num2str(hoi)]);
%     end
% end
% end
% function plot_mle_initial(obj)
% for expi = 1:length(obj.data)
%     horizons = obj.horizons{expi};
%     gp = obj.gp{expi};
%     obj.figure(1,2);
%     obj.new;
%     %                 for hhi = 1:length(horizons)
%     %                     hi = horizons(hhi);
%     %                     gps{hhi} = gp{hi}.thresvsntrial(:,hi);
%     % %                     legs{end+1} = ['H = ', num2str(hi)];
%     %                 end
%     %                 gps = arrayfun(@(x){}.noisevsntrial, ,'UniformOutput',false);
%     %                 stats = obj.untitled_getgpanova(gps);
%     %                 obj.statshade(stats(1,2:end), [hi:-1:2],[0 100], 0.5);
%     
%     legs = {'optimal',['Experiment ', num2str(expi)]};
%     obj.leglist = [];
%     hold on;
%     avs = obj.avs{expi};
%     clrs = obj.colorh;
%     av = [];
%     err = [];
%     %                 av = nan(1,max(horizons));
%     %                 err = nan(1,max(horizons));
%     obj.leglist = plot(2:max(horizons),obj.opthrs(max(horizons):-1:2), '*','LineWidth', obj.linewidth);
%     obj.lim;
%     for hhi = 1:length(horizons)
%         hi = horizons(hhi);
%         av(hhi) = avs{hi}.av.thresvsntrial(hi);
%         err(hhi) = avs{hi}.err.thresvsntrial(hi);
%         %                     legs{end+1} = ['H = ', num2str(hi)];
%     end
%     obj.now_color = {obj.colors.AZcactus};
%     obj.lineplot(av,err,max(horizons) + 2-horizons);
%     
%     obj.legend(legs);
%     set(gca, 'XTick', 2:max(horizons), 'XTickLabels', max(horizons):-1:2);
%     xlabel('number of cards left');
%     ylabel('threshold');
%     set(gca, 'FontSize',obj.fontsize_face);
%     obj.lim([1.5 max(horizons)+0.5],[]);
%     %                 obj.save(['mle_thres',obj.savesuffixs{expi}]);
%     
%     obj.new;
%     legs = {['Experiment ', num2str(expi)]};
%     horizons = obj.horizons{expi};
%     obj.leglist = [];
%     hold on;
%     av = [];
%     err = [];
%     avs = obj.avs{expi};
%     clrs = obj.colorh;
%     for hhi = 1:length(horizons)
%         hi = horizons(hhi);
%         av(hhi) = avs{hi}.av.noisevsntrial(hi);
%         err(hhi) = avs{hi}.err.noisevsntrial(hi);
%         %                     legs{end+1} = ['H = ', num2str(hi)];
%     end
%     obj.now_color = {obj.colors.AZcactus};
%     obj.lineplot(av,err,max(horizons) + 2-horizons);
%     obj.legend(legs);
%     set(gca, 'XTick', 2:max(horizons), 'XTickLabels', max(horizons):-1:2);
%     xlabel('number of cards left');
%     ylabel('variability');
%     set(gca, 'FontSize',obj.fontsize_face);
%     obj.lim([1.5 max(horizons)+0.5],[]);
%     obj.save(['mle_initial_',obj.savesuffixs{expi}]);
% end
% end
% function plot_mle_h5(obj)
% hi = 5;
% obj.figure(1,2);
% obj.new;
% gps = arrayfun(@(x)obj.gp{x}{5}.thresvsntrial, 1:length(obj.data),'UniformOutput',false);
% stats = obj.untitled_getgpanova(gps);
% obj.statshade(stats(1,2:end), [hi:-1:2],[0 100], 0.5);
% 
% obj.leglist = [];
% hold on;
% avs = obj.avs;
% obj.now_color = {obj.colors.AZred, obj.colors.AZblue, obj.colors.AZcactus};
% obj.leglist = [];
% for expi = 1:length(obj.data)
%     av(expi,:) = avs{expi}{hi}.av.thresvsntrial(2:5);
%     err(expi,:) = avs{expi}{hi}.err.thresvsntrial(2:5);
% end
% 
% obj.leglist(end+1) = plot(2:5,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);%,'Color',clrs{3});
% obj.lim;
% obj.lineplot(av,err,[hi:-1:2]);
% legs = {'Optimal'};
% legs{end+1} = ['Experiment 1'];
% legs{end+1} = ['Experiment 2'];
% legs{end+1} = ['Experiment 3'];
% obj.legend(legs);
% set(gca, 'XTick', 2:hi, 'XTickLabels', hi:-1:2);
% xlabel('number of cards left');
% ylabel('threshold');
% set(gca, 'FontSize',obj.fontsize_face);
% obj.lim([1.5 hi+0.5],[]);
% 
% 
% obj.new;
% gps = arrayfun(@(x)obj.gp{x}{5}.noisevsntrial, 1:length(obj.data),'UniformOutput',false);
% stats = obj.untitled_getgpanova(gps);
% obj.statshade(stats(1,2:end), [hi:-1:2],[0 100], 0.5);
% obj.leglist = [];
% hold on;
% avs = obj.avs;
% obj.now_color = {obj.colors.AZred, obj.colors.AZblue, obj.colors.AZcactus};
% %             hi = 5;
% obj.leglist = [];
% for expi = 1:length(obj.data)
%     av(expi,:) = avs{expi}{hi}.av.noisevsntrial(2:5);
%     err(expi,:) = avs{expi}{hi}.err.noisevsntrial(2:5);
% end
% %             obj.leglist(end+1) = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);%,'Color',clrs{3});
% obj.lineplot(av,err,[hi:-1:2]);
% %             obj.lim;
% legs = {};
% legs{end+1} = ['Experiment 1'];
% legs{end+1} = ['Experiment 2'];
% legs{end+1} = ['Experiment 3'];
% obj.legend(legs);
% set(gca, 'XTick', 2:hi, 'XTickLabels', hi:-1:2);
% xlabel('number of cards left');
% ylabel('threshold');
% set(gca, 'FontSize',obj.fontsize_face);
% obj.lim([1.5 hi+0.5],[]);
% obj.save('mle_h5');
% 
% end
% function plot_rewardtostop(obj)
% obj.figure; clf;
% obj.glist = [];
% legs = {'h = 5', 'h = 10'};
% hold on;
% avs = obj.avs;
% clrs = {obj.colors.cactus, obj.colors.red};
% obj.lineplot(avs{1}.av.rewardvsntrial,avs{1}.err.rewardvsntrial,[6:10,1:5],clrs(1));
% obj.lineplot(avs{2}.av.rewardvsntrial,avs{2}.err.rewardvsntrial,[1:10],clrs(2));
% obj.legend(obj.glist, legs);
% set(gca, 'XTick', 1:10, 'XTickLabels', 10:-1:1);
% xlabel('number of cards left');
% ylabel('mean reward');
% set(gca, 'FontSize',obj.fontsize.face);
% %             obj.figure; clf;
% %             hold on;
% %             im = obj.im;
% %             for si = 1:length(im)
% %                 scatter([6:10], im{si}.rewardvsntrial{1}(1:5),2,obj.colors.cactus);
% %             end
% %                             scatter([1:10], im{si}.rewardvsntrial{2}(1:10),2,obj.colors.red);
% 
% end
% %         function get_n_trials(obj)
% %             data = obj.data;
% %             for si = 1:length(data)
% %                 data{si}.task.n_stop
% %             end
% %         end
% function card_regression(obj)
% data = obj.data;
% for si = 1:length(data)
%     game = data{si}.task;
%     nstop = game.nstop_s;
%     idx = arrayfun(@(x)obj.getcolumn([ones(1,x)],10), nstop, 'UniformOutput', false);
%     idx = vertcat(idx{:});
%     choice = arrayfun(@(x)obj.getcolumn([zeros(1,x-1),1],10), nstop, 'UniformOutput', false);
%     choice = vertcat(choice{:});
%     R_past = [repmat(0,game.n_game,1),game.cards(:,1:end-1)];
%     for gi = 1:game.n_game
%         R_best(gi,1) = 0;
%         R_worst(gi,1) = 100;
%         for ti = 2:10
%             R_best(gi,ti) = max(R_best(gi,ti-1), game.cards(gi,ti-1));
%             R_worst(gi,ti) = min(R_worst(gi,ti-1), game.cards(gi,ti-1));
%         end
%         R_worst(gi,1) = 0;
%         R_best(gi,1) = 0;
%     end
%     C = choice.*idx;
%     R = game.cards.*idx;
%     R_past = R_past.*idx;
%     R_best = R_best.*idx;
%     R_worst = R_worst.*idx;
%     for hi = 1:10
%         idx_nan = ~isnan(C(:,hi));
%         func = @(x)obj.prob(x, C(idx_nan,hi), R(idx_nan,hi), R_past(idx_nan,hi), R_best(idx_nan,hi), R_worst(idx_nan,hi));
%         X0 = [0 0 0 0 0];
%         XMIN = [-inf -inf -inf -inf -inf];
%         XMAX = [inf inf inf inf inf];
%         [xfit] = fmincon(func, X0, [],[],[],[],XMIN, XMAX);
%         a_0(si, hi) = xfit(1);
%         a_R(si, hi) = xfit(2);
%         a_Rpast(si, hi) = xfit(3);
%         a_Rbest(si, hi) = xfit(4);
%         a_Rworst(si, hi) = xfit(5);
%     end
% end
% for hi = 1:10
%     figure(hi);
%     xfit = [a_R(:,hi),a_Rpast(:,hi),a_Rbest(:,hi),a_Rworst(:,hi)];
%     boxplot(xfit)
% end
% end
% function out = prob(obj, x, C, R, R_past, R_best, R_worst)
% t = x(1) + x(2)* R +x(3)*R_past + x(4) * R_best + x(5) * R_worst;
% logp(C == 1) = log(1./(1+ exp(t(C == 1))));
% logp(C == 0) = log(1 - 1./(1+ exp(t(C == 0))));
% out = sum(logp);
% end
% function fit_policy(obj)
% data = obj.data;
% for si = 1:length(data)
%     game = data{si}.task;
%     pfit{si} = obj.fit_policy_ind(game);
% end
% pfit = vertcat(pfit{:});
% obj.pfit = pfit;
% end
% function xfit = fit_policy_ind(obj, game)
% choice = arrayfun(@(x)obj.getcolumn([zeros(1,x-1),1],10), game.nstop_s, 'UniformOutput', false);
% choice = vertcat(choice{:});
% choice(:,end) = NaN;
% tN = repmat(1:10,size(choice,1),1);
% idx = ~isnan(choice);
% Cs = choice(idx);
% Rs = game.cards(idx);
% Ns = tN(idx);
% X0 = [1 1 1 1 1 1 1 1 1];
% LB = [0 0 0 0 0 0 0 0 0];
% UB = [100 100 100 100 100 100 100 100 100];
% func = @(x)-obj.LL_1sample(x, Ns, Rs, Cs);
% xfit = fmincon(func, X0, [],[],[],[],LB, UB);
% end
% function LL = LL_1sample(obj, thetas, Ns, Rs, Cs)
% for gi = 1:length(Cs)
%     tL = obj.LL_1sample_singletrial(thetas(1:Ns(gi)-1),Ns(gi),Rs(gi));
%     if Cs(gi) == 1
%         L(gi) = tL;
%     else
%         L(gi) = 1-tL;
%     end
%     L(gi) = log(L(gi));
% end
% LL = sum(L);
% end
% function LL = LL_1sample_singletrial(obj, thetas, n, R)
% M = obj.tskpara.M;
% x = [0 thetas M];
% f(n) = 1/M;
% for ni = n-1:-1:1
%     f(ni) = f(ni+1)*thetas(ni)/M;
% end
% LL = 0;
% for ni = 1:n
%     if x(ni+1) <= R
%         LL = LL + f(ni);
%     elseif x(ni) <= R
%         LL = LL + f(ni) * (R - x(ni))/(x(ni+1)-x(ni));
%     end
% end
% end
% function [av, err] = averr(obj, x)
% av = nanmean(x);
% err = nanstd(x)/sqrt(size(x,1));
% end
