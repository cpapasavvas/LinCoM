function [firingR, occup] = linearPlField(frameR, spikesT, uniqPaths, seqPaths, cT, lapsTd, dTraj)
%LINEARPLFIELD Produces the linear place field for a specific cell
%   It receives the cellID, the cluster of the cell, the detected runs and
%   the discrete trajectory to produce the linear place field.
%   It also recieves a binary parameter for plotting the results or not
%   It returns the linear place field vector (firingR) and the occupation
%   vector alongside the coefficient of variation and spatial info metrics
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


% transform discrete time to continious 
% the spike times are expected in continious time
lapsTc = cT(lapsTd);

% classify the spike trains and trajectories to the unique paths
% spikesTL has all the spikes sorted in all the individual runs
% dTraL has the sequencs of positions dTraj for all individual runs
% spikeTU has all the spikes from spikeTL organized in the unique runs
% dTrajU has all the dTraj sequences organized in the unique runs
spikesTL = cell(size(lapsTc,1),1);
dTrajL = cell(size(lapsTc,1),1);
for i =1 : size(lapsTc,1)
    spikesTL{i} = spikesT(spikesT > lapsTc(i,1) & spikesT < lapsTc(i,2))';
    dTrajL{i} = dTraj(lapsTd(i,1): lapsTd(i,2))';
end
spikesTU = cell(length(uniqPaths),1);
dTrajU = cell(length(uniqPaths),1);
for i =1 : length(uniqPaths)
    spikesTU{i} = [spikesTL{ seqPaths == i }];
    dTrajU{i} = [dTrajL{ seqPaths == i }];
end

% remove everything that is outside of the path
% calculate occupancy for each unique path
% this needs to be in seconds (videotracking frame rate used) 
occup = cell(length(uniqPaths),1);
for i =1 : length(dTrajU)
    dTrajU{i}(~ismember(dTrajU{i},uniqPaths{i}))=[];
    
    % using categorical arrays
    % excluding spikes when speed is zero? not yet implemented
    occup{i} = histcounts(categorical(dTrajU{i}), categorical(uniqPaths{i})) / frameR;
end


% how many spikes are rec for each bin in each unique path
% I need to exclude the spikes recorded outside the unique path
spikeBins = cell(size(spikesTU));
spikeCount = cell(size(spikesTU));
for i = 1: length(spikesTU)
    spikeBins{i} = zeros(size(spikesTU{i}));
    for j = 1: length(spikesTU{i})
        [~, k] = min(abs(cT-spikesTU{i}(j)));       % closest traj timepoint
        % k = find(cT<spikesTU{i}(j), 1, 'last');   % alternative: previous traj timepoint
        spikeBins{i}(j) = dTraj(k);
    end
    spikeCount{i} =  histcounts(categorical(spikeBins{i}), categorical(uniqPaths{i}));
end

% calc firing rate
firingR = cell(length(spikesTU),1);
for i = 1: length(spikesTU)
    firingR{i} = spikeCount{i}./occup{i};
    firingR{i}(isnan(firingR{i}))=0;
end


end

