function demoProjection(polyline,frame)
% this is obsolete
% it was used with pointerMove function to demonstrate the projection on
% the line segments
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

h = imshow(frame);
set(gcf, 'WindowButtonMotionFcn', @pointerMove);

h.UserData = polyline;

end

