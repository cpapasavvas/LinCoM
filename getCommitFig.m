function [commitI] = getCommitFig(uniqB, distM, adjM, endsI, frame)
%GETCOMMITFIG supporting function for the selection of the commitment
% points
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019
 
im1 = figure(1);
imshow(frame)
im1.WindowButtonMotionFcn = {@mouseMove };
hold on

% for i = 1: length(connM)  
%     xp = uniqB([connM(i,1) connM(i,2)], 1);
%     yp = uniqB([connM(i,1) connM(i,2)], 2);
%     plot(xp, yp, 'bo-','MarkerSize', 11);
% end

plot(uniqB(:,1), uniqB(:,2), 'bo','MarkerSize', 11);


commitI = zeros(size(endsI));
for i = 1: length(endsI)
    fprintf(' Choose commitment subgraph for the end shown...')
    
    endI = endsI(i); 
    clickedBin = 0;
    
    scatter(uniqB(endI,1), uniqB(endI,2), 200, 'go');
    % text(uniqB(endI,1), uniqB(endI,2), num2str(endI), 'Color','b')
        
    while commitI(i)==0        
        pause(0.5)
        commitI(i) = clickedBin;
    end
    disp('DONE')
end
close all

    function mouseMove(~, ~)

        scatterHandles = findobj('type', 'Scatter');
        scatter(uniqB(endI,1), uniqB(endI,2), 200, 'go');
        % text(uniqB(endI,1), uniqB(endI,2), num2str(endI), 'Color','b')
       
        if ~isempty(scatterHandles)
            delete(scatterHandles)
        end    

        C = get(gca, 'CurrentPoint');
        D = pdist2(C(1,1:2), uniqB);
        [minD,minI] = min(D);

        if minD<10
            p1 = findPath(endI, minI, adjM, distM);
            im3 = scatter(uniqB(p1,1), uniqB(p1,2), 'r');
            im3.ButtonDownFcn = {@ButtonDownFcn };
            currentI = minI;
        end
        
        function ButtonDownFcn(~, ~)
                clickedBin = currentI;
        end
    
    end


end


