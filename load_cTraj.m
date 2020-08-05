function [cTraj, cTrajT, D99, fp] = load_cTraj(fp)
% Asks from the user to load a trajectory file (.mat file)
% The mat file is expected to include a Tx2 matrix (double or 
% single; (X,Y) coordinates for T timepoints)
% which will serve as the continious trajectory cTraj.
% An optional Tx1 vector will be considered to be the time vector of the
% trajectory (cTrajT). This time vector relates with the spiketimes 
% recorded. If none is found then the vector 1:T is used instead.
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


if isempty(fp)
    disp('Choose a mat file...')
    fprintf('\n')
    [file,path] = uigetfile({'*.mat'}, 'Select trajectory file');
    fp = fullfile(path,file);
else
    disp('Loading preselected trajectory file...')
    fprintf('\n')
end

if ~exist(fp, 'file')
    error('no file selected')
end

load(fp);
var_struct = whos;
classes = {var_struct.class};

IND1 = strcmp(classes,'double');
IND2 = strcmp(classes,'single');
IND = IND1 | IND2;


var_struct_sub = var_struct(IND);

% identify trajectory variable
L=0;
for i =1 : length(var_struct_sub)
    currVar = eval(var_struct_sub(i).name);
    if min(size(currVar)) == 2 && numel(currVar)>100
        if size(currVar,2)==2
            cTraj = currVar;
        else
            cTraj = currVar';
        end
        L = length(currVar);
        break
    end
end

% 99th percentile of euclidean distances in the trajectory
DX = diff(cTraj);
D99 = prctile(sqrt(DX(:,1).^2 + DX(:,2).^2), 99);

% identify trajectory timestamps
if L
    for i =1 : length(var_struct_sub)
        currVar = eval(var_struct_sub(i).name);
        if min(size(currVar))==1 && numel(currVar)==L && issorted(currVar)
            if size(currVar,2) == 1
                cTrajT = currVar;
            else
                cTrajT = currVar';
            end
            return
        end
    end
    cTrajT = (1:L)';
else
    error('no compatible trajectory variable found in the loaded mat file')
end

end

