function [path] = findPath(A, Z, adjM, distM)
%FINDPATH produce the path between nodes A and Z
%   The path is a sequence of adjacent nodes
% in every step the adjacent node chosen to be the next in the sequence is
% the one that minimizes the distance to the Z
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

curr = A;
path = [A];
while curr ~= Z
    next = find(adjM(curr,:));
    [~, p] = min(distM(next, Z));
    curr = next(p);
    path = [path curr];
end

end

