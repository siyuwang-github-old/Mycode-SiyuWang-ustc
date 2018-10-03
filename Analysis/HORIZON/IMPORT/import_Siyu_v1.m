% clear, clc;
function import_Siyu_v1(expname, datadir, savedir, expsavename, exphead, fileheads0, subrange, subjectIDque)
disp(sprintf('importing experiment %s', expsavename));
fileheads = strcat(exphead,'*', fileheads0, '_*');
ST = SiyuTools;
n_head = length(fileheads);
%% scan for total list of different combinations of time + subject
subs = []; % subID + date + time
for fi = 1:n_head
    filehead = fileheads{fi};
    files = dir(fullfile(datadir, filehead));
    filenames = arrayfun(@(x)x.name, files, 'UniformOutput', false);
    filedates = arrayfun(@(x)datestr(x.date,30), files, 'UniformOutput', false);
    [timeh{fi}(:,1) timeh{fi}(:,2)] = ST.datestr2num(filedates);
    
    fileheadlens = cellfun(@(x)strfind(x, subjectIDque)+length(subjectIDque), filenames);
    n1 = unique(fileheadlens);
    tID = cellfun(@(x)str2num(x(n1:(strfind(x,'_20')-1))), filenames);
    datetime = cellfun(@(x)x((strfind(x,'_20')+1):(strfind(x,'.mat')-1)), filenames, 'UniformOutput', false);
    [tdate ttime] = ST.datestr2num(datetime);
    subh{fi} = [tID, tdate, ttime];
    subs = ST.addrow(subs, subh{fi});
end
subs = unique(subs, 'row');
%% exclude subject IDs out of range
idx_sub = ~isnan(ST.getpermidx(subrange, subs(:,1)));
subs = subs(idx_sub,:);
%% scan for missing and duplicated items
itemlist = NaN(size(subs,1), 3 + n_head);
itemlist(:,1:3) = subs;
timelist = cell(size(subs,1), 3 + n_head);
timelist(:,1:3) = mat2cell(subs, ones(size(subs,1),1), ones(size(subs,2),1));
for fi = 1:n_head
    [trep, tidx] = ST.getrowindex(subh{fi}, subs);
    itemlist(:,fi + 3) = trep;
    timelist(:,fi + 3) = cellfun(@(x)timeh{fi}(x,:) ,tidx, 'UniformOutput', false);
end
%% Time check
df_time = NaN(size(subs,1), 3 + n_head);
df_time(:,1:3) = subs;
for si = 1:size(subs,1)
    for fi = 1:n_head
        te = timelist{si,fi+3};
        if (size(te,1) == 1)
            if (te(1) == itemlist(si, 2)) 
                df_time(si,fi+3) = round(ST.time2hour(te(2)) - ST.time2hour(itemlist(si,3)), 2);
            else
                df_time(si,fi+3) = -inf;
            end
        end
    end
end
idx_df = any(abs(df_time(:,4:end)) > 1,2);
if any(idx_df)
    warning(sprintf("time mismatch: check participant %d at %d on %d\n",[itemlist(idx_df,1),itemlist(idx_df,3),itemlist(idx_df,2)]'));
end
%% load data
data = [];
import_Siyu_v1_demographicnames;
si = 0;
for i = 1:size(subs,1)
    si = si + 1;
    data(si).subjectID = subs(i,1);
    data(si).info_exp = expname;
    data(si).info_expsavename = expsavename;
    disp(sprintf('importing data from subject %d', data(si).subjectID));
    data(si).datestr_dateonfile = subs(i,2);
    data(si).timestr_timeonfile = subs(i,3);
    data(si).info_site = 'Arizona';
    data(si).info_session = NaN;
    
    isdemo = find(strcmp(fileheads0, 'demographicinfo'));
    if ~isempty(isdemo) && (itemlist(i,isdemo + 3) == 1) % has demo info
        tidx = isdemo + 3;
        tfile = dir(fullfile(datadir, strcat(fileheads{isdemo},...
            num2str(data(si).subjectID),'_',num2str(data(si).datestr_dateonfile),...
            '*',num2str(data(si).timestr_timeonfile),'*')));
        if length(tfile) > 1
            error('multiple files with identical names')
        end
        demo = load(fullfile(tfile.folder, tfile.name));
        if (demo.sub.subjectID ~= data(si).subjectID)
            error(sprintf('inconsistent subject IDs: %d and %d', data(si).sub.subID, demo.subjectID));
        end
        data(si).datestr_demo = timelist{i,tidx}(1);
        data(si).timestr_demo = timelist{i,tidx}(2);
        
        data(si).info_session = demo.sub.session;
        
        data(si).info_eyecalibration = demo.sub.calibrationquality;
        data(si).demonum_sight = find(cellfun(@(x)strcmp(x, demo.sub.sight), Sight));
        data(si).demonum_age = demo.subdemo.age;
        data(si).demonum_gender = find(cellfun(@(x)strcmp(x, demo.subdemo.gender), Gender));
        data(si).demonum_race = find(cellfun(@(x)strcmp(x, demo.subdemo.race), Race));
        data(si).demonum_ethnicity = find(cellfun(@(x)strcmp(x, demo.subdemo.ethnicity), Ethnicity));
        data(si).demonum_english = find(cellfun(@(x)strcmp(x, demo.subdemo.nativeenglishspeaker), English));
        data(si).demo_sight = demo.sub.sight;
        data(si).demo_age = demo.subdemo.age;
        data(si).demo_gender = demo.subdemo.gender;
        data(si).demo_race = demo.subdemo.race;
        data(si).demo_ethnicity = demo.subdemo.ethnicity;
        data(si).demo_english = demo.subdemo.nativeenglishspeaker;
        if (isfield(demo.subdemo, 'sleep'))
            data(si).demonum_sleep = find(cellfun(@(x)strcmp(x, demo.subdemo.sleep), Sleep));
            data(si).demo_sleep = demo.subdemo.sleep;
        end
    else
%         warning(sprintf('no demo file for subject %d', data(si).subID));
    end
    issurveyIDscale = find(strcmp(fileheads0, 'survey_ID_Scale'));
    if ~isempty(issurveyIDscale) && (itemlist(i,issurveyIDscale + 3) == 1) % has survey info
        tidx = issurveyIDscale + 3;
        tfile = dir(fullfile(datadir, strcat(fileheads{issurveyIDscale},...
            num2str(data(si).subjectID),'_',num2str(data(si).datestr_dateonfile),...
            '*',num2str(data(si).timestr_timeonfile),'*')));
        if length(tfile) > 1
            error('multiple files with identical names')
        end
        sv = load(fullfile(tfile.folder, tfile.name));
        if (sv.subjectID ~= data(si).subjectID)
            error(sprintf('inconsistent subject IDs: %d and %d', data(si).sub.subID, sv.subjectID));
        end
        data(si).datestr_survey_IDscale = timelist{i, tidx}(1);
        data(si).timestr_survey_IDscale = timelist{i, tidx}(2);
        data(si).survey.IDscale.ans = [sv.survey.answers.keyNum];
        data(si).survey.IDscale.RT = [sv.survey.answers.RT];
    else
%         warning(sprintf('no ID-scale survey file for subject %d', data(si).subID));
    end
    issurveyCEIII = find(strcmp(fileheads0, 'survey_CEIII'));
    if ~isempty(issurveyCEIII) && (itemlist(i,issurveyCEIII + 3) == 1) % has survey info
        tidx = issurveyCEIII + 3;
        tfile = dir(fullfile(datadir, strcat(fileheads{issurveyCEIII},...
            num2str(data(si).subjectID),'_',num2str(data(si).datestr_dateonfile),...
            '*',num2str(data(si).timestr_timeonfile),'*')));
        if length(tfile) > 1
            error('multiple files with identical names')
        end
        sv = load(fullfile(tfile.folder, tfile.name));
        if (sv.subjectID ~= data(si).subjectID)
            error(sprintf('inconsistent subject IDs: %d and %d', data(si).sub.subID, sv.subjectID));
        end
        data(si).datestr_survey_CEIII = timelist{i, tidx}(1);
        data(si).timestr_survey_CEIII = timelist{i, tidx}(2);
        data(si).survey.CEIII.ans = [sv.survey.answers.keyNum];
        data(si).survey.CEIII.RT = [sv.survey.answers.RT];
    else
%         warning(sprintf('no CEIII survey file for subject %d', data(si).subID));
    end
    flag = false;
    ishorizon = [find(strcmp(fileheads0, 'horizontask')),find(strcmp(fileheads0, 'horizontask1')),find(strcmp(fileheads0, 'behavior'))];
    if ~isempty(ishorizon) && (itemlist(i,ishorizon + 3) == 1) % has horizon info
        flag = true;
        tidx = ishorizon + 3;
        tfile = dir(fullfile(datadir, strcat(fileheads{ishorizon},...
            num2str(data(si).subjectID),'_',num2str(data(si).datestr_dateonfile),...
            '*',num2str(data(si).timestr_timeonfile),'*')));
        if length(tfile) > 1
            error('multiple files with identical names')
        end
        ht = load(fullfile(tfile.folder, tfile.name));
        if (ht.subjectID ~= data(si).subjectID)
            warning(sprintf('inconsistent subject IDs: %d and %d', data(si).subjectID, ht.subjectID));
        end
        data(si).datestr_task = timelist{i, tidx}(1);
        data(si).timestr_task = timelist{i, tidx}(2);
        if isfield(ht, 'starttime')
            [data(si).datestr_taskstart data(si).timestr_taskstart] = ...
                ST.datestr2num(datestr(ht.starttime,30));
            [data(si).datestr_taskend data(si).timestr_taskend] = ...
                ST.datestr2num(datestr(ht.endtime,30));
            data(si).time_instruction = ht.instime/60;
            data(si).time_task = ht.tasktime;
        else
            
            data(si).time_task = ht.time.tasktime;
        end
        data(si).game = import_EEHorizon(ht.game);
        data(si).num_game = data(si).game.n_game;
        if (isnumeric(data(si).info_session) && isnan(data(si).info_session)) || isempty(data(si).info_session)
            data(si).info_session = 1;
        end
    elseif ~isempty(ishorizon)
        warning(sprintf('%d horizon files found for subject %d', itemlist(i,ishorizon + 3), data(si).subjectID));
    end
    ishorizon = [find(strcmp(fileheads0, 'horizontask2'))];
    if ~isempty(ishorizon) && (itemlist(i,ishorizon + 3) == 1) % has survey info
        if flag
            si = si + 1;
            data(si) = data(si-1);
            data(si).info_session = NaN;
        else
            warning('missing horizontask1');
        end
        tidx = ishorizon + 3;
        tfile = dir(fullfile(datadir, strcat(fileheads{ishorizon},...
            num2str(data(si).subjectID),'_',num2str(data(si).datestr_dateonfile),...
            '*',num2str(data(si).timestr_timeonfile),'*')));
        if length(tfile) > 1
            error('multiple files with identical names')
        end
        ht = load(fullfile(tfile.folder, tfile.name));
        if (ht.subjectID ~= data(si).subjectID)
            error(sprintf('inconsistent subject IDs: %d and %d', data(si).sub.subID, ht.subjectID));
        end
        data(si).datestr_task = timelist{i, tidx}(1);
        data(si).timestr_task = timelist{i, tidx}(2);
        [data(si).datestr_taskstart data(si).timestr_taskstart] = ...
            ST.datestr2num(datestr(ht.starttime,30));
        [data(si).datestr_taskend data(si).timestr_taskend] = ...
            ST.datestr2num(datestr(ht.endtime,30));
        data(si).time_instruction = ht.instime/60;
        data(si).time_task = ht.tasktime;
        data(si).game = import_EEHorizon(ht.game);
        data(si).num_game = data(si).game.n_game;
        if (isnumeric(data(si).info_session) && isnan(data(si).info_session)) || isempty(data(si).info_session)
            data(si).info_session = 2;
        end
    elseif ~isempty(ishorizon)
        warning(sprintf('%d horizon files found for subject %d', itemlist(i,ishorizon + 3), data(si).subjectID));
    end
end
% data = data(arrayfun(@(x)x.game.n_game > 0,data));
%%
save(fullfile(savedir, expsavename),'data');
disp(sprintf('import from experiment %s complete', expname));
%%
end