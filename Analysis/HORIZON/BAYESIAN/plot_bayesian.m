classdef plot_bayesian < plot_horizonn
    properties
        samples
        stats
        time_bayesianfit
    end
    methods
        function obj = plot_bayesian()
        end
        function loadbayes(obj, modelname, issample)
            disp('loading stats');
            files = dir(fullfile(obj.siyupathresultbayes,[obj.savename '_' modelname...
                obj.savesuffix '_bayesresult.mat']));
            for fi = 1:length(files)
                stats = importdata(fullfile(files(fi).folder, files(fi).name));
                if strcmp(modelname, '2noisemodel')
                    fmodelname = 'twonoisemodel';
                else
                    fmodelname = modelname;
                end
                obj.stats.(fmodelname) = stats.stats;
                obj.time_bayesianfit = stats.tictoc;
            end
            if exist('issample') && issample == 1
                disp('loading samples');
                obj.samples = importdata(fullfile(obj.siyupathresultbayes, [obj.savename '_' modelname...
                obj.savesuffix '_bayessamples.mat']));
            end
            disp('loaded');
        end
        function plot_corrbehavior_2noise(obj)
            int = obj.stats.stats.mean.dNs';
            ext = obj.stats.stats.mean.Eps';
            lm13 = obj.temp_gp.p_lm13;
            lm22 = obj.temp_gp.p_lm22;
            da13 = obj.temp_gp.p_da13;
            da22 = obj.temp_gp.p_da22;
            d{1} = lm13; name{1} = 'p(low mean, [1 3])';
            d{2} = lm22; name{2} = 'p(low mean, [2 2])';
            d{3} = da13; name{3} = 'p(inconsistent, [1 3])';
            d{4} = da22; name{4} = 'p(inconsistent, [2 2])';
            colors = {};
            for hi = 1:2
                for i = 1:length(d)
                    obj.figure(1,1);
                    obj.scattercorr(d{i}(:,hi), {int(:,hi), ext(:,hi)}, {'internal', 'external'},...
                        {obj.colors.mesa,obj.colors.river});
                    xlabel('decision noise');
                    ylabel(name{i});
                end
            end
        end
        function plot_corrbehavior(obj)
            hi13 = obj.temp_gp.p_hi_13;
            lm22 = obj.temp_gp.p_lm_22;
            sb22 = obj.temp_gp.p_r_22;
            d{1} = hi13; name{1} = 'p(high info, [1 3])';
            d{2} = lm22; name{2} = 'p(low mean, [2 2])';
            d{3} = sb22; name{3} = 'p(right, [2 2])';
            e{1} = obj.stats.simplemodel.mean.IB; nameb{1} = 'information bonus';
            e{2} = obj.stats.simplemodel.mean.N; nameb{2} = 'decision noise';
            e{3} = obj.stats.simplemodel.mean.SB; nameb{3} = 'spatial bias';
            colors = {};
            for i = 1:length(d)
                obj.figure(1,1);
                obj.untitled_scattercorr(d{i}(:), e{i}(:), {'data'});
                xlabel(nameb{i});
                ylabel(name{i});
            end
            
        end
        function plot_corrintext(obj)
            int = obj.stats.stats.mean.dNs';
            ext = obj.stats.stats.mean.Eps';
            colors = {obj.colors.blue, obj.colors.red};
            obj.figure(1,2);
            for hi = 1:2
                obj.scattercorr(ext(:,hi),{int(:,hi)},{['h = ',num2str(hi*5-4)]},colors(hi));
                xlabel('internal noise');
                ylabel('external noise');
            end
        end
        function plot_recovery(obj, fakename, roname)
            obj.fake = importdata(fakename);
            m1 = obj.stats.stats.mean;
            m2 = obj.fake.stats.mean;
            if exist('roname') ~= 1
                idx = 1:size(m1.dNints,2);
            else
                idx = importdata(roname);
                idx = idx.ro;
            end
            names = {'A','b', '\sigma_{int}', '\sigma_{ext}'};
            color = 'k';
            obj.figure(4,2);
            obj.fontsize_face = obj.fontsize_face/2;
            obj.fontsize_leg = obj.fontsize_leg/2;
            for hi = 1:2
                obj.scatterdiag(m1.As(hi,idx), m2.As(hi,:), color, names{1},1/4);
                xlabel('Simulated A');
                ylabel('Fit A');
                %                 set(gca, 'XTickLabel', {[]});
            end
            for hi = 1:2
                obj.scatterdiag(m1.bs(hi,idx), m2.bs(hi,:), color, names{2},1/4);
                xlabel('Simulated b');
                ylabel('Fit b');
                %                 set(gca, 'XTickLabel', {[]});
            end
            for hi = 1:2
                obj.scatterdiag(m1.dNs(hi,idx), m2.dNs(hi,:), color, names{3},1/4);
                xlabel('Simulated \sigma^{int}');
                ylabel('Fit \sigma^{int}');
                %                 set(gca, 'XTickLabel', {[]});
            end
            for hi = 1:2
                obj.scatterdiag(m1.Eps(hi,idx), m2.Eps(hi,:), color, names{4},1/4);
                xlabel('Simulated \sigma^{ext}');
                ylabel('Fit \sigma^{ext}');
                %                 set(gca, 'XTickLabel', {[]});
            end
            obj.fontsize_face = obj.fontsize_face*2;
            obj.fontsize_leg = obj.fontsize_leg*2;
            %             obj.addABCs([],[],15);
            %             [~, pos] = obj.addABCs([],[],15, '        ');
            o1 = 0.02+[0.010, 0.010, 0.010, -0.006, 0.004, 0, -0.005, 0]';
            o2 = zeros(8,1) + 0.02;
            obj.addABCs([], [o1 o2], 15);
            obj.save('precover');
        end
        function plot_subjects(obj)
            stats = obj.stats;
            cilow = stats.stats.ci_low;
            cihigh = stats.stats.ci_high;
            avstat = stats.stats.mean;
            % stdstat = stats.stats.std;
            
            obj.figure(1,1);
            [av(1,:), err(1,:)] = obj.getmeanandse(avstat.As');
            stat(1) = obj.ttest(avstat.As');
            obj.lineplot(av, err, [1 2], {obj.colors.cactus});
            obj.sigstar_y({av(1,:)},[stat(1).p],0,1,[1 2], 0);
            obj.lim([0.5 2.5]);
            set(gca, 'XTick', 1:2, 'XTickLabel', [1 6]);
            xlabel('horizon');
            ylabel('information bonus');
            obj.legend({['information bonus, ',stat(1).str]}, 'northwest');
            
            obj.figure(1,1);
            [av(1,:), err(1,:)] = obj.getmeanandse(avstat.bs');
            stat(1) = obj.ttest(avstat.bs');
            obj.lineplot(av, err, [1 2], {obj.colors.sand});
            obj.sigstar_y({av(1,:)},[stat(1).p],0,1,[1 2], 0);
            obj.lim([0.5 2.5]);
            set(gca, 'XTick', 1:2, 'XTickLabel', [1 6]);
            xlabel('horizon');
            ylabel('spatial bias');
            obj.legend({['spatial bias, ',stat(1).str]}, 'northwest');
            
            obj.figure(1,1);
            [av(1,:), err(1,:)] = obj.getmeanandse(avstat.dNs');
            [av(2,:), err(2,:)] = obj.getmeanandse(avstat.Eps');
            stat(1) = obj.ttest(avstat.dNs');
            stat(2) = obj.ttest(avstat.Eps');
            
            obj.lineplot(av, err, [1 2], {obj.colors.mesa,obj.colors.river});
            obj.sigstar_y({av(1,:)},[stat(1).p],0,1,[1 2], 0);
            obj.sigstar_y({av(2,:)},[stat(2).p],0,1,[1 2], 0);
            obj.lim([0.5 2.5], [0 12]);
            set(gca, 'XTick', 1:2, 'XTickLabel', [1 6]);
            xlabel('horizon');
            ylabel('decision noise');
            obj.legend({['internal, ',stat(1).str], ['external, ', stat(2).str]}, 'northwest');
            if obj.issave
                obj.save('bayes_noise_s');
            end
        end
        function stat = plot_hyperpriors(obj, mxlims, mxticks)
            sp = obj.samples;
            for hi = 1:2
                d{1,hi} = reshape(sp.b_n(:,:,hi),1,[]);
                d{2,hi} = reshape(sp.A_n(:,:,hi),1,[]);
                d{4,hi} = reshape(sp.Noise(:,:,hi),1,[]);
                d{3,hi} = reshape(sp.Ep(:,:,hi),1,[]);
            end
            d2{1} = reshape(sp.dB,1,[]);
            d2{2} = reshape(sp.dA,1,[]);
            d2{4} = reshape(sp.dNint,1,[]);
            d2{3} = reshape(sp.dNext,1,[]);
            stat.ps(1) = mean(d2{4} <= 0);
            stat.ps(2) = mean(d2{3} <= 0);
            stat.m(1) = mean(d2{4});
            stat.m(2) = mean(d2{3});
            nsamples = size(sp.dA);
            names = {'Spatial bias - b','Information bonus - A',...
                'External noise - \sigma_{ext}','Internal noise - \sigma_{int}'};
            %             obj.figure(1,1);
            %             stepsize = 0.2;
            %             xbins = [-4:stepsize:16];
            %             mylim = 0.6;
            %             cylim = 0;
            %             color = obj.colors.red;
            %             for i = length(d2):-1:1
            %                 hold on;
            %                 td = d2{i};
            %                 tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
            %                 p05 = sum(cumsum(tl)* stepsize <= 0.05);
            %                 pp(i) = sum(tl(xbins(1:end-1) <= 0.05)* stepsize);
            %                 obj.shade(xbins([1:p05, p05:-1:1]), [tl([1:p05])+cylim repmat(cylim, 1, p05)], color);
            %                 plot(xbins, tl + cylim, 'blue', 'LineWidth', obj.linewidth);
            %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
            %                 cylim = cylim + mylim;
            %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
            %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/2, sprintf('p = %g',pp(i)));
            %             end
            %             cylim = cylim + 0.2;
            %             grid on;
            %             grid minor;
            %             obj.lim([min(xbins) max(xbins)],[0 cylim]);
            %             err = 0.00001;
            %             set(gca, 'YTick', 0:(mylim/3):(cylim), 'YTickLabel', [repmat([0:(mylim/3):(mylim-err)],1,length(d2)), mylim]);
            %             hold on;
            %             plot([0 0],[0 cylim], '--r','LineWidth', obj.linewidth/2);
            %             xlabel('parameters (point)');
            %             ylabel('density of posterior distribution');
            %
            %             obj.figure(1,1);
            %             stepsize = 0.2;
            %             xbins = [-8:stepsize:14];
            %             mylim = 1;
            %             cylim = 0;
            %             color = {obj.colors.blue, obj.colors.red};
            %             for i = length(d2):-1:1
            %                 hold on;
            %                 for hi = 1:2
            %                 td = d{i,hi};
            %                 tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
            %                 pp(i) = sum(tl(xbins(1:end-1) < 0)* stepsize);
            %                 pl(hi) = plot(xbins, tl + cylim, 'Color',color{hi}, 'LineWidth', obj.linewidth);
            %                 end
            %                 cylim = cylim + mylim;
            %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
            %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
            %             end
            %             obj.leglist = [pl];
            %             cgap = 0.6;
            %             cylim = cylim;
            %             grid on;
            %             grid minor;
            %             obj.lim([min(xbins) max(xbins)],[0 cylim+cgap]);
            %             err = 0.00001;
            %             set(gca, 'YTick', 0:(mylim/5):(cylim), 'YTickLabel', [repmat([0:(mylim/5):(mylim-err)],1,length(d2)-1), 0:(mylim/5):(mylim+cgap)]);
            %             hold on;
            %             plot([0 0],[0 cylim], '--r','LineWidth', obj.linewidth/2);
            %             obj.legend({'h = 1','h = 6'},'northwest');
            %             xlabel('noise standard deviation [points]');
            %             ylabel('posterior density');
            
            obj.figure(2,2,[],[0.15, 0.1, 0.1, 0.05]);
            stepsize = 0.02;
            mylim = 1.3;
            cylim = 0;
            color = {obj.colors.blue, obj.colors.red};
            for i = [4 3]
                xbins = [-10:stepsize:30];
                obj.new;
                hold on;
                for hi = 1:2
                    td = d{i,hi};
                    tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
                    pp(i) = sum(tl(xbins(1:end-1) < 0)* stepsize);
                    pl(hi) = plot(xbins, tl, 'Color',color{hi}, 'LineWidth', obj.linewidth/2);
                end
                cylim = mylim;
                %                 cylim = cylim + mylim;
                %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
                %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
                obj.leglist = [pl];
                cgap = 0.6;
                %             grid on;
                %             grid minor;
                obj.lim([mxlims(1:2)],[0 cylim]);
                err = 0.00001;
                set(gca, 'XTick', mxticks(1):mxticks(2):mxticks(3));
                
                set(gca, 'YTick', 0:0.2:(cylim));%, 'YTickLabel', [repmat([0:(mylim/5):(mylim-err)],1,length(d2)-1), 0:(mylim/5):(mylim+cgap)]);
                hold on;
                plot([0 0],[0 cylim], '--k','LineWidth', obj.linewidth/2);
                set(gca, 'tickdir', 'out');
                obj.legend({'h = 1','h = 6'},'northeast');
                %                 xlabel('noise standard deviation [points]');
                ylabel('posterior density');
                if i == 3
                    xlabel('noise standard deviation [points]');
                else
                    set(gca,'xticklabel',{[]})
                    
                end
                obj.title(names{i});
                hold off;
                
                obj.new;
                hold on;
                td = d2{i};
                tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
                p05 = sum(cumsum(tl)* stepsize <= 0.05);
                pp(i) = sum(tl(xbins(1:end-1) <= 0.05)* stepsize);
                %                 obj.shade(xbins([1:p05, p05:-1:1]), [tl([1:p05])+cylim repmat(cylim, 1, p05)], color);
                plot(xbins, tl, 'blue', 'LineWidth', obj.linewidth/2);
                %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
                %                 cylim = cylim + mylim;
                %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
                %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/2, sprintf('p = %g',pp(i)));
                %                 cylim = cylim + 0.2;
                %                 grid on;
                %                 grid minor;
                obj.lim([mxlims(3:4)],[0 cylim]);
                err = 0.00001;
                set(gca, 'YTick', 0:0.2:(cylim));%, 'YTickLabel', [repmat([0:(mylim/3):(mylim-err)],1,length(d2)), mylim]);
                set(gca, 'XTick', mxticks(4):mxticks(5):mxticks(6));
                set(gca, 'tickdir', 'out');
                hold on;
                plot([0 0],[0 cylim], '--k','LineWidth', obj.linewidth/2);
                obj.title(names{i});
                obj.legend({'change'},'northeast');
                
                if i == 3
                    xlabel('noise standard deviation [points]')
                else
                    set(gca,'xticklabel',{[]})
                    
                end
            end
            %             obj.addABCs;
            obj.addABCs([],[0.021,0],[],['ABCD']);
            obj.save('hyperprior');
        end
        function plot_subjectsnbyage(obj, agebin)
            if ~exist('agebin')
                agebin = [0, 13, 18, 25, 40, 70, 100];
            end
            stats = obj.stats;
            fnms = fieldnames(stats);
            cilow = cellfun(@(x)stats.(x).ci_low, fnms);
            cihigh = cellfun(@(x)stats.(x).ci_high, fnms);
            avstat = cellfun(@(x)stats.(x).mean, fnms);
            stdstat = cellfun(@(x)stats.(x).std, fnms);
            idxn = obj.idxn;
            
            gp = obj.temp_gp;
            for fi = 1:length(fnms)
                cnt = 0;
                legs = {};
                for ci = 1:length(idxn)
                    for hi = 1:2
                        cnt = cnt + 1;
                        IB{cnt} = avstat(fi).IB(idxn{ci},hi);
                        N{cnt} = avstat(fi).N(idxn{ci},hi);
                        SB{cnt} = avstat(fi).SB(idxn{ci},hi);
                        ages{cnt} = gp.demo_age(idxn{ci},:);
                        legs{cnt} = strcat(obj.idxnlabel{ci}, ', h = ', num2str(hi*5-4));
                    end
                end
                obj.figure(1,3);
                obj.now_color = {obj.colors.lightred, obj.colors.AZred, ...
                    obj.colors.lightblue, obj.colors.AZblue};
                obj.lineplot_bin(IB, ages, agebin);
                obj.title(fnms{fi});
                obj.temp_legloc = 'NorthWest';
                obj.legend(legs);
                obj.label('age','information bonus');
                obj.now_color = {obj.colors.lightred, obj.colors.AZred, ...
                    obj.colors.lightblue, obj.colors.AZblue};
                obj.lineplot_bin(N, ages, agebin);
                obj.temp_legloc = 'NorthWest';
                obj.legend(legs);
                obj.label('age','decision noise');
                obj.now_color = {obj.colors.lightred, obj.colors.AZred, ...
                    obj.colors.lightblue, obj.colors.AZblue};
                obj.lineplot_bin(SB, ages, agebin);
                obj.temp_legloc = 'NorthWest';
                obj.legend(legs);
                obj.label('age','spatial bias');
            end
            obj.save('bayesstatnbyage');
            
        end
%         function plot_corrbehavior(obj)
%             int = obj.stats.stats.mean.dNs';
%             ext = obj.stats.stats.mean.Eps';
%             lm13 = obj.temp_gp.p_lm13;
%             lm22 = obj.temp_gp.p_lm22;
%             da13 = obj.temp_gp.p_da13;
%             da22 = obj.temp_gp.p_da22;
%             d{1} = lm13; name{1} = 'p(low mean, [1 3])';
%             d{2} = lm22; name{2} = 'p(low mean, [2 2])';
%             d{3} = da13; name{3} = 'p(inconsistent, [1 3])';
%             d{4} = da22; name{4} = 'p(inconsistent, [2 2])';
%             colors = {};
%             for hi = 1:2
%                 for i = 1:length(d)
%                     obj.figure(1,1);
%                     obj.scattercorr(d{i}(:,hi), {int(:,hi), ext(:,hi)}, {'internal', 'external'},...
%                         {obj.colors.mesa,obj.colors.river});
%                     xlabel('decision noise');
%                     ylabel(name{i});
%                 end
%             end
%         end
%         function plot_corrintext(obj)
%             int = obj.stats.stats.mean.dNs';
%             ext = obj.stats.stats.mean.Eps';
%             colors = {obj.colors.blue, obj.colors.red};
%             obj.figure(1,2);
%             for hi = 1:2
%                 obj.scattercorr(ext(:,hi),{int(:,hi)},{['h = ',num2str(hi*5-4)]},colors(hi));
%                 xlabel('internal noise');
%                 ylabel('external noise');
%             end
%         end
%         function plot_recovery(obj, fakename, roname)
%             obj.fake = importdata(fakename);
%             m1 = obj.stats.stats.mean;
%             m2 = obj.fake.stats.mean;
%             if exist('roname') ~= 1
%                 idx = 1:size(m1.dNints,2);
%             else
%                 idx = importdata(roname);
%                 idx = idx.ro;
%             end
%             names = {'A','b', '\sigma_{int}', '\sigma_{ext}'};
%             color = 'k';
%             obj.figure(4,2);
%             obj.fontsize_face = obj.fontsize_face/2;
%             obj.fontsize_leg = obj.fontsize_leg/2;
%             for hi = 1:2
%                 obj.scatterdiag(m1.As(hi,idx), m2.As(hi,:), color, names{1},1/4);
%                 xlabel('Simulated A');
%                 ylabel('Fit A');
%                 %                 set(gca, 'XTickLabel', {[]});
%             end
%             for hi = 1:2
%                 obj.scatterdiag(m1.bs(hi,idx), m2.bs(hi,:), color, names{2},1/4);
%                 xlabel('Simulated b');
%                 ylabel('Fit b');
%                 %                 set(gca, 'XTickLabel', {[]});
%             end
%             for hi = 1:2
%                 obj.scatterdiag(m1.dNs(hi,idx), m2.dNs(hi,:), color, names{3},1/4);
%                 xlabel('Simulated \sigma^{int}');
%                 ylabel('Fit \sigma^{int}');
%                 %                 set(gca, 'XTickLabel', {[]});
%             end
%             for hi = 1:2
%                 obj.scatterdiag(m1.Eps(hi,idx), m2.Eps(hi,:), color, names{4},1/4);
%                 xlabel('Simulated \sigma^{ext}');
%                 ylabel('Fit \sigma^{ext}');
%                 %                 set(gca, 'XTickLabel', {[]});
%             end
%             obj.fontsize_face = obj.fontsize_face*2;
%             obj.fontsize_leg = obj.fontsize_leg*2;
%             %             obj.addABCs([],[],15);
%             %             [~, pos] = obj.addABCs([],[],15, '        ');
%             o1 = 0.02+[0.010, 0.010, 0.010, -0.006, 0.004, 0, -0.005, 0]';
%             o2 = zeros(8,1) + 0.02;
%             obj.addABCs([], [o1 o2], 15);
%             obj.save('precover');
%         end
        function stat = plot_hyperpriors_2noise(obj, mxlims, mxticks)
            sp = obj.samples;
            for hi = 1:2
                d{1,hi} = reshape(sp.b_n(:,:,hi),1,[]);
                d{2,hi} = reshape(sp.A_n(:,:,hi),1,[]);
                d{4,hi} = reshape(sp.Noise(:,:,hi),1,[]);
                d{3,hi} = reshape(sp.Ep(:,:,hi),1,[]);
            end
            d2{1} = reshape(sp.dB,1,[]);
            d2{2} = reshape(sp.dA,1,[]);
            d2{4} = reshape(sp.dNint,1,[]);
            d2{3} = reshape(sp.dNext,1,[]);
            stat.ps(1) = mean(d2{4} <= 0);
            stat.ps(2) = mean(d2{3} <= 0);
            stat.m(1) = mean(d2{4});
            stat.m(2) = mean(d2{3});
            nsamples = size(sp.dA);
            names = {'Spatial bias - b','Information bonus - A',...
                'External noise - \sigma_{ext}','Internal noise - \sigma_{int}'};
            %             obj.figure(1,1);
            %             stepsize = 0.2;
            %             xbins = [-4:stepsize:16];
            %             mylim = 0.6;
            %             cylim = 0;
            %             color = obj.colors.red;
            %             for i = length(d2):-1:1
            %                 hold on;
            %                 td = d2{i};
            %                 tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
            %                 p05 = sum(cumsum(tl)* stepsize <= 0.05);
            %                 pp(i) = sum(tl(xbins(1:end-1) <= 0.05)* stepsize);
            %                 obj.shade(xbins([1:p05, p05:-1:1]), [tl([1:p05])+cylim repmat(cylim, 1, p05)], color);
            %                 plot(xbins, tl + cylim, 'blue', 'LineWidth', obj.linewidth);
            %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
            %                 cylim = cylim + mylim;
            %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
            %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/2, sprintf('p = %g',pp(i)));
            %             end
            %             cylim = cylim + 0.2;
            %             grid on;
            %             grid minor;
            %             obj.lim([min(xbins) max(xbins)],[0 cylim]);
            %             err = 0.00001;
            %             set(gca, 'YTick', 0:(mylim/3):(cylim), 'YTickLabel', [repmat([0:(mylim/3):(mylim-err)],1,length(d2)), mylim]);
            %             hold on;
            %             plot([0 0],[0 cylim], '--r','LineWidth', obj.linewidth/2);
            %             xlabel('parameters (point)');
            %             ylabel('density of posterior distribution');
            %
            %             obj.figure(1,1);
            %             stepsize = 0.2;
            %             xbins = [-8:stepsize:14];
            %             mylim = 1;
            %             cylim = 0;
            %             color = {obj.colors.blue, obj.colors.red};
            %             for i = length(d2):-1:1
            %                 hold on;
            %                 for hi = 1:2
            %                 td = d{i,hi};
            %                 tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
            %                 pp(i) = sum(tl(xbins(1:end-1) < 0)* stepsize);
            %                 pl(hi) = plot(xbins, tl + cylim, 'Color',color{hi}, 'LineWidth', obj.linewidth);
            %                 end
            %                 cylim = cylim + mylim;
            %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
            %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
            %             end
            %             obj.leglist = [pl];
            %             cgap = 0.6;
            %             cylim = cylim;
            %             grid on;
            %             grid minor;
            %             obj.lim([min(xbins) max(xbins)],[0 cylim+cgap]);
            %             err = 0.00001;
            %             set(gca, 'YTick', 0:(mylim/5):(cylim), 'YTickLabel', [repmat([0:(mylim/5):(mylim-err)],1,length(d2)-1), 0:(mylim/5):(mylim+cgap)]);
            %             hold on;
            %             plot([0 0],[0 cylim], '--r','LineWidth', obj.linewidth/2);
            %             obj.legend({'h = 1','h = 6'},'northwest');
            %             xlabel('noise standard deviation [points]');
            %             ylabel('posterior density');
            
            obj.figure(2,2,1,[],[0.15, 0.1, 0.1, 0.05]);
            obj.temp_fontsize_leg = 20;
            stepsize = 0.02;
            mylim = 1.3;
            cylim = 0;
            color = {obj.colors.AZblue, obj.colors.AZred};
            for i = [4 3]
                xbins = [-10:stepsize:30];
                obj.new;
                hold on;
                for hi = 1:2
                    td = d{i,hi};
                    tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
                    pp(i) = sum(tl(xbins(1:end-1) < 0)* stepsize);
                    pl(hi) = plot(xbins, tl, 'Color',color{hi}, 'LineWidth', obj.linewidth/2);
                end
                cylim = mylim;
                %                 cylim = cylim + mylim;
                %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
                %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
                obj.leglist = [pl];
                cgap = 0.6;
                %             grid on;
                %             grid minor;
                obj.lim([mxlims(1:2)],[0 cylim]);
                err = 0.00001;
                set(gca, 'XTick', mxticks(1):mxticks(2):mxticks(3));
                
                set(gca, 'YTick', 0:0.2:(cylim));%, 'YTickLabel', [repmat([0:(mylim/5):(mylim-err)],1,length(d2)-1), 0:(mylim/5):(mylim+cgap)]);
                hold on;
                plot([0 0],[0 cylim], '--k','LineWidth', obj.linewidth/2);
                set(gca, 'tickdir', 'out');
                obj.temp_legloc = 'northeast';
                obj.legend({'h = 1','h = 6'});
                %                 xlabel('noise standard deviation [points]');
                ylabel('posterior density');
                if i == 3
                    xlabel('noise standard deviation [points]');
                else
                    set(gca,'xticklabel',{[]})
                    
                end
                obj.title(names{i});
                hold off;
                
                obj.new;
                hold on;
                td = d2{i};
                tl = hist(td, xbins)/(nsamples(1)*nsamples(2)*stepsize);
                p05 = sum(cumsum(tl)* stepsize <= 0.05);
                pp(i) = sum(tl(xbins(1:end-1) <= 0.05)* stepsize);
                %                 obj.shade(xbins([1:p05, p05:-1:1]), [tl([1:p05])+cylim repmat(cylim, 1, p05)], color);
                obj.leglist = plot(xbins, tl, 'blue', 'LineWidth', obj.linewidth/2);
                %                 plot(xbins, repmat(cylim,1,length(xbins)), 'k-', 'LineWidth', obj.linewidth/2);
                %                 cylim = cylim + mylim;
                %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/4, names{i});
                %                 obj.text(xbins(round(0.65 * length(xbins))),cylim - mylim/2, sprintf('p = %g',pp(i)));
                %                 cylim = cylim + 0.2;
                %                 grid on;
                %                 grid minor;
                obj.lim([mxlims(3:4)],[0 cylim]);
                err = 0.00001;
                set(gca, 'YTick', 0:0.2:(cylim));%, 'YTickLabel', [repmat([0:(mylim/3):(mylim-err)],1,length(d2)), mylim]);
                set(gca, 'XTick', mxticks(4):mxticks(5):mxticks(6));
                set(gca, 'tickdir', 'out');
                hold on;
                plot([0 0],[0 cylim], '--k','LineWidth', obj.linewidth/2);
                obj.title(names{i});
                obj.temp_legloc = 'northeast';
                obj.legend({'change'});
                
                if i == 3
                    xlabel('noise standard deviation [points]')
                else
                    set(gca,'xticklabel',{[]})
                    
                end
            end
            %             obj.addABCs;
            obj.BobaddABCs([],[0.021,0],[],['ABCD']);
            obj.save('hyperprior');
        end
        
    end
end