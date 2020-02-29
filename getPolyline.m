function [polyline] = getPolyline(frame)
% It asks from the user to draw a series of polylines on top of a frame
%   It returns a cell array of polylines
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

N = input('Give number of arms in the maze: ');
M = N - 1;

% cell array of M polylines
polyline= cell(1,M);


for i = 1:M 
    imshow(frame)
    title(num2str(i))   
    if i==1
        h(i) = impoly(gca,[],'Closed',false);
    else
        h(i) = impoly(gca,polyline{i-1},'Closed',false);
        input('Press any key when you are done...');
    end
    polyline{i} = getPosition(h(i));
    close
end


end

