function [paths, seqPaths, labels] = findUniqPaths(lapsActual, lapsIdeal, adjM, distM)
%findUniqPaths clustering the runs and labeling the clusters
%   the function receives the detected runs (actual and ideal) and the
%   adjacency and distance matrix of the graph
%   it returns the unique runs/paths (clusters of runs), their sequence in
%   the trajectory and asks the user for their labels
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

for i = 1: size(lapsIdeal,1)-1
    if lapsIdeal(i,2) ~= lapsIdeal(i+1,1)
        error('Inconsistent Sequence of Laps')
    end
end

% finding and labeling the unique paths/runs
repeatFlag = 0 ;
uniqDir = unique(lapsIdeal,'rows');
paths = cell(1,size(uniqDir,1));
labels = cell(1,size(uniqDir,1));
for i= 1: size(uniqDir,1)
    paths{i} = findPath(uniqDir(i,1), uniqDir(i,2), adjM, distM);
    labels{i} = input(sprintf('Give label for %s -> %s: ',  num2str(uniqDir(i,1)), num2str(uniqDir(i,2))), 's');
    if ismember(labels{i}, labels(1:i-1))
        repeatFlag = 1;
    end
end
if repeatFlag
    warning('at least one label was used multiple times')
end

% sequence of paths 
% transforming the sequence of ideal laps to indices of the unique paths

seqPaths = zeros(size(lapsIdeal,1),1);
for i = 1: length(seqPaths)
    [~,IND] = ismember(lapsIdeal(i,:), uniqDir, 'rows');
    seqPaths(i)= IND;
end

% check whether the actual runs cover the whole run or part of it;
% shorten the unique paths if needed;
% it is recommended to shorten them in cases where the lines drawn 
% initially were proven to be too long;
% not the most elegant solution here
actualUnion = [];
for i = 1: size(lapsActual, 1)
    actualUnion = union(actualUnion, findPath(lapsActual(i,1), lapsActual(i,2), adjM, distM));
end

for i = 1:length(paths)
    SD = setdiff(paths{i}, actualUnion);
    if ~isempty(SD)
        key = input(sprintf('The run %s was found not to be covered completely during the laps. Do you want to shorten it? (y): \n', labels{i}), 's');
        if strcmp(key, 'y')
            % using intersection won't work because we need to preserve the
            % order in the path
          paths{i}(ismember(paths{i}, SD)) = [];
          disp('The run was shortened. It will be referred to as before (idealLap numbers) but the firing rate and occupancy will be calculated based on the shortened version.')
        end
    end
    
end
end

