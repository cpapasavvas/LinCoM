function [commitI, commitMap] = getCommit(uniqB, distM, endsI, ecc, adjM, frame)
%GETCOMMIT Summary of this function goes here
%   The functions gets all the elements that define the graph and asks
%   from the user to choose the commitment nodes in the graph, one for each end.
%   The path from each commitment node to its respective end is part of the
%   commitment map (commitMap). Both commitment nodes and commitment map
%   are returned.
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

disp('  - Commitment subgraphs')
disp('  Interativiely choose the commitment region for each end in the maze')


% get the commitment points on the tracks
% interactive function needed here
% to get the commitement point for each end
% the commitment points should be sorted according to the ends
commitI = getCommitFig(uniqB, distM, adjM, endsI, frame);

% map the bins beyond the commitment points to their respective end
% assuming that the path from the commitm point to its end is always
% like: commit : 1: end or end: 1: commit
commitMap = -ones(size(ecc));
for i = 1: length(endsI)
    if endsI(i) < commitI(i)
        path = endsI(i): 1: commitI(i);
    else
        path = commitI(i): 1: endsI(i);
    end
    
    % make sure that the above assumption holds
    for j = 1: length(path)-1
        if ~adjM(path(j),path(j+1))
            error('check commitment path')
        end
    end
    
    commitMap(path) = endsI(i);
end

commitMap(commitMap == -1) = 0;
end

