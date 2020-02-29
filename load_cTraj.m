function [cTraj, cTrajT] = load_cTraj()
% asks from the user to load a trajectory file (.mat file)
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

[file,path] = uigetfile({'*.mat'}, 'Select trajectory file');
filename = fullfile(path,file);
load(filename);
end

