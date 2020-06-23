function linearPlFieldOnMaze(uniqB, connM, uniqPaths, PlField)
%LINEARPLFIELDONMAZE Plots the linear place field on the network which is on top of the maze
%   This is for visualization purposes only, it's not a transformation to a
%   2D place field
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

c= colormap;

% scatter the placefield
% needs to be normalized so you can get a range of colours
for i = 1: length(uniqPaths)
    nPlField = round(63 * PlField{i}/max(PlField{i}));
    cMap = c(nPlField+1, :);
    
    subplot(2,2,i)
%     imshow(frame)
    hold on
    
    for j = 1: length(connM)  
        xp = uniqB([connM(j,1) connM(j,2)], 1);
        yp = uniqB([connM(j,1) connM(j,2)], 2);
        plot(xp, yp, 'ko-','MarkerSize', 15);
    end

    scatter(uniqB(uniqPaths{i},1), uniqB(uniqPaths{i},2), 100, cMap, 'filled', 's')
end

end

