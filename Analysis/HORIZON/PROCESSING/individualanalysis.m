function data = individualanalysis(data)
    disp('Indivisual measures');
    addpath('./IndividualExps');
% datadir = 'W:\LAB\DATAMAT';
% data = importdata(fullfile(datadir, 'data_2_preprocessed.mat'));
    for si = 1:length(data)
        disp(sprintf('...processing subject %d of %d', si, length(data)));
        d = data(si);
        game = d.game;
        horizons = [5 10];
        c = game.key;
        c5 = c(:,5);
        c_lm = game.c_lm;
        c_hi = game.c_hi;
        c_ac = game.c_ac;
        c_r = game.c_r;
        c_sw = game.c_sw;
        c_da = 1 - game.repeat_agree;
      
        trialn = [];
    %     if ~isempty(game.RT)
    %         RT = game.RT;
    %     else
        RT = game.RT_recorded;
        if isempty(RT)
            RT = game.delaytime_B2K;
        end
    %     end
        for hi = 1:2
            idx_h = game.cond_horizon == horizons(hi);
            % direct and random exploration
            idx_22 = game.cond_info == 0;
            idx_13 = game.cond_info ~= 0;
            data(si).p_hi_13(hi) = mean(c_hi(idx_h & idx_13,5));
            data(si).p_lm_13(hi) = nanmean(c_lm(idx_h & idx_13,5));
            data(si).p_lm_22(hi) = nanmean(c_lm(idx_h & idx_22,5));
            data(si).p_r_13(hi) = mean(c_r(idx_h & idx_13,5));
            data(si).p_r_22(hi) = mean(c_r(idx_h & idx_22,5));
            data(si).p_sw(hi) = nanmean(c_sw(idx_h,5));
            data(si).p_da13(hi) = nanmean(c_da(idx_h & idx_13,1));
            data(si).p_da22(hi) = nanmean(c_da(idx_h & idx_22,1));
            % pattern
            for pi = 1:7
                idx_p = game.pattern == pi;
                data(si).p_hip(hi,pi) = nanmean(c_hi(idx_h & idx_p,5));
                data(si).p_lmp(hi,pi) = nanmean(c_lm(idx_h & idx_p,5));
                data(si).p_rp(hi,pi) = nanmean(c_r(idx_h & idx_p,5));
                data(si).p_swp(hi,pi) = nanmean(c_sw(idx_h & idx_p,5));
                data(si).RTp(hi,pi) = nanmean(RT(idx_h & idx_p,5));
                data(si).acp(hi,pi) = nanmean(c_ac(idx_h & idx_p,5));
                data(si).p_da(hi,pi) = nanmean(c_da(idx_h & idx_p,1));
            end
            
            % trial number vs xxx
            trialn.RT(hi,:) = mean(RT(idx_h,:));
            trialn.p_lm(hi,:) = nanmean(c_lm(idx_h,:));
            trialn.p_hi(hi,:) = nanmean(c_hi(idx_h,:));
            trialn.ac(hi,:) = nanmean(c_ac(idx_h,:));
            trialn.p_r(hi,:) = nanmean(c_r(idx_h,:));
            trialn.p_sw(hi,:) = nanmean(c_sw(idx_h,:));
            
            % rcurves
            rbinx_kernel = [-30 -20 -15 -10 -6 -3 0 3 6 10 15 20 30];
            kernel = @(x)normpdf(x,0,1.5);
            R4names = {'empirical','chosen','info'};
            for ri = 1:length(R4names)
                R4name = ['dfR4_' R4names{ri}];
                R4 = game.(R4name);
                for bi = 1:length(rbinx_kernel)
                    rb = rbinx_kernel(bi);
                    dfRk = arrayfun(@(x)kernel(x - rb), R4);
                    dfRkh = dfRk(idx_h);
                    rcurve.(R4name){hi}.p_hi(bi,:) = SiyuTools.weightaverage(c_hi(idx_h,:), dfRkh);
                    rcurve.(R4name){hi}.p_lm(bi,:) = SiyuTools.weightaverage(c_lm(idx_h,:), dfRkh);
                    rcurve.(R4name){hi}.p_r(bi,:) = SiyuTools.weightaverage(c_r(idx_h,:), dfRkh);
                    rcurve.(R4name){hi}.ac(bi,:) = SiyuTools.weightaverage(c_ac(idx_h,:), dfRkh);
                    rcurve.(R4name){hi}.RT(bi,:) = SiyuTools.weightaverage(RT(idx_h,:), dfRkh);
                    rcurve.(R4name){hi}.p_sw(bi,:) = SiyuTools.weightaverage(c_sw(idx_h,:), dfRkh);
                    rcurve.(R4name){hi}.p_da(bi,:) = SiyuTools.weightaverage(c_da(idx_h,:), dfRkh);
                end
            end
            data(si).bin_rcurve.kernel = rbinx_kernel;
        end
        data(si).trialn = trialn;
        data(si).rcurve = rcurve;

        
        
    %     if exist(['f' data(si).info_exp '.m'])
    %         fc = str2func(['f' data(si).info_exp]);
    %         data(si).special = {fc(data(si))};
    %     else
    %         data(si).special = {};
    %     end
    end
% save(fullfile(datadir, 'data_3_withindmeasure'),'data');
% delete(fullfile(datadir, 'data_4_gpindmeasure.mat'));
end
%%

%         p_lm(hi) = nanmean(c_lm(idx_h,5));
%         p_da0(hi) = nanmean(c_da(idx_h));
%         p_r(hi) = mean(c_r(idx_h,5));
%   if isfield(game, 'repeat_compare_agree') && ~isempty(game.repeat_compare_agree)
%         c_da0 = 1 - game.repeat_compare_agree;
%     else
%         c_da0 = c_da;
%     end
% isxfit = false;
%  if isxfit
%     xfit = fit_MLE(game.cond_horizon, game.cond_info, R4.right, c5);
%     data(si).mle_infobonus = xfit.x(3,:);
%     data(si).mle_noise13 = xfit.x(2,:);
%     data(si).mle_bias13 = xfit.x(1,:);
%     data(si).mle_e113 = xfit.x(4,:);
%     data(si).mle_e213 = xfit.x(5,:);
%     data(si).mle_noise22 = xfit.x(7,:);
%     data(si).mle_bias22 = xfit.x(6,:);
%     data(si).mle_e122 = xfit.x(8,:);
%     data(si).mle_e222 = xfit.x(9,:);
%     else
%         warning('no xfit');
%  end
%     
%     p_ac1(hi) = nanmean(c_ac(idx_h & game.repeat_order == 1,5));
%         p_ac2(hi) = nanmean(c_ac(idx_h & game.repeat_order == 2,5));
%         p_lm1(hi) = nanmean(c_lm(idx_h & game.repeat_order == 1,5));
%         p_lm2(hi) = nanmean(c_lm(idx_h & game.repeat_order == 2,5));
%       
%   if isfield(game, 'repeat_compare_agree') && ~isempty(game.repeat_compare_agree)
%             cra = 1 - game.repeat_compare_agree;
%             data(si).p_da13_compare(hi) = nanmean(cra(idx_h & idx_13));
%             data(si).p_da22_compare(hi) = nanmean(cra(idx_h & idx_22));
%             data(si).p_da_compare0(hi) = nanmean(cra(idx_h));
%             cra = 1 - game.repeat_compare_agree2;
%             data(si).p_da13_compare2(hi) = nanmean(cra(idx_h & idx_13));
%             data(si).p_da22_compare2(hi) = nanmean(cra(idx_h & idx_22));
%             data(si).p_da_compare2(hi) = nanmean(cra(idx_h));
%             
%         end
%             data(si).p_das(hi,pi) = nanmean(c_da(idx_h & idx_p));
%             if isfield(game, 'repeat_compare_agree') && ~isempty(game.repeat_compare_agree)
%                 cra = 1 - game.repeat_compare_agree;
%                 data(si).p_da_compare(hi,pi) = nanmean(cra(idx_h & idx_p));
%             end
%         end
        
% 
% %         rbins = [-inf -35 -25 -15 -9 -3 3 9 15 25 35 inf];
% %         rbins = [-inf -40 -30 -20 -15 -10 -6 -3 3 6 10 15 20 30 40 inf];
%         rbins = [-30:30];
% %         rbinpair = [rbins(1:end-1);rbins(2:end)];
%         data(si).game.rbins = rbins;
%         
% %             for bi = 1:size(rbinpair,2)
%             for bi = 1:length(rbins)
% %                 rbinpair(1,bi) = rbins(bi)-3;
% %                 rbinpair(2,bi) = rbins(bi)+3;
% %                 idx_bin = (R4.(R4name) >= rbinpair(1,bi)) & ...
% %                     (R4.(R4name) < rbinpair(2,bi));
% %                 idx_binh = idx_bin & idx_h;
% %                 nums{ri}(si,bi) = sum(idx_binh);
%                
%                 if sum(idx_binh) == 0
%                     rcurve.(R4name){hi}.p_hi(bi,:) = repmat(NaN,1,10);
%                     rcurve.(R4name){hi}.p_lm(bi,:) = repmat(NaN,1,1);
%                     rcurve.(R4name){hi}.p_r(bi,:) = repmat(NaN,1,10);
%                     rcurve.(R4name){hi}.p_ac(bi,:) = repmat(NaN,1,10);
%                     rcurve.(R4name){hi}.RT(bi,:) = repmat(NaN,1,10);
% %                     rcurve.(R4name){hi}.p_da(bi,:) = repmat(NaN,1,1);
% %                     rcurve.(R4name){hi}.p_da0(bi,:) = repmat(NaN,1,1);
%                 else
%                     rcurve.(R4name){hi}.p_hi(bi,:) = nanmean(c_hi(idx_binh,:),1);
%                     rcurve.(R4name){hi}.p_lm(bi,:) = nanmean(c_lm(idx_binh,:),1);
%                     rcurve.(R4name){hi}.p_r(bi,:) = nanmean(c_r(idx_binh,:),1);
%                     rcurve.(R4name){hi}.p_ac(bi,:) = nanmean(c_ac(idx_binh,:),1);
%                     rcurve.(R4name){hi}.RT(bi,:) = nanmean(game.RT(idx_binh,:),1);
% %                     rcurve.(R4name){hi}.p_da(bi,:) = nanmean(c_da(idx_binh,:),1);
% %                     rcurve.(R4name){hi}.p_da0(bi,:) = nanmean(c_da0(idx_binh,:),1);
% %                     rcurve.(R4name){hi}.p_da(bi,:) = nansum(c_da(idx_binh,:).*dfRk,1)/nansum((~isnan(c_da(idx_binh))).*dfRk,1);
% %                     rcurve.(R4name){hi}.p_da0(bi,:) = nansum(c_da0(idx_binh,:),1);
%                 end
%             end
%         end