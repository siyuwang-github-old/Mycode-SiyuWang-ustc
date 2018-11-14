classdef cardstopping_modelfitting < cardstopping
    properties
        modelfit
        modelfittime
    end
    methods
        function obj = cardstopping_modelfitting()
            obj.modelfit = [];
        end
        function comparemodels(obj, mds, clrs, filename)
            for fi = obj.temp_datai
                obj.figure(1,1);
                if ~iscell(mds)
                    mds = {mds};
                end
                legs = [obj.str2gstr(mds),'data','optimal'];
                legs{1} = 'bernoulli';
%                 legs{1} = 'repeated bernoulli';
                mf = obj.modelfit(fi).xfit;
                ts = cellfun(@(x)mf.(x).t(:,end:-1:2), mds,'UniformOutput',false);
                obj.new;
                obj.holdon = true;
                obj.setcolor(clrs);
                obj.isplotstar = -1;
                obj.lineplot_raw(ts);
%                 obj.temp_fontsize_leg = obj.fontsize_leg{1,1};
                obj.temp_legloc = 'SouthWest';
                obj.setcolor('AZred');
                obj.lineplot(obj.avs{fi}.full.av.thres(end:-1:2),obj.avs{fi}.full.err.thres(end:-1:2));
                obj.setcolor('AZriver');
                obj.leglist(end+1) = plot(1:4,obj.opthrs(5:-1:2), '*','Color',obj.now_color{1},'LineWidth', obj.linewidth);
                obj.legend(legs);
                obj.lim([0.5 size(ts{1},2)+0.5]);
                obj.label('number of cards left', 'threshold');
                set(gca, 'XTick',1:size(ts{1},2),'XTickLabel',size(ts{1},2):-1:1);
                ns = cellfun(@(x)mf.(x).n(:,end:-1:2), mds,'UniformOutput',false);
                obj.save(['comparemodels_thres_' filename obj.savesuffixs{fi}]);
                obj.figure(1,1);
                obj.new;
%                 obj.setcolor('AZriver');
%                 obj.leglist = plot(1:4,obj.opthrs(5:-1:2), '*','LineWidth', obj.linewidth);
%                 legs = ['data',obj.str2gstr(mds)];
                obj.holdon = true;
                obj.setcolor(clrs);
                obj.lineplot_raw(ns);
                obj.temp_legloc = 'NorthWest';
                obj.setcolor('AZred');
                obj.lineplot(obj.avs{fi}.full.av.noise(end:-1:2),obj.avs{fi}.full.err.noise(end:-1:2));
                obj.lim([0.5 size(ts{1},2)+0.5]);
                obj.legend(legs(1:end-1));
                obj.label('number of cards left', 'variability');
                set(gca, 'XTick',1:size(ts{1},2),'XTickLabel',size(ts{1},2):-1:1);
                obj.save(['comparemodels_noise_' filename obj.savesuffixs{fi}]);
            end
        end
        function fitmodel(obj, modelname)
            modelfit = obj.modelfit;
            tic;
            for expi = obj.temp_datai
                xfit = [];
                p = [];
                data = obj.data{expi};
                for si = 1:length(data)
                    disp(sprintf('fit sub %d from exp %d', si, expi));
                    d = data(si);
                    g = d.task;
                    switch modelname
                        case 'horizon_threshold'
                            out = obj.model_horizonthreshold(g);
                        case 'constant_threshold'
                            out = obj.model_constantthreshold(g);
                        case 'rulebased_threshold'
                            out = obj.model_rulebasedthreshold(g);
                        case 'samplingbernoulli'
                            out = obj.model_samplingbernoulli(g);
                        case 'samplingbernoulli_n'
                            out = obj.model_samplingbernoulli2(g, obj.modelfit(obj.temp_datai).bestfit.samplingbernoulli(si,:));
                        case 'samplingaverage'
                            out = obj.model_horizonthreshold2(g, obj.modelfit(obj.temp_datai).bestfit.samplingbernoulli(si,:));    
                    end
                    p(si) = out.p;
                    xfit.t(si,:) = arrayfun(@(x)x.t, out.xfit);
                    xfit.n(si,:) = arrayfun(@(x)x.n, out.xfit);
                    if isfield(out, 'bestfit')
                        bestfit(si,:) = out.bestfit;
                    end
                end
                modelfit(expi).p.(modelname) = p;
                modelfit(expi).xfit.(modelname) = xfit;
                if exist('bestfit')
                    modelfit(expi).bestfit.(modelname) = bestfit;
                end
            end
            obj.modelfit = modelfit;
            obj.modelfittime.(modelname) = toc;
        end
        function out = model_rulebasedthreshold(obj, g)
            func = @(n)100*(1-1/n);
            nt = length(g.h);
            [thres] = arrayfun(@(x)func(x), g.n);
            c_pd = [g.v >= thres];
            out.xfit = obj.thresfits(g, c_pd);
            out.p = mean(c_pd == g.a);
        end
        function outp = func_samplingbernoulli(obj, v, hn, n)
            func = @(x,n)(x/100).^n;
            pqc = 1 - func(v, hn);
            try
                ps = arrayfun(@(x)obj.realnchoosek(n,x)*(pqc^(n-x))*((1-pqc)^x), 1:ceil(n/2));
            catch
                pause;
            end
            if mod(n,2) == 0
                ps(end) = ps(end)/2;
            end
            outp = sum(ps);
        end
        function outp = MLE_samplingbernoulli(obj, g4, a)
            func = @(v,hn,aa)obj.func_samplingbernoulli(v,hn,aa);            
            nt = length(g4.h);
            ps = arrayfun(@(x)func(g4.v(x), g4.n(x), a(g4.n(x))), 1:nt);
            p1 = log(ps(g4.a == 1));
            p2 = log(1-ps(g4.a == 0));
            outp = sum(p1(abs(p1) < inf)) + sum(p2(abs(p2) < inf));
        end
        function [out] = model_samplingbernoulli(obj, g)
            nt = length(g.h);
            X0 = [1 1 1 1 1]*3;
            LB = [0 0 0 0 0];
            UB = [100 100 100 100 100];
            funcfit = @(x)-obj.MLE_samplingbernoulli(g, x);
            try
                bestfit = fmincon(funcfit, X0, [],[],[],[],LB, UB);
            catch
                warning('no beta fit');
                bestfit = [1];
                pause;
            end
            out.bestfit = bestfit;
            fitn = bestfit;
            func = @(v,hn,n)obj.func_samplingbernoulli(v,hn,n);
            [thres] = arrayfun(@(t)obj.getsample(@(x)func(x, g.n(t),fitn(g.n(t))), [], 50), 1:nt)';
            c_pd = [g.v >= thres];
            out.xfit = obj.thresfits(g, c_pd);
            out.p = mean(c_pd == g.a);
        end
        
        function [out] = model_samplingbernoulli2(obj, g, nn)
            fitn = nn;
            nt = length(g.h);
            func = @(v,hn,n)obj.func_samplingbernoulli(v,hn,n);
            for i = 1:2
                [thres(:,i)] = arrayfun(@(t)obj.getsample(@(x)func(x, g.n(t),fitn(g.n(t))), [], 50), 1:nt)';
            end
            c_pd = [g.v >= mean(thres,2)];
            out.xfit = obj.thresfits(g, c_pd);
            out.p = mean(c_pd == g.a);
        end
        function [out] = model_horizonthreshold(obj, g)
            func = @(x,n)(x/100).^n;
            nt = length(g.h);
            [thres] = arrayfun(@(t)obj.getsample(@(x)func(x, g.n(t)), [], 50), 1:nt)';
            c_pd = [g.v >= thres];
            out.xfit = obj.thresfits(g, c_pd);
            out.p = mean(c_pd == g.a);
        end
        function [out] = model_horizonthreshold2(obj, g, nn)
            func = @(x,n)(x/100).^n;
            nt = length(g.h);
            for i = 1:round(max(nn))
                [thres(i,:)] = arrayfun(@(t)obj.getsample(@(x)func(x, g.n(t)), [], 50), 1:nt)';
            end
            c_pd = [g.v >= mean(thres,1)'];
            out.xfit = obj.thresfits(g, c_pd);
            out.p = mean(c_pd == g.a);
        end
        function [out] = model_constantthreshold(obj, g)
            func = @(x,n)(x/100).^n;
            idx = g.h == 5;
            rep = round(length(idx)/sum(idx));
            g.h = repmat(g.h(idx),rep,1);
            g.n = repmat(g.n(idx),rep,1);
            g.a = repmat(g.a(idx),rep,1);
            g.v = repmat(g.v(idx),rep,1);
            nt = length(g.h);
            [thres] = arrayfun(@(t)obj.getsample(@(x)func(x, g.h(t)), [], 50), 1:nt)';
            c_pd = [g.v >= thres];
            out.xfit = obj.thresfits(g, c_pd);
            out.p = mean(c_pd == g.a);
        end
        function plotdist(obj,n,m)
            func = @(x)(x/100).^n;
            func2 = @(x)n*(x/100).^(n-1)/100;
            thres = obj.getsample(@(x)func(x), m, 50);
            obj.figure(1,1,[],[],[0.2 0.2 0.05 0.05]);
%             [ht,x] = hist(thres,[0:0.5:100]);
            xs = [0:10:100];
            hold on;
            obj.now_color = {obj.colors.AZred};
            obj.lineplot(func2(xs),zeros(size(xs)),xs);
            obj.now_color = {obj.colors.AZblue};
            x = 81;%thres;
            x1 = ylim;
            obj.lineplot([x1],zeros(1,2),[x x]);
            for fi = 1:length(thres)
                obj.now_color = {obj.colors.AZsand};
                obj.lineplot([x1],zeros(1,2),[thres(fi) thres(fi)]);
            end
            set(gca,'XTick',0:20:100);
            obj.xlabel('card value');
            obj.ylabel('density');
            obj.save('dist_constant');
        end
        function [x,y] = getsample(obj, func, n, x0)
            if ~exist('func')
                func = @(x)obj.siyubound(x,0,1);
            end
            if ~exist('n') || isempty(n)
                n = 1;
            end
            y = rand(1,n);
            for yi = 1:length(y)
                funcmin = @(x)(y(yi) - func(x)).^2;
                x(yi) = fminsearch(funcmin, x0);
            end
        end
        
        function xfit = thresfits(obj, g, cnew)
            gns = unique(g.n);
            for ni = 1:length(gns)
                idx = g.n == gns(ni);
                xfit(ni) = obj.thresfitsimple(g.v(idx), cnew(idx));
            end
        end
    end
end