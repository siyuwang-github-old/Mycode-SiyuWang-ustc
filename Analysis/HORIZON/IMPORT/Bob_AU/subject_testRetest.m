classdef subject_testRetest < handle
    
    properties
        
        datadir
        dataname
        savename
        subjectID
        sn
        
        mac_address
        sessionNum
        
        
        answers
        
        game
        performance
        fCorrect
        
    end
    
    methods
        
        function obj = subject_testRetest(datadir, dataname)
            
            obj.dataname = dataname;
            obj.datadir = datadir;
            
        end
        
        function load(obj)
            
            load(fullfile(obj.datadir, obj.dataname));
            obj.savename = savename;
            obj.subjectID = str2num(subjectID);
            obj.sessionNum = sessionNum;
            obj.mac_address = mac_address;
            obj.game = game;
            
            obj.answers = ans;
            
        end
        
        function augmentDataStructure_OLD(obj)
            
            gm = obj.game;
            
            
            for i = 1:length(gm)
                gm(i).m1 = nanmean(gm(i).r(gm(i).forced == 1));
                gm(i).m2 = nanmean(gm(i).r(gm(i).forced == 2));
                gm(i).dm = gm(i).m2-gm(i).m1;
                gm(i).c5 = gm(i).a(5);
                gm(i).RT5 = gm(i).RT(5);
                switch sum(gm(i).forced == 1)
                    case 1
                        gm(i).uc = 3;
                        gm(i).uc_id = 1;
                    case 2
                        gm(i).uc = 2;
                        gm(i).uc_id = nan;
                    case 3
                        gm(i).uc = 1;
                        gm(i).uc_id = 2;
                end
                
                %gm(i).s
                
                % choose 2 is +1, choose 1 is -1
                gm(i).s4 = 2*(gm(i).nforced-1.5);
                gm(i).r4 = gm(i).r(1:4);
                
                % global max reward and identity
                [gm(i).r4_max, idx] = max(gm(i).r4);
                gm(i).s4_max = gm(i).s4(idx);
                
                % local max
                gm(i).r4_plus_max = max(gm(i).r4(gm(i).s4==1));
                gm(i).s4_plus_max = +1;
                gm(i).r4_minus_max = max(gm(i).r4(gm(i).s4==-1));
                gm(i).s4_minus_max = -1;
                
                % local end
                dum = gm(i).r4(gm(i).s4==1);
                gm(i).r4_plus_end = dum(end);
                gm(i).s4_plus_end = +1;
                
                dum = gm(i).r4(gm(i).s4==-1);
                gm(i).r4_minus_end = dum(end);
                gm(i).s4_minus_end = -1;
                
                gm(i).max_reward = max(gm(i).rewards(:,5:end));
                gm(i).min_reward = min(gm(i).rewards(:,5:end));
                gm(i).mean_reward = mean(gm(i).rewards(:,5:end));
                
                gm(i).act_reward = gm(i).r(5:end);
                gm(i).correct_arm = (gm(i).mean(2)>gm(i).mean(1))+1;
                gm(i).correct = gm(i).a(5:end) == gm(i).correct_arm;
                
                % trend and variance and local end
                if sum(gm(i).s4==1)>1
                    x = [1:4];
                    y = gm(i).r4;
                    xx = x(gm(i).s4==1);
                    yy = y(gm(i).s4==1);
                    p = polyfit(xx, yy, 1);
                    gm(i).trend2 = p(1);
                    gm(i).std2 = std(yy);
                    gm(i).end2 = yy(end);
                else
                    gm(i).trend2 = 0;
                    gm(i).std2 = 0;
                    y = gm(i).r4;
                    yy = y(gm(i).s4==1);
                    gm(i).end2 = yy(end);
                end
                
                if sum(gm(i).s4==-1)>1
                    x = [1:4];
                    y = gm(i).r4;
                    xx = x(gm(i).s4==-1);
                    yy = y(gm(i).s4==-1);
                    p = polyfit(xx, yy, 1);
                    gm(i).trend1 = p(1);
                    gm(i).std1 = std(yy);
                    gm(i).end1 = yy(end);
                else
                    gm(i).trend1 = 0;
                    gm(i).std1 = 0;
                    y = gm(i).r4;
                    yy = y(gm(i).s4==-1);
                    gm(i).end1 = yy(end);
                end
                gm(i).RT4 = gm(i).RT(4);% reaction time on last forced trial
                gm(i).RT1 = gm(i).RT(1);% reaction time on last forced trial
                gm(i).RTforced = mean(gm(i).RT(1:4));
                
                gm(i).block = ceil(i/length(gm)*4);
                
                % observed means at all time points
                a = gm(i).a;
                r = gm(i).r;
                
                r2 = r .* (a==2);
                r1 = r .* (a==1);
                
                n2 = cumsum(a==2);
                n1 = cumsum(a==1);
                
                
                gm(i).mu2 = cumsum(r2)./n2;
                gm(i).mu1 = cumsum(r1)./n1;
                gm(i).n2 = n2;
                gm(i).n1 = n1;
                
                if i < length(gm)
                    if isempty(gm(i+1).a)
                        gm = gm(1:i);
                        break;
                    end
                end
            end
            
            % z-score RTs relative to ALL RTs
            RT = [gm.RT];
            mRT = nanmean(RT);
            sRT = nanstd(RT);
            for i = 1:length(gm)
                gm(i).RT5_z = (gm(i).RT5-mRT) / sRT;
                gm(i).RT4_z = (gm(i).RT4-mRT) / sRT;
                gm(i).RT_z = (gm(i).RT-mRT) / sRT;
            end
            
            maxR = sum([gm.max_reward]);
            minR = sum([gm.min_reward]);
            meanR = sum([gm.mean_reward]);
            totalR = sum([gm.act_reward]);
            
            fCorrect = mean([gm.correct]);
            
            obj.performance = (totalR-meanR)/(maxR-meanR);
            obj.fCorrect = fCorrect;
            obj.game = gm;
            
        end
        
        function augmentDataStructure(obj)
            
            gm = obj.game;
            
            
            for i = 1:length(gm)
                gm(i).gNum = i;
                gm(i).m1 = nanmean(gm(i).r(gm(i).forced == 1));
                gm(i).m2 = nanmean(gm(i).r(gm(i).forced == 2));
                gm(i).dm = gm(i).m2-gm(i).m1;
                gm(i).c5 = gm(i).a(5);
                gm(i).RT5 = gm(i).RT(5);
                gm(i).to5 = gm(i).to(5);
                
                gm(i).a_1to5 = gm(i).a(1:5);
                gm(i).to_1to5 = gm(i).to(1:5);
                gm(i).tp_1to5 = gm(i).tp(1:5);
                gm(i).ts_1to5 = gm(i).ts(1:5);
                
                switch sum(gm(i).forced == 1)
                    case 1
                        gm(i).uc = 3;
                        gm(i).uc_id = 1;
                    case 2
                        gm(i).uc = 2;
                        gm(i).uc_id = nan;
                    case 3
                        gm(i).uc = 1;
                        gm(i).uc_id = 2;
                end
                
                %gm(i).s
                
                % choose 2 is +1, choose 1 is -1
                gm(i).s4 = 2*(gm(i).nforced-1.5);
                gm(i).r4 = gm(i).r(1:4);
                
                % global max reward and identity
                [gm(i).r4_max, idx] = max(gm(i).r4);
                gm(i).s4_max = gm(i).s4(idx);
                
                % local max
                gm(i).r4_plus_max = max(gm(i).r4(gm(i).s4==1));
                gm(i).s4_plus_max = +1;
                gm(i).r4_minus_max = max(gm(i).r4(gm(i).s4==-1));
                gm(i).s4_minus_max = -1;
                
                % local end
                dum = gm(i).r4(gm(i).s4==1);
                gm(i).r4_plus_end = dum(end);
                gm(i).s4_plus_end = +1;
                
                dum = gm(i).r4(gm(i).s4==-1);
                gm(i).r4_minus_end = dum(end);
                gm(i).s4_minus_end = -1;
                
                gm(i).max_reward = max(gm(i).rewards(:,5:end));
                gm(i).min_reward = min(gm(i).rewards(:,5:end));
                gm(i).mean_reward = mean(gm(i).rewards(:,5:end));
                
                gm(i).act_reward = gm(i).r(5:end);
                gm(i).correct_arm = (gm(i).mean(2)>gm(i).mean(1))+1;
                gm(i).correct = gm(i).a(5:end) == gm(i).correct_arm;
                
                % trend and variance and local end
                if sum(gm(i).s4==1)>1
                    x = [1:4];
                    y = gm(i).r4;
                    xx = x(gm(i).s4==1);
                    yy = y(gm(i).s4==1);
                    p = polyfit(xx, yy, 1);
                    gm(i).trend2 = p(1);
                    gm(i).std2 = std(yy);
                    gm(i).end2 = yy(end);
                else
                    gm(i).trend2 = 0;
                    gm(i).std2 = 0;
                    y = gm(i).r4;
                    yy = y(gm(i).s4==1);
                    gm(i).end2 = yy(end);
                end
                
                if sum(gm(i).s4==-1)>1
                    x = [1:4];
                    y = gm(i).r4;
                    xx = x(gm(i).s4==-1);
                    yy = y(gm(i).s4==-1);
                    p = polyfit(xx, yy, 1);
                    gm(i).trend1 = p(1);
                    gm(i).std1 = std(yy);
                    gm(i).end1 = yy(end);
                else
                    gm(i).trend1 = 0;
                    gm(i).std1 = 0;
                    y = gm(i).r4;
                    yy = y(gm(i).s4==-1);
                    gm(i).end1 = yy(end);
                end
                gm(i).RT4 = gm(i).RT(4);% reaction time on last forced trial
                gm(i).RT1 = gm(i).RT(1);% reaction time on last forced trial
                gm(i).RTforced = mean(gm(i).RT(1:4));
                
                gm(i).block = ceil(i/length(gm)*4);
                
                % observed means at all time points
                a = gm(i).a;
                r = gm(i).r;
                
                r2 = r .* (a==2);
                r1 = r .* (a==1);
                
                n2 = cumsum(a==2);
                n1 = cumsum(a==1);
                
                
                gm(i).mu2 = cumsum(r2)./n2;
                gm(i).mu1 = cumsum(r1)./n1;
                gm(i).n2 = n2;
                gm(i).n1 = n1;
                
                if i < length(gm)
                    if isempty(gm(i+1).a)
                        gm = gm(1:i);
                        break;
                    end
                end
            end
            
            % z-score RTs relative to ALL RTs
            RT = [gm.RT];
            mRT = nanmean(RT);
            sRT = nanstd(RT);
            for i = 1:length(gm)
                gm(i).RT5_z = (gm(i).RT5-mRT) / sRT;
                gm(i).RT_z = (gm(i).RT-mRT) / sRT;
            end
            
            maxR = sum([gm.max_reward]);
            minR = sum([gm.min_reward]);
            meanR = sum([gm.mean_reward]);
            totalR = sum([gm.act_reward]);
            
            fCorrect = mean([gm.correct]);
            
            obj.performance = (totalR-meanR)/(maxR-meanR);
            obj.fCorrect = fCorrect;
            
            
            % compute agreement index
            
            gID = [gm.gID];
            [s, idx] = sort(gID);
            gs = gm(idx);
            
            gNum = [gs.gNum];
            [~,idx2] = sort(gNum);
            
            
            ag = [gs(1:2:end).c5] == [gs(2:2:end).c5];
            clear dum
            dum(1:2:length(ag)*2) = ag;
            dum(2:2:length(ag)*2) = ag;
            
            % flag whether this is first presentation of this pair
            firstRep(1:2:length(gs)) = 1;
            firstRep(2:2:length(gs)) = 0;
            
            %ag = [ag ag];
            %ag = ag(idx2);
            ag = dum(idx2);
            for i = 1:length(gm)
                gm(i).AG = ag(i);
                gm(i).firstRep = firstRep(i);
            end
    
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            obj.game = gm;
            
            
            
        end
        
        
    end
    
    
end