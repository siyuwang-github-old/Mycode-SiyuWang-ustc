classdef SiyuLatex < SiyuStatistics
    properties
    end
    methods
        function obj = SiyuLatex()
        end
        
        function corrtable(obj, a, b, titleb, titlea, istri, nmax, mastertitlex, mastertitley)
            if ~exist('nmax') || isempty(nmax)
                nmax = length(titlea) + 2;
            end
            if ~exist('istri') || isempty(istri)
                istri = false;
            end
            [R, P] = corr(a,b);
            if istri
                R = tril(R);
                P = tril(P);
                mnan = nan(size(P,1), size(P,2));
                P = P + triu(mnan,1);
            end
            R = round(R,2);
            
            tb = array2table(R, 'RowNames', titleb);
            tb = table2cell(tb);
            ps = obj.getstatstars(P,' ');
            if istri
            tb = strcat(cellfun(@(x)obj.iif(x == 0,'',num2str(x)), tb,'UniformOutput',false), ps);
            else
            tb = strcat(cellfun(@(x)obj.iif(x == 0,num2str(x),num2str(x)), tb,'UniformOutput',false), ps);
            end
            out = cell(size(a,2)+1,size(b,2)+1);
            out(2:end, 2:end) = tb;
            out(1,2:end) = titlea;
            out(2:end,1) = titleb;
            
            o1 = out(:,[1]);
%             clc;
%             out = out';
            out = out(:,2:end);
            
%             
%             if exist('mastertitlex')
%                 nx = size(out,2);
%                 nc = floor((nx+1)/2);
%                 o1 = vertcat({''},o1);
%                 ox = cell(1,nx);
%                 ox{nc} = mastertitlex;
%                 out = vertcat(ox,out);
%             end
            
            
            n = size(out,2);
            nc = ceil(n/nmax);
            for nci = 1:nc
                a1 = (nci-1)*nmax + 1;
                a2 = min(a1+nmax-1, n);
                if n - a2 < nmax
                    a2 = n;
                end
%                 a1:a2
                lt = obj.cell2latex([o1 out(:,a1:a2)]);
            end
        end

        function latex = cell2latex(obj, t)
            d = t(2:end, 2:end);
            idxempty = cellfun(@(x)length(x) == 0, d);
            d(idxempty) = cellfun(@(x)'', d(idxempty),'UniformOutput', false);
            d(~idxempty) = cellfun(@(x)num2str(x), d(~idxempty), 'UniformOutput', false);
            t(2:end, 2:end) = d;
            input.data = t;
            % Column alignment ('l'=left-justified, 'c'=centered,'r'=right-justified):
            input.tableColumnAlignment = 'c';
            
            % Switch table borders on/off:
            input.tableBorders = 1;
            
            % Switch to generate a complete LaTex document or just a table:
            input.makeCompleteLatexDocument = 0;
            
            % Now call the function to generate LaTex code:
            latex = latexTable(input);
        end
    end
end