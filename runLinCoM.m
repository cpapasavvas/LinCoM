%%
% get an image of the maze either from a movie or an image or a saved 
% frame.mat file.
% the movie should be the same as the one on which videotracking was
% applied for the extraction of trajectory.

[obj,type]=loadVideoFile;
if strcmp(type, 'video')
    brightness = 1;                 % brightness parameter
    frame=getBrightFrame(obj,brightness);     
else
    frame = obj;
end

% load continuous trajectory (cTraj)
[cTraj, cTrajT] = load_cTraj;

%%
% ask from the user to draw a polyline
polyline = getPolyline(frame);

% removes the common segments among the different lines
polyline = removeCommonSegm(polyline);

% allBins have the same cell structure as the polyline
% it's a collection of all the bins organized in line segments
% IMPROVEMENT NEEDED: compare the minimum distance between bins and the
% maximum distance recorded in the trajectory : the latter should be lower
% for more robust results
% ('fewer bins are suggested due to low sampling rate of trajectory')
allBins = discretizeMaze(polyline, frame);

% make up a network/graph of bins
% the bins are the nodes in an undirected acyclic graph/network
fprintf('Making up the graph...')
[uniqB, adjM, connM, distM, ecc] = makeNetwork(allBins);
disp('DONE')



%%
% find the ends of the tracks / leaves of the tree in graph theoretic terms
endsI = findEnds(adjM);

% get the commitment points in the maze
[commI, commitMap] = getCommit(uniqB, distM, endsI, ecc, adjM, frame);



%%


% transform the continuous trajectory to discrete trajectory
% the discrete trajectory is a sequence of bins in the network
fprintf('Discretizing the trajectory...')
dTraj = discretizeTraj(cTraj, uniqB, adjM, distM, connM, frame);
disp('DONE')

% optional demonstration
demoP = input('enter y if you want to demontrate the discretization result: ', 's');
if strcmp(demoP, 'y')
    demoDiscrProjection(uniqB,connM, dTraj,cTraj, frame);
    % a range of time indices can be used here, for example:
    % demoDiscrProjection(uniqB,connM, dTraj,cTraj, frame, 500:800);
end


%%
% detect the laps using the network properties
[lapsActual, lapsIdeal, lapsTime] = lapDetection(uniqB, connM, endsI, commI, commitMap, dTraj, ecc, frame);


% check consistency of the laps and find the unique paths/runs and their
% sequence. Label the unique paths/runs
[uniqPaths, seqPaths, labels] = findUniqPaths(lapsActual, lapsIdeal, adjM, distM);
close

% lapsTime indicate the first timepoint entered in a bin
% Fixing inaccuracy with the first and last bin:
lapsTime = fixLapsTime(lapsTime,lapsActual, dTraj);

% plot the detected laps with their labels
plotLapsInTime(uniqPaths, seqPaths, lapsIdeal, lapsTime, dTraj, ecc, cTrajT, labels)


%%
% calculate and plot the place fields for specific cells

% load the spiketimes of different cells
disp('Choose a mat file with the spiketimes of the cells')
cells = loadCells;
[PFs, OCCUPs] = getLinearPlFields(cells, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj, labels);

