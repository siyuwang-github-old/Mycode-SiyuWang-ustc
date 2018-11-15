%% mcmc fit
clear all, clc;
%%
isfake = false;
sh = Siyuhandle;
fs = dir(fullfile(sh.siyupathdatabayes, 'MCMClifespan*'));
idfake = arrayfun(@(x)~isempty(strfind(x.name, 'fake')), fs);
fs = SiyuTools.iif(isfake, fs(idfake), fs(~idfake));
path = Siyuhandle;
%%
isoverwrite = true;
for fi = 1:length(fs)
if ~isoverwrite && exist(fullfile(path.siyupathresultbayes, [fs(fi).name(1:end-4), '_bayesresult.mat']))
    warning('files found, skipped');
    continue;
end
%%
abe = analysis_bayesian(fs(fi).name);
%%
abe.analysis(1);
%%
abe.savesamples;
end