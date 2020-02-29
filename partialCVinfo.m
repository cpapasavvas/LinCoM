function [CV, info, AUC] = partialCVinfo(cellID, FR, OCCUP, labels, plotFlag, range)
%CVINFO Calculates CV and spatial info for a set of linear place fields (for 
% a single cell), either the whole or part of it (use range of indices)
%   FR and OCCUP are provided as a cell array, same size
% range should be a cell of integer arrays mapping to the PF and OCCUP
% arrays. the integers are the indices to be
% included in the computation in the respective PF.
% leave ranges empty or missing to consider the whole PF
% computes also the Area Under the Curve AUC
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

if nargin<6
    range = [];
end

if length(FR)~= length(OCCUP)
    error('input cell arrays have no matching size')
end


CV = zeros(length(FR), 1);
info = zeros(length(FR), 1);
AUC = zeros(length(FR), 1);


for i = 1: length(FR)
    
    
    
    if isempty(range)
        x = FR{i} ./ mean(FR{i});
        p = OCCUP{i} ./ sum(OCCUP{i});
        AUC(i) = sum(FR{i});
    else
        x = FR{i}(range{i}) ./ mean(FR{i}(range{i}));
        p = OCCUP{i}(range{i}) ./ sum(OCCUP{i}(range{i}));
        AUC(i) = sum(FR{i}(range{i}));
    end
    
    % calculate coefficient of variation as in CalcPFSpatialInfoGDlabjs
    CV(i) = sqrt(sum((x).^2.*p) - sum(x.*p).^2);
    
    % calculate spatial information
    x(x==0) = 1;              % as in CalcPFSpatialInfoGDlabjs
    info(i) = sum(p.*x.*log2(x));
    
    if plotFlag
        subplot(length(FR), 1, i)
        
        step = 1/(length(FR{i})-1);
        plot(0:step:1, FR{i})
        if ~isempty(range)
            if range{i}(1) ==1
                q = range{i}(end);
            else
                q = range{i}(1);
            end
            q = q / length(FR{i});
            hold on
            plot([q q],[0 3], '--')
        end
        ylabel('FR')
        
        
        title_ = ['cellID: ' num2str(cellID)];
        subtitle = [ labels{i} ' - ' 'CV:' num2str(CV(i)) ' - ' 'SpInfo:' num2str(info(i)) ' - ' 'AUC:' num2str(AUC(i)) ];
        if i==1
            title({title_; subtitle});
        else
            title( subtitle)
        end
        if i == length(FR)
            xlabel('normalized distance')
        end
        hold off
    end

end
