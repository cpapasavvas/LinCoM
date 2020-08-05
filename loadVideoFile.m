function [returnObj, type, fp] = loadVideoFile(fp)
% Loading a video or image file
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


imExts = {'*.bmp'; '*.jpg'; '*.jpeg'; '*.png'};
videoExts = {'*.mpg'; '*.mpeg'; '*.avi'; '*.divx'};
    
if isempty(fp)
    disp('Choose an image or video file...')
    fprintf('\n')
    [file,path] = uigetfile([imExts ;videoExts ], 'Select video or image file');
    fp = fullfile(path,file); 
else
    disp('Loading preselected image or video file...')
    fprintf('\n')
end

if ~exist(fp, 'file')
    error('no file selected')
end

for i =1 :length(videoExts)
    videoExts{i}(1)=[];
end
for i =1 :length(imExts)
    imExts{i}(1)=[];
end


[~,~,ext] = fileparts(fp);
switch ext
    case videoExts
        returnObj= VideoReader(fp);
        type = 'video';
        return
    case imExts
        returnObj = imread(fp);
        type = 'image';
        return
end

error('no compatible file selected')

end

