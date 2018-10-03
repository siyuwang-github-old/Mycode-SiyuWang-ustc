classdef horizon < SiyuLatex
    properties
        data_gp
        temp_gp
        data
        temp_data
        n_exp
        exps
        idxn
        idxnlabel
        idxnlabelh
        acthres
    end
    methods
        function obj = horizon()
            obj.load_data_gp(fullfile('W:\LAB\DATAMAT','data_horizon_gpindmeasure.mat'));
            obj.exps = unique(obj.data_gp.info_exp);
            obj.n_exp = length(obj.exps);
            obj.acthres = 0;
        end
        function load_data(obj, filename)
            if ~exist('filename')
                filename = fullfile('W:\LAB\DATAMAT','data_horizon_compiled.mat');
            end
            obj.data = importdata(filename);
        end
        function load_data_gp(obj, filename)
            te = importdata(filename);
            obj.data_gp = te.gp;
            obj.temp_gp = obj.data_gp;
        end
        function setupgroup(obj, idx, ontemp)
            if exist('ontemp') && ontemp == 1
                gp = obj.temp_gp;
            else
                
                gp = obj.data_gp;
            end
            namefields = fieldnames(gp);
            tgp = [];
            for ni = 1:length(namefields)
                if any(strcmp({'rbin_kernel'}, namefields{ni}))
                    tgp.(namefields{ni}) = getfield(gp, namefields{ni});
                    continue;
                end
                if strcmp({'trialn'},namefields{ni})
                    for hi = 1:2
                        nfs = fieldnames(gp.trialn(hi));
                        ttgp = [];
                        for nii = 1:length(nfs)
                            te = getfield(gp.trialn(hi), nfs{nii});
                            te = te(idx,:);
                            ttgp = setfield(ttgp, nfs{nii}, te);
                        end
                        tgp.trialn(hi) = ttgp;
                    end
                    continue;
                end
                if strcmp({'rcurve'},namefields{ni})
                    onames = fieldnames(gp.rcurve);
                    for oi = 1:length(onames)
                        oname = onames{oi};
                        for hi = 1:2
                            for ni = 1:10
                                nfs = fieldnames(gp.rcurve.(oname)(hi,ni));
                                ttgp = [];
                                for nii = 1:length(nfs)
                                    try
                                        te = getfield(gp.rcurve.(oname)(hi,ni), nfs{nii});
                                        if ~isempty(te) %% skip empty entries
                                            te = te(idx,:);
                                        end
                                        ttgp = setfield(ttgp, nfs{nii}, te);
                                    catch
                                            
                                    end
                                end
                                tgp.rcurve.(oname)(hi,ni) = ttgp;
                            end
                        end
                    end
                    continue;
                end
                te = getfield(gp, namefields{ni});
                if size(te,1) == size(gp.info_exp,1)
                    te = te(idx,:);
                else
                    for ii = 1:length(te)
                        te{ii} = te{ii}(idx,:);
                    end
                end
                tgp = setfield(tgp, namefields{ni}, te);
            end
            obj.temp_gp = tgp;
            if ~isempty(obj.data)
                obj.temp_data = obj.data(idx);
            end
            obj.idxn = {};
            obj.idxnlabel = {};
        end
        function setupexps(obj, expnames, isactive, isage, issession, isdelaytime)
            gp = obj.data_gp;
            str = '';
            if ~exist('expnames') || isempty(expnames)
                idx = cellfun(@(x)true, gp.info_exp);
            else
                idx = cellfun(@(x)sum(strcmp(expnames, x)) == 1, gp.info_exp);
            end
            if ~exist('isdelaytime') || isempty(isdelaytime)
                idx_delaytime = arrayfun(@(x)true, gp.cond_delaytime_R2B);
            elseif isnan(isdelaytime)
                dt = floor(gp.cond_delaytime_R2B);
                idx_delaytime = arrayfun(@(x)SiyuTools.iif(isnan(x), true, x == 0), dt);
            else
                dt = floor(gp.cond_delaytime_R2B);
                idx_delaytime = arrayfun(@(x)SiyuTools.iif(isnan(x), false, x == 0), dt);
                
            end
            if exist('isactive') && ~isempty(isactive)
                if isactive == 1
                    idx_active = cellfun(@(x)strcmp('Active', x), gp.cond_exp);
                    str = [str '_a'];
                elseif isactive == 0
                    idx_active = cellfun(@(x)strcmp('Passive', x), gp.cond_exp);
                    str = [str '_p'];
                end
            else
                idx_active = cellfun(@(x)true, gp.cond_exp);
                str = [str '_ap'];
            end
            if ~exist('isage') || isempty(isage)
                idx_age = arrayfun(@(x)true, gp.demo_age);
            elseif isnan(isage)
                str = [str '_18na'];
                idx_age = arrayfun(@(x)SiyuTools.iif(isnan(x), true, x >= 18), gp.demo_age);
            elseif isage == 1
                str = [str '_18'];
                idx_age = arrayfun(@(x)SiyuTools.iif(isnan(x), false, x >= 18), gp.demo_age);
            end
            if ~exist('issession') || isempty(issession)
                idx_session = arrayfun(@(x)true, gp.info_session);
                str = [str '_smix'];
            elseif isnan(issession)
                str = [str '_s1na'];
                idx_session = arrayfun(@(x)SiyuTools.iif(isnan(x), true, x == 1), gp.info_session);
            elseif issession == 1
                str = [str '_s1'];
                idx_session = arrayfun(@(x)SiyuTools.iif(isnan(x), false, x == 1), gp.info_session);
            end
            idx_ac = gp.trialn(2).ac(:,10) > obj.acthres;
            idx_input = idx & idx_active & idx_age & idx_session & idx_delaytime & idx_ac;
            obj.setupgroup(idx_input);
            obj.savesuffix = str;
        end
        function setupexpwithin(obj, expname, isactive, isage, idx_special)
            gp = obj.data_gp;
            str = '';
            if ~exist('expname') || isempty(expname)
                error('expname is missing, please input which experiment to import');
            else
                idx = cellfun(@(x)sum(strcmp(expname, x)) == 1, gp.info_exp);
            end
            if exist('isactive') && ~isempty(isactive) && ~isnan(isactive)
                if isactive == 1
                    str = [str '_a'];
                    idx_active = cellfun(@(x)strcmp('Active', x), gp.cond_exp);
                elseif isactive == 0
                    str = [str '_p'];
                    idx_active = cellfun(@(x)strcmp('Passive', x), gp.cond_exp);
                end
            else
                  str = [str '_ap'];
                  idx_active = cellfun(@(x)true, gp.cond_exp);
            end
            if ~exist('isage') || isempty(isage)
                idx_age = arrayfun(@(x)true, gp.demo_age);
            elseif isnan(isage)
                str = [str '_18na'];
                idx_age = arrayfun(@(x)SiyuTools.iif(isnan(x), true, x >= 18), gp.demo_age);
            elseif isage == 1
                str = [str '_18'];
                if strcmp(expname, '16F019')
                    warning('age for 16F019 is hard coded');
                    idx_age = 0 == ismember(gp.subjectID,[122 183 186 166]);
                    str = [str 'hand'];
                else
                    idx_age = arrayfun(@(x)SiyuTools.iif(isnan(x), false, x >= 18), gp.demo_age);
                end
            end
            tt = [idx*1000+ gp.subjectID];
            idx_both = arrayfun(@(x)sum(tt == x) == 2, tt);
            idx_ac = arrayfun(@(x)obj.iif(isnan(x),1,min(gp.trialn(2).ac(tt == x,10))> obj.acthres), tt,'UniformOutput',false);
            idx_ac = [idx_ac{:}]';
            if exist('idx_special')
                idx_input = idx & idx_active & idx_age & idx_both & idx_special ;
            else
                idx_input = idx & idx_active & idx_age & idx_both ;
            end   
            idx_input = idx_input & idx_ac;
            obj.setupgroup(idx_input);
            obj.savesuffix = str;
        end
        function setcompareidx(obj, fnames, fvalues, labels, isIDmatch, ffuncs, sconnect)
            if ~iscell(fvalues)
                fvalues = {fvalues};
            end
%             if ~iscell(fvalues{1})
%                 fvalues = {fvalues};
%             end
            if ~iscell(fnames)
                fnames = {fnames};
            end
            if length(fnames) ~= length(fvalues)
                error('fname and fvalue length mismatch');
            end
            if ~iscell(labels{1})
                labels = {labels};
            end
            idx = 0;
            fullidx = 0;
            lb = {''};
            maxflen = max(cellfun(@(x)length(x), fvalues));
            for fi = 1:length(fnames)
                if fi == 1
                    sc = '';
                elseif ~exist('sconnect')
                    sc = ', ';
                else
                    sc = sconnect;
                end
                fvalue = fvalues{fi};
                fname = fnames{fi};
                label = labels{fi};
                if exist('ffuncs')
                    ffunc = ffuncs{fi};
                else
                    ffunc = [];
                end
                if isempty(ffunc) 
                    ffunc = @(x)x;
                end
                %                 id = [];
                if iscell(fvalue) && ischar(fvalue{1})
                    id{fi} = cellfun(@(x)obj.getcolumn(find(strcmp(fvalue,ffunc(x))),1),obj.temp_gp.(fname));
                    id{fi}(isnan(id{fi})) = nanmax(id{fi}) + 1;
                elseif isnumeric(fvalue)
                    if iscell(obj.temp_gp.(fname))
                        id{fi} = cellfun(@(x)obj.getcolumn(find(ismember(fvalue,ffunc(x))),1), obj.temp_gp.(fname));
                    else
                        id{fi} = arrayfun(@(x)obj.getcolumn(find(ismember(fvalue,ffunc(x))),1), obj.temp_gp.(fname));
                    end
                else
                    error('unrecognized fvalue format');
                end
                label = label(1:length(unique(id{fi})));
                idx = idx * (maxflen +1) + id{fi};
                fullidx = arrayfun(@(x)x*(maxflen + 1) + (1:length(fvalue)), fullidx,'UniformOutput',false);
                fullidx = [fullidx{:}];
                lb = cellfun(@(x)cellfun(@(t)SiyuTools.iif(isempty([x]), [x t], [x sc t]), label, 'UniformOutput', false), lb, 'UniformOutput',false);
                lb = horzcat(lb{:});
            end
            fullidx = unique(fullidx);
            idxs = unique(idx);
            idxlb = arrayfun(@(x)sum(idxs == x)>0, fullidx);
            lb = lb(idxlb);
            obj.idxnlabel = lb;
            obj.idxnlabelh = {strcat(lb, ', h = 1'), strcat(lb, ', h = 6')};
            for ii = 1:length(idxs)
                idxn{ii} = find(idxs(ii) == idx);
            end
            if exist('isIDmatch') && ~isempty(isIDmatch) && isIDmatch == 1
                s1 = obj.temp_gp.subjectID(idxn{1});
                for si = 2:length(idxs)
                    s2 = obj.temp_gp.subjectID(idxn{si});
                    if length(s1) ~= length(s2) || length(s1) ~= length(unique([s1 s2])) ...
                            || length(s1) ~= length(unique(s1)) || length(s2) ~= length(unique(s2))
                        error('data not matching');
                    end
                    ids = obj.getpermidx(s2,s1);
                    idxn{si} = idxn{si}(ids);
                end
            end
            obj.idxn = idxn;
        end
        function savetoshare(obj, savename)
            gp = obj.temp_gp;
            d.subjectID = gp.subjectID;
            d.exp = gp.info_expsavename;
            d.isactive = cellfun(@(x)strcmp(x, 'Active'), gp.cond_exp);
            d.day = gp.day;
            d.time = gp.time;
            d.dcount = gp.dcount;
            d.modelfree.hi = gp.p_hi_13;
            d.modelfree.lm = gp.p_lm_22;
            d.hi1 = gp.trialn(1).p_hi(:,5);
            d.hi6 = gp.trialn(2).p_hi(:,5:10);
            d.lm1 = gp.trialn(1).p_lm(:,5);
            d.lm6 = gp.trialn(2).p_lm(:,5:10);
            d.ac1 = gp.trialn(1).ac(:,5);
            d.ac6 = gp.trialn(2).ac(:,5:10);
            d.RT1 = gp.trialn(1).RT(:,5);
            d.RT6 = gp.trialn(2).RT(:,5:10);
            save(savename, 'd');
        end
        function save4MCMC(obj, bayessavename, modelname)
            data = obj.temp_data;
            switch modelname
                case 'learningmodel'
                    bayesdata.nHorizon = 2;
                    bayesdata.nSubject = length(data);
                    nT = arrayfun(@(x)x.game.n_game, data);
                    LEN = max(nT);
                    bayesdata.nForcedTrials = 4;
                    bayesdata.nCond = length(obj.idxn);
                    for ci = 1:bayesdata.nCond;
                        for si = obj.idxn{ci}'
                            gd = data(si).game;
                            nT = gd.n_game;
                            bayesdata.Cond(si) = ci;
                            bayesdata.nTrial(si) = nT;
                            bayesdata.horizon(si,:) = obj.getcolumn(ceil(gd.cond_horizon'/5), LEN);
                            bayesdata.dInfo(si,:) = obj.getcolumn(gd.cond_info',LEN);
                            bayesdata.c5(si,:) = obj.getcolumn((gd.key(:,5)' == 1) + 0,LEN);
                            for ti = 1:bayesdata.nForcedTrials
                                bayesdata.c(si,:,ti) =  obj.getcolumn((gd.key(:,ti)' == 1) + 0,LEN);
                                bayesdata.r(si,:,ti) =  obj.getcolumn(gd.R_chosen(:,ti)',LEN);
                            end
                        end
                    end
            end
            save([bayessavename '_' modelname],'bayesdata','modelname');
        end
    end
end