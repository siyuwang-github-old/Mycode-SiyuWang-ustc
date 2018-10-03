classdef analysis_eye < handle
    properties
        projectname
        datasets
        behavior
        basic
        path
        ind
        eye
        ERP
        noise
    end
    methods
        function obj = analysis_eye(datasets, basic, path, projectname)
            obj.datasets = datasets;
            obj.path = path;
            obj.basic = basic;
            obj.projectname = projectname;
        end
        function load_behavior(obj, databehavior, basicbehavior)
            obj.behavior.data = databehavior;
            obj.behavior.basic = basicbehavior;
            basicbe = basicbehavior.sublist;
            basic = obj.basic.sublist;
            if size(basic,1) ~= 1
                basic = basic';
            end
            if size(basicbe,1) ~= 1
                basicbe = basicbe';
            end
            te = basic' == basicbe;
            ind.eye = sum(te,2)';
            ind.behavior = sum(te,1);
            obj.ind = ind;
            obj.basic.n_fulldata = sum(ind.eye);
        end
        function process(obj)
%             obj.process_ERP_ind;
            obj.get_ind_ERP_behavior;
            obj.process_ERP;
        end
        function process_ERP(obj)
            obj.ERP = [];
            obj.noise = [];
            indeyen = obj.ind.neyeERP;
            indben = obj.ind.nbehaviorERP;
            ns = length(indeyen);
            eye = obj.eye;
            for si = 1:ns
                subeye = indeyen(si);
                subbe = indben(si);
                d = obj.behavior.data{subbe};
                inds.dap = d.agree == 1;
                inds.dan = d.agree == 0;
                fnms_task = fieldnames(inds);
                for ej = 1:length(fnms_task)
                    fname_task = fnms_task{ej};
                    teind = inds.(fname_task);
                    try
                        fnms = fieldnames(eye{subeye}.ERP);
                        if si == 1
                            for fi = 1:length(fnms)
                                fname = fnms{fi};
                                obj.ERP.(fname_task).pd.(fname) = [];
                                obj.noise.(fname_task).pd.(fname) = [];
                                obj.ERP.(fname_task).px.(fname) = [];
                                obj.noise.(fname_task).px.(fname) = [];
                                obj.ERP.(fname_task).py.(fname) = [];
                                obj.noise.(fname_task).py.(fname) = [];
                                obj.ERP.(fname_task).tm.(fname) = [];
                                obj.noise.(fname_task).tm.(fname) = [];
                            end
                        end
                        for fi = 1:length(fnms)
                            fname = fnms{fi};
                            obj.ERP.(fname_task).pd.(fname)(si,:) = nanmean(eye{subeye}.ERP.(fname).pd(inds.(fname_task),:));
                            obj.noise.(fname_task).pd.(fname)(si,:) = nanstd(eye{subeye}.ERP.(fname).pd(inds.(fname_task),:));
                            obj.ERP.(fname_task).px.(fname)(si,:) = nanmean(eye{subeye}.ERP.(fname).px(inds.(fname_task),:));
                            obj.noise.(fname_task).px.(fname)(si,:) = nanstd(eye{subeye}.ERP.(fname).px(inds.(fname_task),:));
                            obj.ERP.(fname_task).py.(fname)(si,:) = nanmean(eye{subeye}.ERP.(fname).py(inds.(fname_task),:));
                            obj.noise.(fname_task).py.(fname)(si,:) = nanstd(eye{subeye}.ERP.(fname).py(inds.(fname_task),:));
                            obj.ERP.(fname_task).tm.(fname)(si,:) = nanmean(eye{subeye}.ERP.(fname).tm(inds.(fname_task),:));
                            obj.noise.(fname_task).tm.(fname)(si,:) = nanstd(eye{subeye}.ERP.(fname).tm(inds.(fname_task),:));
                        end
                    catch
                        for fi = 1:length(fnms)
                            fname = fnms{fi};
                            obj.ERP.(fname_task).pd.(fname)(si,:) = nan;
                            obj.noise.(fname_task).pd.(fname)(si,:) = nan;
                            obj.ERP.(fname_task).px.(fname)(si,:) = nan;
                            obj.noise.(fname_task).px.(fname)(si,:) = nan;
                            obj.ERP.(fname_task).py.(fname)(si,:) = nan;
                            obj.noise.(fname_task).py.(fname)(si,:) = nan;
                            obj.ERP.(fname_task).tm.(fname)(si,:) = nan;
                            obj.noise.(fname_task).tm.(fname)(si,:) = nan;
                        end
                    end
                end
            end
        end
        function get_ind_ERP_behavior(obj)
            basicbe = obj.behavior.basic.sublist;
            basic = obj.basic.sublist;
            if size(basic,1) ~= 1
                basic = basic';
            end
            if size(basicbe,1) ~= 1
                basicbe = basicbe';
            end
            indERP = obj.ind.ERP;
            if size(indERP,1) ~= 1
                indERP = indERP';
            end
            te = (basic.*indERP)' == basicbe;
            obj.ind.eyeERP = sum(te,2)';
            obj.ind.behaviorERP = sum(te,1);
            indne = 1:length(obj.ind.eyeERP);
            indnb = 1:length(obj.ind.behaviorERP);
            obj.ind.neyeERP = indne(obj.ind.eyeERP == 1);
            obj.ind.nbehaviorERP = indnb(obj.ind.behaviorERP == 1);
        end
        function process_ERP_ind(obj)
            datasets = obj.datasets;
            indERP = ones(length(obj.ind.eye),1);
            for sub = 1:length(indERP)
                try
                    disp(sprintf('Processing subject %d:', sub));
                    eye{sub} = analysis_eyetribe(datasets{sub}.data, datasets{sub}.message);
                    eye{sub}.get_epoch({'startgame','endgame'});
                    eye{sub}.get_ERPtimes('keypress',5,2,2);
                    eye{sub}.get_ERPtimes('rewardon',4,2,2);
                    eye{sub}.get_ERP;
                    eye{sub}.get_px;
                    eye{sub}.get_py;
                catch
                    indERP(sub) = 0;
                    disp('Failed to calculate somehow');
                end
            end
            obj.eye = eye;
            obj.ind.ERP = indERP;
        end
    end
end