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
            obj.siyupathmain = 'W:\LAB\CODE';
            obj.siyupathdata = 'W:\LAB\DATA';
            obj.siyupathdatamat = 'W:\LAB\DATAMAT';
            obj.siyupathfigure = 'W:\LAB\FIGS';
            obj.siyupathdatabayes = 'W:\LAB\DATAMAT\BAYESDATA';
            obj.siyupathresultbayes = 'C:\Users\Siyu\Dropbox\BAYESRESULT';
            obj.siyupathmodelbayes = fullfile(obj.siyupathmain,'\Analysis\HORIZON\BAYESIAN\Models');
        end
    end
end