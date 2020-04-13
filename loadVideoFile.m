function [returnObj, type] = loadVideoFile()
% Loading a video or image file
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

videoExts = {'*.mpg'; '*.mpeg'; '*.avi'; '*.divx'};
imExts = {'*.bmp'; '*.jpg'; '*.jpeg'; '*.png'};

[file,path] = uigetfile([videoExts ; imExts], 'Select video or image file');
filename = fullfile(path,file);

if ~exist(filename)
    error('no file selected')
end

for i =1 :length(videoExts)
    videoExts{i}(1)=[];
end
for i =1 :length(imExts)
    imExts{i}(1)=[];
end


[~,~,ext] = fileparts(filename);
switch ext
    case videoExts
        returnObj= VideoReader(filename);
        type = 'video';
        return
    case imExts
        returnObj = imread(filename);
        type = 'image';
        return
end

error('no compatible file selected')

end

