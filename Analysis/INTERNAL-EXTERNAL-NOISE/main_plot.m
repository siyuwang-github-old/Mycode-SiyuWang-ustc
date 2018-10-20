close all, clear all, clc;
%%
pt = plot_horizon();
savefolder = 'Internal_external_noise';
pt.setparameter(0,1,savefolder, 'intext')
acs = [0, 0.55, 0.6, 0.65, -0.01];
%%
order = [2 1];
lmt.p1{1}(order) = {[0.35 0.65],[0.1,0.4]};
lmt.p1{2}(order) = {[0.35 0.65],[0.05 0.35]};
lmt.p1{3}(order) = {[0.35 0.65],[0.05 0.35]};
lmt.p1{4}(order) = {[0.35 0.65],[0.05 0.35]};
lmt.p2{1} = [0.0,0.45];
lmt.p2{2} = [0.0,0.45];
lmt.p2{3} = [0.0,0.45];
lmt.p2{4} = [0.0,0.45];
for aci = 1:length(acs)
    pt.acthres = acs(aci);
    pt.setupexps('16S075',1,1,[],[]);
    %%%
    pt.sethardlim([],lmt.p1{aci});
    pt.ispairedttest = [true false];
    pt.temp_sigstar_y_direction = [1, -1];
    pt.line_modelfree(1,1);
    pt.ispairedttest = [true true];
    stat{aci} = pt.line_disagree_theory(lmt.p2{aci});
    pt.anova_p_da;
end
%%
isfake = false;
% isfake = '2noise';
for aci = 1:length(acs)
    pt.acthres = acs(aci);
    pt.setupexps('16S075',1,1,[],[]);
    pt.save4MCMC('2noisemodel',isfake);
end
%%
    %%
%     pt.line_mlenoise;
    %%
%     pt.line_repeatorder;