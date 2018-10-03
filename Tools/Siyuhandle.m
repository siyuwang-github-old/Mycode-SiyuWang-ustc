classdef Siyuhandle < handle
    properties
        siyupathdata
        siyupathdatamat
        siyupathfigure
        siyupathdatabayes
        siyupathresultbayes
    end
    methods
        function obj = Siyuhandle()
            obj.siyupathdata = 'W:\LAB\DATA';
            obj.siyupathdatamat = 'W:\LAB\DATAMAT';
            obj.siyupathfigure = 'W:\LAB\FIGS';
            obj.siyupathdatabayes = 'W:\LAB\DATAMAT\BAYESDATA';
            obj.siyupathresultbayes = 'W:\LAB\DATAMAT\BAYESDATA'
        end
    end
end