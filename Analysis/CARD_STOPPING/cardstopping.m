classdef cardstopping < SiyuStatistics & SiyuPlots
    properties
        expi
        data
        opthrs
        tskpara
        idxselfreport
        xfit
        pfit
        pfit_sub
        isxfit
        im
        gp
        avs
        simucdf
        simucdfs
        simudata
        temp_simucdf
        temp_datai
        tempthrs
        horizons
        savesuffixs
        xbins_reward
        xbins_ntrial
        RT
        isoverwrite
        selfreport
        colorh
    end
    methods
        function obj = cardstopping()
            obj.isoverwrite = false;
            obj.isxfit = false;
            obj.tskpara.x1 = 100;
            obj.tskpara.x0 = 1;
            obj.tskpara.M = obj.tskpara.x1 - obj.tskpara.x0 + 1;
            obj.computeOptimalThreshold;
            obj.colorh = {obj.colors.AZred, obj.colors.AZred,obj.colors.AZsand,obj.colors.AZcactus,...
                obj.colors.AZriver, obj.colors.AZblue*1.5, ...
                obj.colors.AZblue*2, obj.colors.AZblue*3, [obj.colors.AZblue(1:2)*4,1],...
                [obj.colors.AZblue(1:2)*5,1]};
        end
        
        function computeOptimalThreshold(obj)
            x1 = obj.tskpara.x1;
            x0 = obj.tskpara.x0;
            M = obj.tskpara.M;
            opthrs(1) = 0;
            for n = 2:10
                opthrs(n) = ((1/(2*M))*(opthrs(n-1)-(x0-(1/2)))^2 + ((x1+x0)/2) - (1/8/M));
            end
            isplot = false;
            if isplot
                obj.figure; clf;
                plot(1:10,opthrs(end:-1:1), '*-','LineWidth', obj.linewidth);
                set(gca, 'XTick', 1:10, 'XTickLabels', 10:-1:1);
                xlabel('Number of cards left');
                ylabel('Optimal Threshold');
                set(gca, 'FontSize',obj.fontsize.face);
            end
            obj.opthrs = opthrs;
        end
        function loadall(obj, excludecriteria)
            obj.im = [];
            obj.gp = [];
            obj.avs = [];
            obj.data = [];
            obj.savesuffixs{1} = 'v1';
            obj.savesuffixs{2} = 'v2';
            obj.savesuffixs{3} = 'v3';
%             obj.selfreport{3} = obj.load(
            filename = 'W:\LAB\DATAMAT\CS_v1.mat';
            obj.data{1} = obj.load(filename, excludecriteria);
            filename = 'W:\LAB\DATAMAT\CS_v2_pilot.mat';
            obj.data{2} = obj.load(filename, excludecriteria);
            filename = 'W:\LAB\DATAMAT\CS_v3.mat';
            [obj.data{3} obj.idxselfreport{3}] = obj.load(filename, excludecriteria);
            
            obj.isxfit = false;
            disp('loaded');
        end
        function [dataraw idxselfreport] = load(obj, filename, excludecriteria)
            %             obj.data = obj.celltoarray(data);
            data = importdata(filename);
            data = obj.completedatasets(data);
            [dataraw idxselfreport] = obj.exclude_performance(data, excludecriteria, length(obj.data) + 1);
        end
        
        function [dataraw idxselfreport] = exclude_performance(obj, data, thres, suffixidx)
            if nargin < 3
                option = '';
            end
            ispostques = arrayfun(@(x)isfield(x,'postques'),data);
            percent_raw(ispostques == 0) = {'NaN'};
            td = data(ispostques == 1);
            isp = arrayfun(@(x)isfield(x.postques,'percent'),td);
            tp(isp == 0) = {'NaN'};
            tp(isp == 1) = arrayfun(@(x)x.postques.percent, td(isp == 1), 'UniformOutput', false);
            percent_raw(ispostques == 1) = tp;
            percentsign = strfind(percent_raw, '%');
            percentsign = cellfun(@(x)min(x), percentsign,'UniformOutput', false);
            idx_percentsign = cellfun(@(x)~isempty(x), percentsign);
            percent_raw(idx_percentsign) = cellfun(@(x,y)x(1:y-1), percent_raw(idx_percentsign), percentsign(idx_percentsign), 'UniformOutput', false);
            percent_raw(cellfun(@(x)length(x) == 0, percent_raw)) = {'NaN'};
            idx_space = cellfun(@(x)~isempty(strfind(x, ' ')), percent_raw);
            percent_raw(idx_space) = {'NaN'};
            percent = cellfun(@(x)str2num(x), percent_raw);
            reward_time = arrayfun(@(x)obj.getcolumn(x.taskraw.reward_s,200)', data, 'UniformOutput', false)';
            reward_time = horzcat(reward_time{:});
            idxselfreport = percent >= 80;
            %             reward_mean = nanmean(reward_time)';
            %             obj.figure(1,1);obj.new;clf;
            %             percent4plt = percent;
            %             percent4plt(isnan(percent)) = -10;
            %             scatter(percent4plt, reward_mean, obj.dotsize, 'filled');
            %             xlim([-20 100]);
            %             ylim([0 100]);
            %             xticks([-10, 0:20:100]);
            %             xticklabels({'NaN', '0', '20', '40', '60', '80', '100'});
            %             set(gca, 'FontSize', obj.fontsize_face);
            %             xlims = xlim;
            %             ylims = ylim;
            %             line([xlims(1) xlims(2)], [thres, thres], 'Color', 'k','LineWidth', obj.linewidth,'LineStyle','--');
            %             xlabel('Post-experiment self-report percentage of engagement')
            %             ylabel('Average reward')
            dataraw = data;
            %             obj.save(sprintf('Exclusion_%d%s', round(thres), obj.savesuffixs{suffixidx}));
        end
        function data = completedatasets(obj, data)
            idx = arrayfun(@(x)length(x.taskraw.nstop_s) == length(x.taskraw.horizon), data);
            data = data(idx);
        end
        
        function re = thresfitsimple(obj, rewards, c)
            func = @(x)-obj.getpallsimple(x(1), x(2), ...
                rewards, c);
            X0 = [50 10];
            LB = [0 0.01];
            UB = [100 100];
            te = fmincon(func, X0, [],[],[],[],LB, UB);
            re.t = te(1);
            re.n = te(2);
        end
        function out = getpallsimple(obj, thres, noise, rewards, c)
            p(c == 1) = log(1./(1+exp(-(rewards(c == 1) - thres)/noise)));
            p(c == 0) = log(1 - 1./(1+exp(-(rewards(c == 0) - thres)/noise)));
            out = sum(p);
        end
        function default_analysis(obj, option)
            for di = obj.temp_datai
                data = obj.data{di};
                task = arrayfun(@(x)x.task, data);
                horizons = unique(vertcat(task.h));
                obj.horizons{di} = horizons;
                xbins_ntrial = [0.5:9.5; 1.5:10.5]';
                xbins_reward = [-5:10:95; 5:10:105]';
                obj.xbins_reward = xbins_reward;
                obj.xbins_ntrial = xbins_ntrial;
                im = [];
                gp = [];
                
                avs = [];
                if ~isfield(im,option) || obj.isoverwrite
                    for si = 1:length(data)
                        game = task(si);
                        for ni = 1:max(horizons)
                            idx_n = game.n == ni;
                            if strcmp(option, 'h5')
                                idx_n = idx_n & game.h == 5;
                            end
                            y = game.a(idx_n);
                            x = game.v(idx_n);
                            te = obj.thresfitsimple(x, y);
                            im.(option)(si).thres(ni) = te.t;
                            im.(option)(si).noise(ni) = te.n;
                            te = obj.bin_average(y,x,xbins_reward);
                            im.(option)(si).choicecurve(ni,:) = te.y;
                        end
                    end
                    
                end
                obj.im{di} = im;
                te = arrayfun(@(x)x.thres, im.(option), 'UniformOutput',false);
                gp.(option).thres = vertcat(te{:});
                te = arrayfun(@(x)x.noise, im.(option), 'UniformOutput',false);
                gp.(option).noise = vertcat(te{:});
                for ni = 1:max(horizons)
                    te = arrayfun(@(x)x.choicecurve(ni,:), im.(option), 'UniformOutput', false);
                    gp.(option).choicecurve{ni} = vertcat(te{:});
                end
                obj.gp{di} = gp;
                avs = [];
                for ni = 1:max(horizons)
                    [avs.(option).av.choicecurve(ni,:), avs.(option).err.choicecurve(ni,:)] = obj.getmeanandse(gp.(option).choicecurve{ni});
                end
                [avs.(option).av.thres, avs.(option).err.thres] = obj.getmeanandse(gp.(option).thres);
                [avs.(option).av.noise, avs.(option).err.noise] = obj.getmeanandse(gp.(option).noise);
                obj.avs{di} = avs;
            end
        end
        function plot_fitvsreport(obj)
            sr = xlsread('W:\LAB\DATA\Cardstopping___AU_016_Cardstopping18F\selfreportthres.xlsx');
            sub = [obj.data{3}.subID];
            fit = [obj.gp{3}.full.thres];
            fit = fit(:,2:5);
            idx = obj.getpermidx(sub,sr(:,1));
            idn = ~isnan(idx);
            idx = idx(idn);
            z = [sub(idx)',fit(idx,:),sr(idn,2)];
                obj.figure(1,1,[],[],[0.2,0.15,0.05,0.05]);
             clrs = {obj.colors.AZred,obj.colors.AZsand,obj.colors.AZcactus,obj.colors.AZriver}
            for i = 2:5
                obj.holdon = true;
                obj.old_scatterdiag(z(:,6), z(:,i),clrs{i-1},2);
                obj.xlabel('self report threshold');
                obj.ylabel('fitted threshold');
%                 obj.title(['Horizon = ' num2str(i-1)]);
            end
        end
        function plot_mles(obj, option)
            obj.figure; clf;
            legs = {'Optimal'};
            obj.leglist = [];
            hold on;
            avs = obj.avs{obj.temp_datai};
            clrs = {obj.colors.AZriver, obj.colors.AZred};
            obj.leglist = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);
            av{1} = avs.(option).av.thres(2:5);
            err{1} = avs.(option).err.thres(2:5);
            hi = max(obj.horizons{obj.temp_datai});
            obj.now_color = clrs(2);
            obj.lineplot(av{1},err{1},[hi-1:-1:1]);
            legs{end+1} = ['data'];
            obj.legend(legs);
            set(gca, 'XTick', 1:4, 'XTickLabels', 4:-1:1);
            xlabel('number of cards left');
            ylabel('threshold');
            set(gca, 'FontSize',obj.fontsize_face);
            obj.lim([0.5 4.5],[50 80]);
            obj.save(['mle_thres_v3']);
            
            obj.figure; clf;
            %             legs = {'optimal'};
            obj.leglist = [];
            hold on;
            clrs = { obj.colors.AZcactus, obj.colors.AZred};
            %             obj.leglist = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);
            av{2} = avs.(option).av.noise(2:5);
            err{2} = avs.(option).err.noise(2:5);
            obj.now_color = clrs(2);
            obj.lineplot(av{2},err{2},...
                [hi-1:-1:1]);
            legs = {['data']};
            obj.legend(legs);
            set(gca, 'XTick', 1:4, 'XTickLabels', 4:-1:1);
            xlabel('number of cards left');
            ylabel('variability');
            set(gca, 'FontSize',obj.fontsize_face);
            obj.lim([0.5 4.5],[5 11]);
            obj.yautotick(0,2);
            obj.save(['mle_noise_v3']);
        end
        function plot_choicecurves_bystep(obj, option,step)
            for expi = obj.temp_datai
                horizons = obj.horizons{expi};
                avs = obj.avs{expi}.(option);
                obj.figure;
                hh = length(horizons):-1:length(horizons)+1-step;
                thorizons = horizons(hh);
                obj.now_color = obj.colorh(thorizons);
                legs = arrayfun(@(x)['Horizon = ',num2str(x)],thorizons-1,'UniformOutput',false);
                av = avs.av.choicecurve;
                err = avs.err.choicecurve;
                obj.new;
                obj.leglist = [];
                obj.lineplot(av(thorizons,:),err(thorizons,:),mean(obj.xbins_reward'));
                ylim([0 1]);
                obj.temp_legloc = 'Northwest';
                obj.legend(legs);
                xlabel('reward');
                ylabel('p(stop)');
                set(gca, 'FontSize',obj.fontsize_face);
                set(gca, 'XTick', [0:20:100]);
                obj.save(['Choicecurve_',option,'_bystep_step', num2str(step), '_', obj.savesuffixs{expi}]);
            end
        end
    end
end