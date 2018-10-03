classdef group_testRetest < handle
    
    properties
        
        datadir
        sub
        bad_sub
        
    end
    
    methods
        
        function obj = group_testRetest(datadir)
            obj.datadir = datadir;
        end
        
        function load(obj)
            d = dir(fullfile(obj.datadir, '*.mat'));
            j = 1;
            for i = 1:length(d)
                dum = ~(~isempty(regexp(d(i).name, '_TPQ')) | ~isempty(regexp(d(i).name, '_BIS')));
                if dum
                    sub(j) = subject_testRetest(obj.datadir, d(i).name);
                    sub(j).load;
                    sub(j).augmentDataStructure;
                    j = j + 1;
                end
            end
            obj.sub = sub;
        end
        
        
        
    end
    
end