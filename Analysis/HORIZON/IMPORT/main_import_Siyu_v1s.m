%%
clear all, clc;
nexps = 0;
savedir = 'W:\LAB\DATAMAT';
%%
nexps = nexps + 1;
exphead{nexps} = 'APSequentialnew';
expname{nexps} = '18F037';
expsavename{nexps} = 'Horizon___AU18F_037_ActiveSequential';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_037_Activepassive_Sequential';
fileheads{nexps} = {'horizontask1','horizontask2'}; % eye data
subrange{nexps} = 200:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 1;

nexps = nexps + 1;
exphead{nexps} = 'Horizon';
expname{nexps} = '18F031';
expsavename{nexps} = 'Horizon___AU18F_031_Fullfeedback';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_031_Fullfeedback';
fileheads{nexps} = {'behavior'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'behavior_';
ongoing(nexps) = 1;

nexps = nexps + 1;
exphead{nexps} = 'SocialExplore';
expname{nexps} = '18F017';
expsavename{nexps} = 'Horizon___AU18F_017_SocialActive';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_017_Social_Explore_Data';
fileheads{nexps} = {'horizontask'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P017';
expname{nexps} = '16F017';
expsavename{nexps} = 'Horizon___AU16F_017_Infinite';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_017-Data_Fall2016\data';
fileheads{nexps} = {'horizontask'}; % eye data, infinite bandit
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'APSequential';
expname{nexps} = '18F018';
expsavename{nexps} = 'Horizon___AU18F_018_ActiveSequential';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_018_Activepassive_Sequential';
fileheads{nexps} = {'horizontask1','horizontask2'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P019';
expname{nexps} = '16F019';
expsavename{nexps} = 'Horizon___AU16F_019_ActivePassive';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_019-Explore-Exploit\data';
fileheads{nexps} = {'horizontask1','horizontask2'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

% 023 EEG Pilot

% nexps = nexps + 1;
% expname{nexps} = '16F023v1';
% expsavename{nexps} = 'Horizon___AU16F_023_EEGPilot';
% datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_023_EEGBehavioralPilot\P023\DATA';
% fileheads{nexps} = {'behavior'};_% eye data
% 
% nexps = nexps + 1;
% expname{nexps} = '16F023v2';
% expsavename{nexps} = 'Horizon___AU16F_023_EEGPilot';
% datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_023_EEGBehavioralPilot\P023\DATA';
% fileheads{nexps} = {'HORIZON_behavior'};_% eye data

% 024 explicit info

nexps = nexps + 1;
exphead{nexps} = 'P026';
expname{nexps} = '17S026';
expsavename{nexps} = 'Horizon___AU17S_026_Fullfeedback';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_026_Fullfeedback\DATA_026_SIYU';
fileheads{nexps} = {'horizontask','demographicinfo'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'Auditory';
expname{nexps} = '17F028';
expsavename{nexps} = 'Horizon___AU17F_028_Auditory';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_028_Auditory';
fileheads{nexps} = {'behavior'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'behavior_';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P042';
expname{nexps} = '15F042';
expsavename{nexps} = 'Horizon___AU15F_042_testretest';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_042_Repeated_Passive';
fileheads{nexps} = {'horizontask','demographicinfo','survey_ID_Scale','survey_CEIII'};
% post ques, eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P060';
expname{nexps} = '15F060';
expsavename{nexps} = 'Horizon___AU15F_060_infinite';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_060_Data_Fall2015\data';
fileheads{nexps} = {'horizontask'}; % eye data, infinite bandit
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P061';
expname{nexps} = '15F061v1';
expsavename{nexps} = 'Horizon___AU15F_061_socialv1';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_061_Social_Fall2015\Data\Part_1';
fileheads{nexps} = {'horizontask'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P061';
expname{nexps} = '15F061v2';
expsavename{nexps} = 'Horizon___AU15F_061_socialv2';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_061_Social_Fall2015\Data\Part_2';
fileheads{nexps} = {'horizontask'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P072';
expname{nexps} = '16S072v1';
expsavename{nexps} = 'Horizon___AU16S_072v1';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_072_Spring_2016_Social_decision-making\072_Data\072 Version 1';
fileheads{nexps} = {'horizontask'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P072';
expname{nexps} = '16S072v2';
expsavename{nexps} = 'Horizon___AU16S_072v2';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_072_Spring_2016_Social_decision-making\072_Data\072 Version 2';
fileheads{nexps} = {'horizontask'}; % eye data
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P073';
expname{nexps} = '16S073';
expsavename{nexps} = 'Horizon___AU16S_073_infinite';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_073_Data_Spring2016\data';
fileheads{nexps} = {'horizontask'}; % eye data, infinite bandit
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P075';
expname{nexps} = '16S075';
expsavename{nexps} = 'Horizon___AU16S_075_blink';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_075_Horizon1_Original\data';
fileheads{nexps} = {'horizontask','demographicinfo','survey_ID_Scale','survey_CEIII'};
% post ques
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

nexps = nexps + 1;
exphead{nexps} = 'P085';
expname{nexps} = '16S085';
expsavename{nexps} = 'Horizon___AU16S_085_TMT';
datadir{nexps} = 'W:\LAB\DATA\Horizon___AU_085_TMT\085_Data';
fileheads{nexps} = {'horizontask'}; % eye data, infinite bandit
subrange{nexps} = 1:500;
subjectIDque{nexps} = 'sub';
ongoing(nexps) = 0;

[~, idxexps] = sort(ongoing);
%%
overwrite = false;
for ni = idxexps
    if overwrite || ongoing(ni) == 1 || exist(fullfile(savedir, [expsavename{ni} '.mat'])) ~= 2
        import_Siyu_v1(expname{ni}, datadir{ni}, savedir, expsavename{ni}, ...
            exphead{ni}, fileheads{ni}, subrange{ni}, subjectIDque{ni});
    else
        disp(sprintf('experiment %s has been imported. SKIPPED', expsavename{ni}));
    end
end