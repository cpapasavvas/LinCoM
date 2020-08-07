function dTraj = discretizeTrajSmooth(cTraj, uniqB, adjM, distM, connM, frame, rigid)
%DISCRETIZETRAJSMOOTH gets a continuous 2D trajectory and transforms it into a
%   discrete trajectory on a specific graph.
%   cTraj is the continuous trajectory
%   uniqB, adjM, distM, connM describe the graph
%   optional rigid parameter to make the dTraj rigid
%   the default is to be more smooth (less flickering between adjacent bins)
%   frame is a frame from the video, for plotting purposes
%   rigid is a binary parameter for rigid vs smoothed projection (default 0)
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

if nargin < 7
    rigid = 0 ;
end

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
        plot(xp, yp, 'bo-','MarkerSize', 11);
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

fprintf('Discretizing the trajectory')

%finding each remaining position based on the previous position and the
%current measure from videotracking
for i = 2:length(cTraj)
    prev = dTraj(i-1,:);
    current = cTraj(i,:);
    distL = pdist2(current, uniqB);
    prevF = distM(prev,:);
    if rigid
        prevF(prevF<=flex) = 1;
    else
        prevF(prevF<=flex) = 1 - 0.01*prevF(prevF<=flex);
    end
    prevF(prevF>1) = 0;
    
    conf = (1 - distL/max(distL)).* prevF;
    [~,dI] = max(conf);
    
    % the distance between the actual position and the chosen bin should
    % be well below 80 (empirical value, depends on video resolution)
    if distL(dI)> 80
        counter = counter+1;
        if counter > 10
            disp(i)
            warning('Chosen bin seems to be too far from the actual position. Consider increasing flex parameter');
        end
    else
        counter = 0;
    end
    
    % if the new bin found is not the same or adjacent to the previous one 
    % (distance>1) then find the only adjacent bin in the path from the prev to the new 
    % this implements the 'interpolation' feature
    if distM(prev,dI)>1
        % path p should be at least 3 nodes long
        p = findPath(prev, dI, adjM, distM);
        dTraj(i) = p(2);
    else
        dTraj(i) = dI;
    end

    if mod(i,round(length(cTraj)/10)) == 0
        fprintf('.')
    end
end
disp('DONE')

end

