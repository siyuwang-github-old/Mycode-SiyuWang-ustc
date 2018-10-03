classdef group_BIS < handle
    
    % this is a bit of a temporary one until we get enough subs for
    % group_personality
    
    properties
        
        datadir
        sub
        bad_sub
        
    end
    
    methods
        
        function obj = group_BIS(datadir)
            obj.datadir = datadir;
        end
        
        function load(obj)
            d = dir(fullfile(obj.datadir, '*.mat'));
            j = 1;
            for i = 1:length(d)
                dum = ~(~isempty(regexp(d(i).name, '_BIS')) | ~isempty(regexp(d(i).name, '_TPQ')));
                if dum
                    sub(j) = subject_BIS(obj.datadir, d(i).name);
                    sub(j).load;
                    sub(j).augmentDataStructure;
                    j = j + 1;
                end
            end
            obj.sub = sub;
            
            % PRUNE OUT SUBJECTS THAT DON'T HAVE A TPQ FILE
%             for sn = 1:length(obj.sub)
%                 idx(sn) = exist([obj.sub(sn).datadir obj.sub(sn).dataname_TPQ]) == 2;
%             end
%             obj.sub = obj.sub(idx);
        end
        
        function scoreBIS(obj)
            for sn = 1:length(obj.sub)
                obj.sub(sn).scoreBIS;
            end
        end
        
                
        function scoreTPQ(obj)
            for sn = 1:length(obj.sub)
                obj.sub(sn).scoreTPQ;
            end
        end
    end
    
end