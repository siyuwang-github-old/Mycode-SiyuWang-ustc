classdef Siyuhandle < handle
    properties
        siyupathmain
        siyupathdata
        siyupathdatamat
        siyupathfigure
        siyupathdatabayes
        siyupathresultbayes
        siyupathmodelbayes
    end
    methods
        function obj = Siyuhandle()
            obj.siyupathmain = 'C:\Users\sywangr\Dropbox\GITHUB_CODE_BACKUP\Mycode-SiyuWang-ustc\';
            obj.siyupathdata = '';
            obj.siyupathdatamat = '';
            obj.siyupathfigure = '';
            obj.siyupathdatabayes = 'C:\Users\sywangr\Dropbox\BAYESDATA';
            obj.siyupathresultbayes = 'C:\Users\sywangr\Dropbox\BAYESRESULT';
            obj.siyupathmodelbayes = fullfile(obj.siyupathmain,'\Analysis\HORIZON\BAYESIAN\Models');
        end
    end
end