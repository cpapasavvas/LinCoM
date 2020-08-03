function dTraj = discretizeTraj(cTraj, uniqB, adjM, distM, connM, frame)
%DISCRETIZETRAJ gets a continuous 2D trajectory and transforms it into a
%   discrete trajectory on a specific graph
%   cTraj is the continuous trajectory
%   uniqB, adjM, distM, connM describe the graph
%   frame is a frame from the video, for plotting purposes
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

flex = 10;   % flexibility parameter

counter = 0;
dTraj = zeros(length(cTraj), 1);

% finding the initial position 
% this is more tricky because there is no history/previous position 
current = cTraj(1,:);
distL = pdist2(current, uniqB);
[~,dI] = sort(distL);
cand = dI(1:3);
% if the top three canditates have low adjacency in the graph, then there
% is ambiguity in the initial condition; user input is required
if adjM(cand(1),cand(2)) + adjM(cand(1),cand(3)) + adjM(cand(2),cand(3)) < 2
    imshow(frame)
    hold on
    for i = 1: length(connM)  
        xp = uniqB([connM(i,1) connM(i,2)], 1);
        yp = uniqB([connM(i,1) connM(i,2)], 2);
        plot(xp, yp, 'ko-','MarkerSize', 11);
        hold on
    end
    for i =1: 3
        text(uniqB(cand(i),1), uniqB(cand(i),2), num2str(cand(i)), 'Color','y')
    end
    userIn = input('Choose the initial position from the labelled options:  ');
    if ~ismember(userIn, cand)
        error('Unexpected input')
    else
        dTraj(1) = userIn;
    end
    close
else
    dTraj(1) = cand(1);
end

%finding each remaining position based on the previous position and the
%current measure from videotracking
for i = 2:length(cTraj)
    prev = dTraj(i-1,:);
    current = cTraj(i,:);
    distL = pdist2(current, uniqB);
    [~, next] = min(distL);
    if distM(prev,next) > flex
        next = prev;
    end
    
    % the distance between the actual position and the chosen bin should
    % be well below 80 (empirical value, depends on video resolution)
    if distL(next)> 80
        counter = counter+1;
        if counter > 10
            disp(i)
            warning('Chosen bin seems to be too far from the actual position. Consider increasing flex parameter');
        end
    else
        counter = 0;
    end
    
    % if the next bin found is not the same or adjacent to the previous one 
    % (distance>1) then choose the only adjacent bin in the path from prev to next
    % this would be the second node in the path
    % this implements the 'interpolation' feature
    if distM(prev,next)>1
        % path p should be at least 3 nodes long
        p = findPath(prev, next, adjM, distM);
        dTraj(i) = p(2);
    else
        dTraj(i) = next;
    end
    
end

end

