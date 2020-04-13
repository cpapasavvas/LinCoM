function [PF, OCCUP] = getLinearPlFields(cells, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj, labels, plFlag)
%GETLINEARPLFIELDS function that handles the generation of linear place
%field (by calling linearPlField function).
%   The function receives the clusters of detected runs, their timings and
%   the trajectory. It also recieves a path which includes the cell
%   clusters and a test file listing these clusters.
%   It returns the linearized place fields, the occupation vector for each
%   one and some metrics (coefficient of variation and spatial info)
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


PF = cell(length(uniqPaths), length(cells));
OCCUP = cell(length(uniqPaths), 1);         % this is common among the cells
for i= 1: length(cells)                 % scroll across cells
    spikeT = cells{i};
    [PF(:,i), OCCUP(:,1)] = linearPlField(fR, spikeT, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj);
    if plFlag
        step = 1/(length(uniqPaths{i})-1);
        subplot(length(uniqPaths), 1, i);
        plot(0:step:1, PF{i})
        ylabel('FR')
        
        if i==1
            title({num2str(cellID); labels{i}});
        else
            title( subtitle)
        end
        if i == length(PF)
            xlabel('normalized distance')
        end
    end
end

end

