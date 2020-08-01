% Optional : set up filepaths for quick loading of the files
% Three filepaths in order: 1. maze image file
%                           2. trajectory file
%                           3. spiketimes file

if exist('filepaths.mat', 'file')
    load filepaths.mat
else
    filepaths = {[]; []; []};
end

%%
% get an image of the maze either from a movie file or an image file

disp('-- Import image of the maze --')
[obj,type]=loadVideoFile(filepaths{1});
if strcmp(type, 'video')
    brightness = 1;                 % brightness parameter
    frame=getBrightFrame(obj,brightness);     
else
    frame = obj;
end


%%
% load continuous trajectory (cTraj)
disp('-- Import trajectory --')
[cTraj, cTrajT, d99] = load_cTraj(filepaths{2});

%%
% load the spiketimes of different cells
disp('-- Import spiketimes --')
cells = loadCells(filepaths{3});


%%
% ask from the user to draw a polyline
polyline = getPolyline(frame);

% removes the common segments among the different lines
polyline = removeCommonSegm(polyline);

% show preliminary graph
showPrel(polyline, frame)


% allBins have the same cell structure as the polyline
% it's a collection of all the bins organized in line segments
% IMPROVEMENT NEEDED: compare the minimum distance between bins and the
% maximum distance recorded in the trajectory : the latter should be lower
% for more robust results
% ('fewer bins are suggested due to low sampling rate of trajectory')
allBins = discretizeMaze(polyline, frame, d99);

% make up a graph of bins
% the bins are the nodes in an undirected acyclic graph
fprintf('Making up the graph...')
[uniqB, adjM, connM, distM, ecc] = makeGraph(allBins);
disp('DONE')



%%
% find the ends of the tracks / leaves of the tree in graph theoretic terms
endsI = findEnds(adjM);

% get the commitment points in the maze
[commI, commitMap] = getCommit(uniqB, distM, endsI, ecc, adjM, frame);



%%


% transform the continuous trajectory to discrete trajectory
% the discrete trajectory is a sequence of bins in the graph
fprintf('Discretizing the trajectory...')
dTraj = discretizeTraj(cTraj, uniqB, adjM, distM, connM, frame);
disp('DONE')

% optional demonstration
demoP = input('enter y if you want to demontsrate the discretization process: ', 's');
if strcmp(demoP, 'y')
    demoDiscrProjection(uniqB,connM, dTraj,cTraj, frame);
    % Partial demo: a range of time indices can be used here, for example:
    % demoDiscrProjection(uniqB,connM, dTraj,cTraj, frame, 500:800);
end


%%
% detect the laps using the graph properties
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
[PFs, OCCUPs] = getLinearPlFields(cells, uniqPaths, seqPaths, cTrajT, lapsTime, dTraj, labels);

