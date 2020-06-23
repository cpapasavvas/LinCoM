function demoDiscrProjection(uniqB,connM, dTraj,cTraj, frame, range)
%DEMODISCRPROJECTION Demonstrates the projection of the actual position to 
% to the closest bin and the resulting discrete trajectory
%   range (optional) should be an explicit range of indices, e.g. 300:400 
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

if nargin < 6
    range = 1:length(cTraj);
elseif range(1) < 1 || range(end) > length(cTraj)
    range = intersect(range, 1:length(cTraj));
end
    
if length(range) ~= length(cTraj)
    fprintf('press any key to start the projection demo from timestep %d to %d\n',range(1),range(end));
    pause
end


imshow(frame)
hold on

for i = 1: length(connM)  
    xp = uniqB([connM(i,1) connM(i,2)], 1);
    yp = uniqB([connM(i,1) connM(i,2)], 2);
    plot(xp, yp, 'ko-','MarkerSize', 15);
end

ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop', ...
                         'Callback', 'delete(gcbf)');
                     
for i = range
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
    
    % find and remove the previous scatter points
    hSc = findobj('type','scatter');
    if ~isempty('hSc')
        delete(hSc)
    end
    
    scatter(uniqB(dTraj(i),1), uniqB(dTraj(i),2), 150, 'bo', 'filled')
    scatter(cTraj(i,1), cTraj(i,2), 'x', 'r')
    pause(0.01)
end


end

