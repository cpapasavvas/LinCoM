%%
% get an image of the maze either from a movie or an image or a saved 
% frame.mat file.
% the movie should be the same as the one on which videotracking was
% applied for the extraction of trajectory.
loadP = input('enter y to get a frame from a movie or an image: ', 's');
if strcmp(loadP, 'y')
    [obj,type]=loadVideoFile;
    if strcmp(type, 'video')
        brightness = 1;                 % brightness parameter
        frame=getBrightFrame(obj,brightness);     
    else
        frame = obj;
    end
    
    saveP = input('enter y if you want to save the frame for later: ', 's');
    if strcmp(saveP, 'y')
        save frame.mat frame
        disp('frame.mat saved')
    end
else
    disp('Loading an already saved frame from the current directory instead')
    load('frame.mat')
end

%%
% ask from the user to draw a polyline
polyline = getPolyline(frame);

% removes the common segments among the different lines
polyline = removeCommonSegm(polyline);

% allBins have the same cell structure as the polyline
% it's a collection of all the bins organized in line segments
allBins = discretizeMaze(polyline, frame);

% make up a network/graph of bins
% the bins are the nodes in an undirected acyclic graph/network
fprintf('Making up the network...')
[uniqB, adjM, connM, distM, ecc] = makeNetwork(allBins);
disp('DONE')

% save progress
saveP = input('enter y if you want to save progress: ', 's');
if strcmp(saveP, 'y')
    save Network.mat uniqB adjM connM distM ecc
    disp('Network.mat saved')
end

%%
% find the ends of the tracks / leaves of the tree in graph theoretic terms
endsI = findEnds(adjM);

% get the commitment points in the maze
[commI, commitMap] = getCommit(uniqB, distM, endsI, ecc, adjM, frame);

% save progress
saveP = input('enter y if you want to save progress: ', 's');
if strcmp(saveP, 'y')
    save commitMap.mat commI commitMap endsI
    disp('commitMap.mat saved')
end


%%
% load continuous trajectory (cTraj)
[cTraj, cTrajT] = load_cTraj;

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

% save progress
saveP = input('enter y if you want to save progress: ', 's');
if strcmp(saveP, 'y')
    save Traj.mat dTraj cTraj cTrajT
    disp('Traj.mat saved')
end


%%
% detect the laps using the network properties
[lapsActual, lapsIdeal, lapsTime] = lapDetection(uniqB, connM, endsI, commI, commitMap, dTraj, ecc, frame);


% check consistency of the laps and find the unique paths/runs and their
% sequence. Label the unique paths/runs
if exist('frameLabeled.fig','file')
    openfig('frameLabeled.fig');
end
[uniqPaths, seqPaths, labels] = findUniqPaths(lapsActual, lapsIdeal, adjM, distM);
close

% lapsTime indicate the first timepoint entered in a bin
% Fixing inaccuracy with the first and last bin:
lapsTime = fixLapsTime(lapsTime,lapsActual, dTraj);

% plot the detected laps with their labels
plotLapsInTime(uniqPaths, seqPaths, lapsIdeal, lapsTime, dTraj, ecc, cTrajT, labels)

% save progress
saveP = input('enter y if you want to save progress: ', 's');
if strcmp(saveP, 'y')
    save Laps.mat lapsActual lapsIdeal lapsTime uniqPaths seqPaths labels
    disp('Laps.mat saved')
end

%%
% calculate and plot the place fields for specific cells

% load the spiketimes of different cells
disp('Choose a mat file with the spiketimes of the cells')
cells = loadCells;
[PFs, OCCUPs] = getLinearPlFields(cells, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj, labels);

