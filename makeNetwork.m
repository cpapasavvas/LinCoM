function [uniqBins, adjM, connM, distM, eccentr] = makeNetwork(binC)
%MAKENETWORK Gets one or more sequences of nodes and produces an undirected
%acyclic graph/network
%   binC is a cell array of bin sequences (repetitions expected)
%   uniqBins is the resulting set of unique bins/nodes in the network (x,y position)
%   adjM is the adjacency matrix: square matrix with binary values
%           indicating which pairs of nodes are adjacent
%   connM is the list of all the edges/connections in the network
%   distM is the distance matrix: square matrix indicating the distance
%           between each pair of nodes
%   eccentr is the eccentricity vector, eccentricity measure for each node
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

allBins = vertcat(binC{:});
uniqBins = unique(allBins,'rows','stable'); 


nBins = length(uniqBins);

adjM = zeros(nBins);
connM = [];
for i = 1:length(binC)
    for j= 1:length(binC{i})-1
        [~,I1] = ismember(binC{i}(j,:), uniqBins ,'rows');
        [~,I2] = ismember(binC{i}(j+1,:), uniqBins ,'rows');
        adjM(I1,I2) =1;
        adjM(I2,I1) =1;
        connM = [connM; I1 I2];
    end
end

if size(connM,1) ~= sum(sum(adjM))/2
    error('check the connM')
end



% concidering undirected and acyclic graph (i.e., tree)
% also assuming that the nodes in adjM are ordered in such a way that 
% for each node j>2 there is exactly one node i (where i<j) for which Aij=1
distM = zeros(size(adjM));
for i = 2:length(adjM)
    distM(i,1:i-1) = 1 + distM(adjM(i,1:i-1)==1,1:i-1);
    distM(1:i-1, i) = distM(i,1:i-1); 
end

% eccentricity is the max distance for each node
eccentr = max(distM);

end
        