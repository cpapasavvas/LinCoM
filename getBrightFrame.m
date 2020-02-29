function [img_def] = getBrightFrame(VideoObj, brightFactor)
% Asks from the user to open a movie and returns the first
% frame of the movie
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


if nargin < 2
    brightFactor = 1;
end

VideoObj.CurrentTime = 0;

img_def = brightFactor * rgb2gray(readFrame(VideoObj));
end

