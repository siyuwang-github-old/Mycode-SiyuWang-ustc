classdef analysis_bayesian < handle
    properties
        data
        xfit
        nchains
        nburnin
        nsamples
        thin
        filename
        modelname
        params
        init0
        mainpath
        savepath
        poolobj
        stats
        samples
    end
    methods
        function obj = analysis_bayesian(filename, mainpath, savepath)
            dd = load(filename);
            obj.poolobj = [];
            [~, obj.filename] = fileparts(filename);
            obj.savepath = savepath;
            obj.mainpath = mainpath;
            obj.data = dd.bayesdata;
            obj.modelname = dd.modelname;
            obj.setup_chain;
        end
        function setup_chain(obj)
            obj.nchains = 4; % How Many Chains?
            obj.nburnin = 2000; % How Many Burn-in Samples?
            obj.nsamples = 4000; % How Many Recorded Samples?
            obj.thin = 1;
        end
        function analysis(obj)
            obj.openpool;
            switch obj.modelname
                case 'learningmodel'
                    obj.params = {'a0_p','b0_p','a_inf_p','b_inf_p',...
                        'mu0_mean_n','mu0_sigma_p','AA_mean_n22','AA_sigma_p22',...
                        'BB_k_p22','BB_lambda_p22','BB_mean','SB_mean_n22','SB_sigma_p22',...
                        'alpha_inf','mu0','alpha0','alpha_d','AA','SB','BB',...
                        'A','sigma_g','bias','mu1','mu2'};
            end
           
            obj.init0 = obj.get_bayesinit;
            modelfile = fullfile(fullfile(obj.mainpath,'Dropbox\Analysis\HORIZON\BAYESIAN\Models'),...
                ['model_' obj.modelname '.txt']);
            disp(['Fitting now:' modelfile]);
            [samples, stats, structArray, tictoc] = obj.fit_matjags(modelfile, obj.data, obj.init0, obj.nchains, obj.nburnin, obj.nsamples, obj.params);
            save(fullfile(obj.savepath, [obj.filename,'_bayesresult.mat']),'stats','tictoc','modelname');
            obj.closepool;
            obj.stats = stats;
            obj.samples = samples;
        end
        function savesamples(obj, savename)
            samples = obj.samples;
            save(fullfile(obj.savepath, [savename,'_samples.mat']),'samples','-v7.3');
        end
        function init0 = get_bayesinit(obj)
            params = obj.params;
            nchains = obj.nchains;
            for i=1:nchains
                S = [];
                for j = 1:length(params)
                    str = params{j};
                    if ~isempty(strfind(str,'_p22'))
                        S.(str) = ones(2,2);
                    elseif ~isempty(strfind(str,'_n22'))
                        S.(str) = zeros(2,2);
                    elseif ~isempty(strfind(str,'_p'))
                        S.(str) = ones(1,2);
                    elseif ~isempty(strfind(str,'_n'))
                        S.(str) = zeros(1,2);
                    end
                end
                init0(i) = S;
            end
        end
        function openpool(obj)
            if isempty(obj.poolobj)
                poolobj = gcp('nocreate'); % If no pool, do not create new one.
                if isempty(poolobj)
                    poolsize = 0;
                else
                    poolsize = poolobj.NumWorkers;
                end
                if poolsize == 0
                    parpool;
                end
                obj.poolobj = poolobj;
            end
        end
        function [samples, stats, structArray, tictoc] = fit_matjags(obj, filename, datastruct, init0, nchains, nburnin, nsamples, params)
            doparallel = 1; % use parallelization
            fprintf( 'Running JAGS...\n' );
            tic
            [samples, stats, structArray] = matjags( ...
                datastruct, ...                     % Observed data
                filename, ...    % File that contains model definition
                init0, ...                          % Initial values for latent variables
                'doparallel' , doparallel, ...      % Parallelization flag
                'nchains', nchains,...              % Number of MCMC chains
                'nburnin', nburnin,...              % Number of burnin steps
                'nsamples', nsamples, ...           % Number of samples to extract
                'thin', 1, ...                      % Thinning parameter
                'monitorparams', params, ...     % List of latent variables to monitor
                'savejagsoutput' , 1 , ...          % Save command line output produced by JAGS?
                'verbosity' , 1 , ...               % 0=do not produce any output; 1=minimal text output; 2=maximum text output
                'cleanup' , 1 );                    % clean up of temporary files?
            tictoc = toc
        end
        function closepool(obj)
            if ~isempty(obj.poolobj)
                delete(obj.poolobj);
            end
        end
    end
end