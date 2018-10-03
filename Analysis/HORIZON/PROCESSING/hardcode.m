function data = hardcode(data)
     % hard code fix
    st = SiyuTools;
    if strcmp(unique({data.info_expsavename}), 'Horizon___AU16S_075_blink')
        [data.info_session] = deal(1);
    end
    if strcmp(unique({data.info_expsavename}), 'Horizon___AU16F_017_Infinite')
        [~,~,raw] = xlsread(fullfile('W:\LAB\DATA\Horizon___AU_017-Data_Fall2016',...
            'Experiment017together.csv'));
        subID = raw(4:end,18);
        subID = cellfun(@(x)x,subID);
        gender = raw(4:end,19);
        age = raw(4:end,20);
        age = cellfun(@(x)x,age);
        dsubID = [data.subjectID];
        match = arrayfun(@(x)find(ismember(subID, x)), dsubID, 'UniformOutput', false);
        age = cellfun(@(x)st.iif(isempty(x), NaN, age(x)), match, 'UniformOutput', false);
        gender = cellfun(@(x)st.iif(isempty(x), NaN, gender(x)), match, 'UniformOutput', false);
        [data.demo_age] = deal(age{:});
        [data.demo_gender] = deal(gender{:});
    end
    if strcmp(unique({data.info_expsavename}), 'Horizon___AU16S_073_infinite')
        [~,~,raw] = xlsread(fullfile('W:\LAB\DATA\Horizon___AU_073_Data_Spring2016',...
            'Experiment073.csv'));
        subID = raw(4:end,18);
        subID = cellfun(@(x)x,subID);
        gender = raw(4:end,19);
        age = raw(4:end,20);
        age = cellfun(@(x)x,age);
        dsubID = [data.subjectID];
        match = arrayfun(@(x)find(ismember(subID, x)), dsubID, 'UniformOutput', false);
        age = cellfun(@(x)st.iif(isempty(x), NaN, age(x)), match, 'UniformOutput', false);
        gender = cellfun(@(x)st.iif(isempty(x), NaN, gender(x)), match, 'UniformOutput', false);
        [data.demo_age] = deal(age{:});
        [data.demo_gender] = deal(gender{:});
    end
    if strcmp(unique({data.info_expsavename}), 'Horizon___AU15F_060_infinite')
        [~,~,raw] = xlsread(fullfile('W:\LAB\DATA\Horizon___AU_060_Data_Fall2015',...
            'Study_059.csv'));
        subID = raw(3:end,11);
        subID = cellfun(@(x)x,subID);
        gender = raw(3:end,47);
        age = raw(3:end,48);
        age = cellfun(@(x)x,age);
        dsubID = [data.subjectID];
        match = arrayfun(@(x)find(ismember(subID, x)), dsubID, 'UniformOutput', false);
        age = cellfun(@(x)st.iif(isempty(x), NaN, age(x)), match, 'UniformOutput', false);
        gender = cellfun(@(x)st.iif(isempty(x), NaN, gender{x}), match, 'UniformOutput', false);
        [data.demo_age] = deal(age{:});
        [data.demo_gender] = deal(gender{:});
    end
    if strcmp(unique({data.info_expsavename}), 'Horizon___AU16F_019_ActivePassive')
          [data.demo_age] = deal(NaN);
          [data.demo_gender] = deal(NaN);
    end
end