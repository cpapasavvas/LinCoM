function [endsI] = findEnds(adjM)
%FINDENDS find the ends of arms in the maze (i.e. leaves in the graph) 
% find the ends of the arms based on the adjacency matrix
% the ends have degree = 1 (1 neighbor)
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

adjSum = sum(adjM);
endsI = find(adjSum==1);

end

