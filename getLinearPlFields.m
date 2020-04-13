function [PF, OCCUP] = getLinearPlFields(cells, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj, labels)
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


% deduct frame rate from the continious time vector
fR = 1/(cTrajT(2)-cTrajT(1));


PF = cell(length(uniqPaths), length(cells));
OCCUP = cell(length(uniqPaths), 1);         % this is common among the cells
for i= 1: length(cells)                 % scroll across cells
    spikeT = cells{i};
    [PF(:,i), OCCUP(:,1)] = linearPlField(fR, spikeT, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj);

    figure(10+i)
    for j=1:size(PF,1)
        step = 1/(length(uniqPaths{j})-1);
        subplot(length(uniqPaths), 1, j);
        plot(0:step:1, PF{j,i})
        ylabel('FR')

        if j == 1
            title({['cell ' num2str(i)]; labels{j}});
        else
            title( labels{j})
        end
        if j == length(PF)
            xlabel('normalized distance')
        end
    end

end

end

