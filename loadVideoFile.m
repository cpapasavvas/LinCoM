function [videoObj] = loadVideoFile()
% Loading a video file; 4 specific file types as options
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


[file,path] = uigetfile({'*.mpg'; '*.mpeg'; '*.avi'; '*.divx'}, 'Select video file');
filename = fullfile(path,file);

videoObj= VideoReader(filename);

end

