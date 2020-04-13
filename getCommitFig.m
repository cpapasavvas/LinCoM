function [commitI] = getCommitFig(uniqB, distM, adjM, endsI, frame)
%GETCOMMITFIG supporting function for the selection of the commitment
%points
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

%   the user is asked to choose commitment nodes using a labelled plot of the network 
im1 = figure(1);
im2 = imshow(frame);
im1.WindowButtonMotionFcn = {@mouseMove };
hold on

% for i = 1: length(connM)  
%     xp = uniqB([connM(i,1) connM(i,2)], 1);
%     yp = uniqB([connM(i,1) connM(i,2)], 2);
%     plot(xp, yp, 'ks-','MarkerSize', 15);
% end

plot(uniqB(:,1), uniqB(:,2), 'ks','MarkerSize', 15);

% for i =1: length(uniqB)
%     text(uniqB(i,1), uniqB(i,2), num2str(i), 'Color','y')
% end

% scatter the most eccentric bins, ends of tracks
scatter(uniqB(endsI,1), uniqB(endsI,2), 200, 'gs');

% set(gcf, 'WindowButtonMotionFcn', @mouseMove);


% inStruct.uniqB = uniqB; 
% inStruct.distM = distM; 
% inStruct.adjM = adjM; 

commitI = zeros(size(endsI));
for i = 1: length(endsI)
    endI = endsI(i); 
    clickedBin = 0;
    while commitI(i)==0        
        pause(0.5)
        commitI(i) = clickedBin;
    end
end
close all

    function mouseMove(object, eventdata)

        scatterHandles = findobj('type', 'Scatter');
        if ~isempty(scatterHandles)
            delete(scatterHandles)
        end    

        C = get(gca, 'CurrentPoint');
        D = pdist2(C(1,1:2), uniqB);
        [minD,minI] = min(D);

        if minD<10
            p1 = findPath(endI, minI, adjM, distM);
            im3 = scatter(uniqB(p1,1), uniqB(p1,2), 'k');
            im3.ButtonDownFcn = {@ButtonDownFcn };
            currentI = minI;
        end
        
        function ButtonDownFcn(object, eventdata)
                clickedBin = currentI;
        end
    
    end


end


