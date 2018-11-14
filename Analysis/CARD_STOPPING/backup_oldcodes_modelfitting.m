    function comparemodels(obj)
            obj.comparemodel_thresnoise;
            obj.comparemodels_p;
        end
      
        function comparemodels_p(obj)
            order = [1 2 3 4 5];
            for fi = 1:3
                mf = obj.modelfit(fi);
                mds = fieldnames(mf.p);
                te = cellfun(@(x)mf.p.(x)', mds,'UniformOutput',false);
                te = horzcat(te{:});
                ps{fi} = te(:,order);
            end
            mds = {'constant','horizon','horizon(beta)','bernoulli','bernoulli(beta)'};
            nm = length(mds);
            obj.figure(1,1,[],[],[0.3,0.15,0.1,0.1]);
            obj.setcolor({'AZred','AZblue','AZcactus'});
            obj.lineplot_raw(ps);
            obj.legend({'EXP 1','EXP 2','EXP 3'});
            obj.lim([0.5 nm + 0.5]);
            set(gca, 'XTick',1:nm, 'XTickLabel', obj.str2gstr(mds(order)));
            set(gca, 'XTickLabelRotation', -45);
            ylabel('model accuracy');
            obj.save(['comparemodels_p']);
        end
        function fitmodel_raw(obj)
            modelfit = obj.modelfit;
            tic;
            for expi = 1:3
                xfit = [];
                p = [];
                data = obj.data{expi};
                for si = 1:length(data)
                    d = data(si);
                    g = d.task;
%                     try
                    out = obj.model_rawthreshold(g);
%                     p(si) = out.p;
                    xfit.t(si,:) = arrayfun(@(x)x.t, out.xfit);
                    xfit.n(si,:) = arrayfun(@(x)x.n, out.xfit);
%                     catch
%                         error;
%                     end
                end
                modelfit(expi).xfit.data = xfit;
            end
            obj.modelfittime.raw = toc;
            obj.modelfit = modelfit;
        end
        function fitmodel_samplingbernoullibeta(obj)
            modelfit = obj.modelfit;
            tic;
            for expi = 1:3
                xfit = [];
                p = [];
                data = obj.data{expi};
                for si = 1:length(data)
                    disp(sprintf('fit exp %d sub %d...', expi, si));
                    d = data(si);
                    g = d.task;
%                     try
                    out = obj.model_samplingbernoullibeta(g);
                    p(si) = out.p;
                    xfit.t(si,:) = arrayfun(@(x)x.t, out.xfit);
                    xfit.n(si,:) = arrayfun(@(x)x.n, out.xfit);
                    bestfit(si,:) = out.bestfit;

%                     catch
%                         error;
%                     end
                end
                modelfit(expi).p.samplingbernoullibeta = p;
                modelfit(expi).xfit.samplingbernoullibeta = xfit;
                modelfit(expi).bestfit.samplingbernoullibeta = bestfit;
            end
            obj.modelfit = modelfit;
            obj.modelfittime.samplingbernoullibeta = toc;
        end
        function fitmodel_samplingbernoulli(obj)
            modelfit = obj.modelfit;
            tic;
            for expi = 3:3
                xfit = [];
                p = [];
                data = obj.data{expi};
                for si = 1:length(data)
                    d = data(si);
                    g = d.task;
%                     try
                    out = obj.model_samplingbernoulli(g,si);
                    p(si) = out.p;
                    xfit.t(si,:) = arrayfun(@(x)x.t, out.xfit);
                    xfit.n(si,:) = arrayfun(@(x)x.n, out.xfit);
                    bestfit(si,:) = out.bestfit;

%                     catch
%                         error;
%                     end
                end
                modelfit(expi).p.samplingbernoulli = p;
                modelfit(expi).xfit.samplingbernoulli = xfit;
                modelfit(expi).bestfit.samplingbernoulli = bestfit;
            end
            obj.modelfit = modelfit;
            obj.modelfittime.samplingbernoulli = toc;
        end
        function fitmodel_horizonthresholdbetaprior(obj)
            modelfit = obj.modelfit;
            tic;
            for expi = 1:3
                xfit = [];
                p = [];
                data = obj.data{expi};
                for si = 1:length(data)
                    d = data(si);
                    g = d.task;
%                     try
                    out = obj.model_horizonthresholdbetaprior(g);
                    p(si) = out.p;
                    xfit.t(si,:) = arrayfun(@(x)x.t, out.xfit);
                    xfit.n(si,:) = arrayfun(@(x)x.n, out.xfit);
                    bestfit(si,:) = out.bestfit;
%                     catch
%                         error;
%                     end
                end
                modelfit(expi).p.horizon_threshold_beta_prior = p;
                modelfit(expi).xfit.horizon_threshold_beta_prior = xfit;
                modelfit(expi).bestfit.horizon_threshold_beta_prior = bestfit;
            end
            obj.modelfit = modelfit;
            obj.modelfittime.horizonthresholdbetaprior = toc;
        end
        function fitmodel_horizonthreshold(obj)
            modelfit = obj.modelfit;
            tic;
            for expi = 1:3
                xfit = [];
                p = [];
                data = obj.data{expi};
                for si = 1:length(data)
                    d = data(si);
                    g = d.task;
%                     try
                    out = obj.model_horizonthreshold(g);
                    p(si) = out.p;
                    xfit.t(si,:) = arrayfun(@(x)x.t, out.xfit);
                    xfit.n(si,:) = arrayfun(@(x)x.n, out.xfit);
%                     catch
%                         error;
%                     end
                end
                modelfit(expi).p.horizon_threshold = p;
                modelfit(expi).xfit.horizon_threshold = xfit;
            end
            obj.modelfit = modelfit;
            obj.modelfittime.horizonthreshold = toc;
        end
        function [out] = model_rawthreshold(obj, g)
            func = @(x,n)(x/100).^n;
            g4 = obj.formatgame(g);
            nt = length(g4.h);
            out.xfit = obj.thresfits(g4, g4.a);
        end
        function [out] = model_constantthreshold(obj, g)
            func = @(x,n)(x/100).^n;
            g4 = obj.formatgame(g);
            nt = length(g4.h);
            [thres] = arrayfun(@(t)obj.getsample(@(x)func(x, g4.h(t)), [], 50), 1:nt)';
            c_pd = [g4.v >= thres];
            out.xfit = obj.thresfits(g4, c_pd);
            out.p = mean(c_pd == g4.a);
        end
        function [out] = model_horizonthreshold(obj, g)
            func = @(x,n)(x/100).^n;
            g4 = obj.formatgame(g);
            nt = length(g4.h);
            for ti = 1:10
            [thres(:,ti)] = arrayfun(@(t)obj.getsample(@(x)func(x, g4.n(t)), [], 50), 1:nt)';
            end
            c_pd = [g4.v >= mean(thres,2)];
            out.xfit = obj.thresfits(g4, c_pd);
            out.p = mean(c_pd == g4.a);
        end
        function outp = MLE_horizonthresholdbetaprior(obj, g4, a, b)
            func = @(x,n,a,b)(betacdf(x/100, a, b)).^n;
            nt = length(g4.h);
            ps = arrayfun(@(x)func(g4.v(x), g4.n(x), a, b), 1:nt);
            p1 = log(ps(g4.a == 1));
            p2 = log(1-ps(g4.a == 0));
            outp = sum(p1(abs(p1) < inf)) + sum(p2(abs(p2) < inf));
        end
        function [out] = model_horizonthresholdbetaprior(obj, g)
            g4 = obj.formatgame(g);
            nt = length(g4.h);
            X0 = [1 1];
            LB = [0 0];
            UB = [100 100];
            funcfit = @(x)-obj.MLE_horizonthresholdbetaprior(g4, x(1), x(2));
            try
                bestfit = fmincon(funcfit, X0, [],[],[],[],LB, UB);
            catch
                warning('no beta fit');
                bestfit = [1 1];
                pause;
            end
            fita = bestfit(1);
            fitb = bestfit(2);
            func = @(x,n,a,b)(betacdf(x/100, a, b)).^n;
            [thres] = arrayfun(@(t)obj.getsample(@(x)func(x, g4.n(t),fita, fitb), [], 50), 1:nt)';
            c_pd = [g4.v >= thres];
            out.xfit = obj.thresfits(g4, c_pd);
            out.p = mean(c_pd == g4.a);
            out.bestfit = bestfit;
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
        function [out] = model_samplingbernoulli(obj, g, subi)
            g4 = obj.formatgame(g);
            nt = length(g4.h);
            if ~isfield(obj.modelfit(3).bestfit, 'samplingbernoulli')
                X0 = [1 1 1 1 1 1 1 1 1 1];
                LB = [0 0 0 0 0 0 0 0 0 0];
                UB = [100 100 100 100 100 100 100 100 100 100];
                funcfit = @(x)-obj.MLE_samplingbernoulli(g4, x);
                try
                    bestfit = fmincon(funcfit, X0, [],[],[],[],LB, UB);
                catch
                    warning('no beta fit');
                    bestfit = [1];
                    pause;
                end
            else
                bestfit = obj.modelfit(3).bestfit.samplingbernoulli(subi,:);
            end
            out.bestfit = bestfit;
            fitn = repmat(10,1,10);%bestfit;
            func = @(v,hn,n)obj.func_samplingbernoulli(v,hn,n);
            [thres] = arrayfun(@(t)obj.getsample(@(x)func(x, g4.n(t),fitn(g4.n(t))), [], 50), 1:nt)';
            c_pd = [g4.v >= thres];
            out.xfit = obj.thresfits(g4, c_pd);
            out.p = mean(c_pd == g4.a);
        end
        
        function outp = func_samplingbernoullibeta(obj, v, hn, n,a,b)
            func = @(x,nn)(betacdf(x/100, a, b)).^nn;
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
        function outp = MLE_samplingbernoullibeta(obj, g4, n,a,b)
            func = @(v,hn)obj.func_samplingbernoullibeta(v,hn,n,a,b);            
            nt = length(g4.h);
            ps = arrayfun(@(x)func(g4.v(x), g4.n(x)), 1:nt);
            p1 = log(ps(g4.a == 1));
            p2 = log(1-ps(g4.a == 0));
            outp = sum(p1(abs(p1) < inf)) + sum(p2(abs(p2) < inf));
        end
        function [out] = model_samplingbernoullibeta(obj, g)
            g4 = obj.formatgame(g);
            nt = length(g4.h);
            X0 = [1 1 1];
            LB = [0 0 0];
            UB = [100 100 100];
            funcfit = @(x)-obj.MLE_samplingbernoullibeta(g4, x(1),x(2),x(3));
            try
                bestfit = fmincon(funcfit, X0, [],[],[],[],LB, UB);
            catch
                warning('no beta fit');
                bestfit = [1 1 1];
                pause;
            end
            fitn = bestfit(1);
            fita = bestfit(2);
            fitb = bestfit(3);
            func = @(v,hn,n,a,b)obj.func_samplingbernoullibeta(v,hn,n,a,b);
            [thres] = arrayfun(@(t)obj.getsample(@(x)func(x, g4.n(t),fitn,fita,fitb), [], 50), 1:nt)';
            c_pd = [g4.v >= thres];
            out.xfit = obj.thresfits(g4, c_pd);
            out.p = mean(c_pd == g4.a);
            out.bestfit = bestfit;
        end