clear all, clc;
%%
datadirs{1} = 'W:\LAB\DATA\Cardstopping___AU_025_New';
expsavenames{1} = 'CS_v2_pilot';
fileheads{1} = 'E025_Sub*';
%%
datadirs{2} = 'W:\LAB\DATA\Cardstopping___AU_025_CardStopping';
expsavenames{2} = 'CS_v1';
fileheads{2} = 'E025_Sub*';
%%
datadirs{3} = 'W:\LAB\DATA\Cardstopping___AU_016_Cardstopping18F';
expsavenames{3} = 'CS_v3';
fileheads{3} = 'ECS_Sub*';

%%
savedir = 'W:\LAB\DATAMAT';
ST = SiyuTools;
%%
for ddii = 1:3
    datadir = datadirs{ddii};
    expsavename = expsavenames{ddii};
    filehead = fileheads{ddii};
    subs = []; % subID + date + time
    files = dir(fullfile(datadir, [filehead]));
    names = arrayfun(@(x)x.name, files, 'UniformOutput', false);
    dates = arrayfun(@(x)datestr(x.date,30), files, 'UniformOutput', false);
    timeh = horzcat(cellfun(@(x)str2num(x(1:8)), dates),cellfun(@(x)str2num(x(10:15)), dates));
    n1 = length(filehead);
    tID = cellfun(@(x)str2num(x(n1:(strfind(x,'_20')-1))), names);%, 'UniformOutput', false);
    datetime = cellfun(@(x)x((strfind(x,'_20')+1):(strfind(x,'.mat')-1)), names, 'UniformOutput', false);
    tdate = cellfun(@(x)str2num(x(1:8)), datetime);
    istime = cellfun(@(x)length(strfind(x,'T'))==1,datetime);
    ttime = NaN(length(istime),1);
    ttime(istime) = cellfun(@(x)str2num(x(10:15)), datetime(istime));
    subh = [tID, tdate, ttime];
    subs = ST.addrow(subs, subh);
    subs = ST.nanunique(subs, 'row');
    %% exclude subject IDs out of range
    subrange = (1:500)';
    subs = subs(ST.getrowindex(subrange, subs(:,1)) == 1,:);
    %% scan for missing and duplicated items
    n_head = 1;
    itemlist = NaN(size(subs,1), 3 + n_head);
    itemlist(:,1:3) = subs;
    timelist = cell(size(subs,1), 3 + n_head);
    timelist(:,1:3) = mat2cell(subs, ones(size(subs,1),1), ones(size(subs,2),1));
    fi = 1;
    [trep, tidx] = ST.getrowindex(subh, subs);
    itemlist(:,fi + 3) = trep;
    timelist(:,fi + 3) = cellfun(@(x)timeh(x,:) ,tidx, 'UniformOutput', false);
    %% Time check
    df_time = NaN(size(subs,1), 3 + n_head);
    df_time(:,1:3) = subs;
    for si = 1:size(subs,1)
        for fi = 1:n_head
            te = timelist{si,fi+3};
            if (size(te,1) == 1)
                if (te(1) == itemlist(si, 2))
                    df_time(si,fi+3) = round(abs(ST.time2hour(te(2)) - ST.time2hour(itemlist(si,3))), 2);
                else
                    df_time(si,fi+3) = -inf;
                end
            end
        end
    end
    %% exclude participants without horizontask data
    include = find(itemlist(:,4) == 1);
    data = [];
    for i = 1:length(include)
        si = include(i);
        data(si).exp = expsavename;
        data(si).subID = df_time(si,1);
        disp(sprintf('importing data from subject %d', data(si).subID));
        data(si).date = df_time(si,2);
        data(si).time = df_time(si,3);
        data(si).site = 'Arizona';
        
        tfile = dir(fullfile(datadir, strcat(filehead(1:end-1),...
            num2str(data(si).subID),'_',num2str(data(si).date),...
            '*',num2str(data(si).time),'*')));
        if length(tfile) > 1
            error('multiple files with identical names')
        end
        try
            td = load(fullfile(tfile.folder, tfile.name));
        catch
            disp(sprintf('Failed in subject: %d', si));
            data(si).task = [];
            continue;
        end
        if data(si).subID ~= td.subjectID
            error('subject ID mismatch');
        end
        data(si).taskraw = td.task;
        data(si).task = formatgame(td.task);
        if isempty(td.demo.gender)
            td.demo.gender = 'NaN';
        elseif strcmp(td.demo.gender, 'female')
            td.demo.gender = '2';
        elseif strcmp(td.demo.gender, 'male')
            td.demo.gender = '1';
        end
        data(si).demo = td.demo;
        
        data(si).postques = td.postques;
        data(si).time = td.time;
    end
    data = data(arrayfun(@(x)~isempty(x.task),data));
    disp('Finished');
    save(fullfile(savedir, expsavename), 'data');
end
%%
% ages = arrayfun(@(x)str2num(x.demo.age), data);
% genders = arrayfun(@(x)str2num(x.demo.gender), data);%, 'UniformOutput', false);
% sprintf('Male = %d, Female = %d, No info = %d', sum(genders == 1), sum(genders == 2), sum(isnan(genders)))
% sprintf('Ages %d - %d, M = %.2f', min(ages), max(ages), mean(ages))