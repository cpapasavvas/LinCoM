function [polyline] = getPolyline(frame)
% It asks from the user to draw a series of polylines on top of an image
% It returns a cell array of polylines (representing the preliminary graph)
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

N = input('Give number of ends in the maze: ');

if N < 2
    error('Number of ends cannot be less than 2')
end

% cell array of N-1 polylines
polyline= cell(1,N-1);

fprintf('\n')
disp('  - Drawing preliminary graph')
for i = 1:N-1 
    imshow(frame)  
    if i==1
        title('Trace the longest end-to-end path') 
        disp('  Place line segments to trace the longest end-to-end path')
        disp('  Left click to add node, right click to finish')
        h(i) = impoly(gca,[],'Closed',false);
    else
        h(i) = impoly(gca,polyline{i-1},'Closed',false);
        hold on
        plot(polyline{i-1}(1:2,1),polyline{i-1}(1:2,2), 'r', 'LineWidth', 2)
        hold off
        
        title('Rearrange nodes to cover the next end')
        fprintf('\n')
        disp(['  Ends remaining: ' num2str(N - i)])
        disp('  Rearrange nodes to cover the next end')
        disp('  Drag and drop nodes or remove them by right clicking on them')
        disp('  Keep the red line segment in place')
        input('  Press enter when done:');
        fprintf('\n')
    end
    polyline{i} = getPosition(h(i));
    close
end


end

