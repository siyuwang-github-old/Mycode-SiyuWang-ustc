classdef analysis_bayesian < Siyuhandle
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
        function obj = analysis_bayesian(filename)
            filename = SiyuTools.iif(~isempty(strfind(filename, '.mat')),filename(1:end-4),[filename]);
            obj.filename = filename;
            dd = load(fullfile(obj.siyupathdatabayes, ...
                [filename '.mat']...
                ));
            obj.poolobj = [];
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
        function analysis(obj, istest)
            obj.openpool;
            modelname = obj.modelname;
            switch modelname
                case 'learningmodel'
                    obj.params = {'a0_p','b0_p','a_inf_p','b_inf_p',...
                        'mu0_mean_n','mu0_sigma_p',...
                        'hyperIB_mean_ncond','hyperIB_sigma_pcond',...
                        'hyperN_k_pcond','hyperN_lambda_pcond','hyperN_mean',...
                        'hyperSB_mean_ncond','hyperSB_sigma_pcond',...
                        'alpha_inf','mu0','alpha0','alpha_d','IB','SB','N',...
                        'IB_g','sigma_g','bias_g','mu1','mu2','dhyperIB','dhyperSB','dhyperN',...
                        'dN','dIB','dSB'};
                case '2noisemodel'
                    obj.params = {'kEp_p','lamdaEp_p','Ep','kNoise_p',...
                        'lamdaNoise_p','Noise','A_n','dA_p','b_n','db_p','dNs','Eps',...
                        'As','bs','P','dA','dB','dNint','dNext','dNints','dNexts'};
        case 'simplemodel'
          obj.params = {'hyperIB_mean_ncond','hyperIB_sigma_pcond',...
            'hyperN_k_pcond','hyperN_lambda_pcond','hyperN_mean',...
            'hyperSB_mean_ncond','hyperSB_sigma_pcond',...
            'IB','SB','N',...
            'IB_g','sigma_g','bias_g','dhyperIB','dhyperSB','dhyperN',...
            'dN','dIB','dSB'};
      end      
      if exist('istest') && istest == 1
        data = obj.data;
        fnms = fieldnames(data);
        fnms = fnms(cellfun(@(x)size(data.(x),1), fnms) == data.nSubject);
        for fi = 1:length(fnms)
          if length(data.(fnms{fi})) == 2
            data.(fnms{fi}) = data.(fnms{fi})(1:2,:);
          else
            data.(fnms{fi}) = data.(fnms{fi})(1:2,:,:);
          end
        end
        data.nSubject = 2;
        nburnin = 0;
        nsamples = 2;
      else
        data = obj.data;
        nburnin = obj.nburnin;
        nsamples = obj.nsamples;
      end
      obj.init0 = obj.get_bayesinit;
      modelfile = fullfile(obj.siyupathmodelbayes,...
        ['model_' obj.modelname '.txt']);
      disp(['Fitting now:' modelfile]);
      [samples, stats, structArray, tictoc] = obj.fit_matjags(modelfile, data, obj.init0, obj.nchains, nburnin, nsamples, obj.params);
      save(fullfile(obj.siyupathresultbayes, [obj.filename,'_bayesresult.mat']),'stats','tictoc','modelname');
      obj.closepool;
      obj.stats = stats;
      obj.samples = samples;
    end
    function savesamples(obj)
      samples = obj.samples;
      save(fullfile(obj.siyupathresultbayes, [obj.filename,'_bayessamples.mat']),'samples','-v7.3');
    end
    function init0 = get_bayesinit(obj)
      params = obj.params;
      nchains = obj.nchains;
      for i=1:nchains
        S = [];
        for j = 1:length(params)
          str = params{j};
          if ~isempty(strfind(str,'_pcond'))
            S.(str) = ones(obj.data.nCond,2);
          elseif ~isempty(strfind(str,'_ncond'))
            S.(str) = zeros(obj.data.nCond,2);
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
          parpool('IdleTimeout', Inf)
        end
        obj.poolobj = poolobj;
      end
    end
    function [samples, stats, structArray, tictoc] = fit_matjags(obj, filename, datastruct, init0, nchains, nburnin, nsamples, params)
      doparallel = 1; % use parallelization
      fprintf( 'Running JAGS...\n' );
      tic
      [samples, stats, structArray] = matjags( ...
        datastruct, ...           % Observed data
        filename, ...  % File that contains model definition
        init0, ...             % Initial values for latent variables
        'doparallel' , doparallel, ...   % Parallelization flag
        'nchains', nchains,...       % Number of MCMC chains
        'nburnin', nburnin,...       % Number of burnin steps
        'nsamples', nsamples, ...      % Number of samples to extract
        'thin', 1, ...           % Thinning parameter
        'monitorparams', params, ...   % List of latent variables to monitor
        'savejagsoutput' , 1 , ...     % Save command line output produced by JAGS?
        'verbosity' , 1 , ...        % 0=do not produce any output; 1=minimal text output; 2=maximum text output
        'cleanup' , 1 );          % clean up of temporary files?
      tictoc = toc
    end
    function closepool(obj)
      if ~isempty(obj.poolobj)
        delete(obj.poolobj);
      end
    end
  end
end