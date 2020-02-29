function lineSegm = removeCommonSegm(lineSegm)
%REMOVECOMMONSEGM this function first checks for the common segment/
%segments and then removes the redundant segments from the second cell
%   lineSegm should be a cell array of M cells, where M = num_of_arms - 1
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

M = length(lineSegm);

signSegm = cell(M,1);   % signatures of segments
for i = 1 : M
    for j = 1:size(lineSegm{i}, 1) - 1
        signSegm{i}(j) = sum(sum(lineSegm{i}(j:j+1,:)));
    end
end

allSegm = signSegm{1};
for i = 2 : M
    [~, ~, IB] = intersect( allSegm, signSegm{i});
    if isempty(IB) || ~ismember(1, IB)
        error('no common segment found or the first segment is not common')
    end
    lineSegm{i}(IB,:) = [];
    allSegm = union(allSegm, signSegm{i});
end