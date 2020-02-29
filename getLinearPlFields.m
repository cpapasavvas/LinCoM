function [PF, OCCUP, CVs, infos] = getLinearPlFields(fpath, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj, labels, plFlag)
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


% load the cl file for the specific cell
filepath = fullfile(fpath, 'clusters');
if exist(filepath,'file')
    a = textread(filepath,'%s');
else
    error('cannot find cluster file in the given filepath')
end

PF = cell(length(uniqPaths), size(a,1));
OCCUP = cell(length(uniqPaths), 1);         % this is common among the cells
CVs = zeros(length(uniqPaths), size(a,1));
infos = zeros(length(uniqPaths), size(a,1));
for i= 1: size(a,1)
    filenameCL = fullfile(fpath, a{i});
    cl = cl2mat(filenameCL);
    [PF(:,i), OCCUP(:,1), CVs(:,i), infos(:,i)] = linearPlField(i, cl, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj, labels, plFlag);
    if plFlag
        pause
    end
end

end

