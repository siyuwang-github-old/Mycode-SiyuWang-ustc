clear all,clc;
datadir = 'W:\LAB\DATAMAT';
delete(fullfile(datadir, 'data_horizon_compiled.mat'));
% delete(fullfile(datadir, 'data_2_preprocessed.mat'));
% delete(fullfile(datadir, 'data_3_withindmeasure.mat'));
% delete(fullfile(datadir, 'data_4_gpindmeasure.mat'));
files = dir(fullfile(datadir, strcat('Horizon___*.mat')));
ongoings = {files([18 19]).name};
files_processed = dir(fullfile(datadir, strcat('processed___Horizon___*.mat')));
st = SiyuTools;
%%
overwrite_process = false;
%%
for ei = 1:length(files)
    if overwrite_process || all(~strcmp({files_processed.name}, ['processed___' files(ei).name])) ...
            || any(strcmp(ongoings, [files(ei).name]))
        disp(sprintf('loading experiment %s', files(ei).name));
        data = importdata(fullfile(files(ei).folder, files(ei).name));
        if isempty(data)
            continue;
        end
        data = data(arrayfun(@(x)length(x.game),data)==1);
        data = data(arrayfun(@(x)x.num_game ~= 0, data));
        data = hardcode(data);
        exp{ei} = data;
    else
        disp(sprintf('loading experiment %s', ['processed___' files(ei).name]));
        epi = find(strcmp({files_processed.name}, ['processed___' files(ei).name]));
        exp{ei} = importdata(fullfile(files_processed(epi).folder, files_processed(epi).name));
    end
end
names = st.getstructures(exp);
%%
for ei = 1:length(files)
    if overwrite_process || all(~strcmp({files_processed.name}, ['processed___' files(ei).name])) ...
            || any(strcmp(ongoings, [files(ei).name]))
        disp(sprintf('processing experiment %s', files(ei).name));
        data = exp{ei};
        if isempty(data)
            continue;
        end
        data = st.fillstructures(data, names);
        data = preprocess(data);
        data = individualanalysis(data);
        expname = unique({data.info_expsavename});
        exp{ei} = data;
        save(fullfile(datadir, ['processed___' expname{1}]), 'data');
    else
        disp(sprintf('skipped - experiment %s', files(ei).name));
    end
end
%%
data = st.structurearraycat(exp);
save(fullfile(datadir, 'data_horizon_compiled'), 'data');
disp('Complete compiling data!')
