function [commitI] = getCommitFig(uniqB, connM, endsI, frame)
%GETCOMMITFIG supporting function for the selection of the commitment
%points
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

%   the user is asked to choose commitment nodes using a labelled plot of the network 
imshow(frame)
hold on

for i = 1: length(connM)  
    xp = uniqB([connM(i,1) connM(i,2)], 1);
    yp = uniqB([connM(i,1) connM(i,2)], 2);
    plot(xp, yp, 'ks-','MarkerSize', 15);
end

for i =1: length(uniqB)
    text(uniqB(i,1), uniqB(i,2), num2str(i), 'Color','y')
end

% scatter the most eccentric bins, ends of tracks
scatter(uniqB(endsI,1), uniqB(endsI,2), 200, 'gs')

commitI = input(sprintf('Give the commitment points for the ends [%s] (use the same vector format): ', num2str(endsI)));

close all
end

