function [binC] = discretizeMaze(polyline, frame, d99)
%DISCRETIZEMAZE splits the maze into bins
% the input is a cell array of polylines and a frame for plotting purposes
% outputs a cell array with the bin centers for each line segment
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

binC = cell(1,[]);
nbins = 2;
count = 1;
distCriterion = 1;
firsttime = 1;
while distCriterion
    while ~isempty(nbins)
        hold off
        imshow(frame)
        linspaceX = linspace(polyline{1}(1,1), polyline{1}(2,1), nbins);
        linspaceY = linspace(polyline{1}(1,2), polyline{1}(2,2), nbins);

        hold on
        plot(linspaceX, linspaceY, 'o-', 'MarkerSize',14);

        if firsttime
            nbins = input('give the number of bins for the track shown: ');
            firsttime = 0;
        else
            nbins = input('Press enter to continue or enter another number to change: ');
        end


    end

    binC{count} = [linspaceX' linspaceY'];
    binsize = pdist(binC{1}(1:2,1:2));

    if 1.5* binsize > d99
        distCriterion = 0;
    else
        disp('WARNING: Bin size too small for such coarse trajectory')
        disp('         Try a lower number of bins')
        nbins = 2;
        binC = cell(1,[]);
        firsttime = 1;
    end
end

count= count + 1;

imshow(frame)
hold on
for i = 1: length(polyline)
    for j= 1: size(polyline{i},1) -1
        
        segmL = pdist(polyline{i}(j:j+1,:));
        nbins = round(segmL/ binsize)+1;
        
        linspaceX = linspace(polyline{i}(j,1), polyline{i}(j+1,1), nbins);
        linspaceY = linspace(polyline{i}(j,2), polyline{i}(j+1,2), nbins);
        plot(linspaceX, linspaceY, 'o-', 'MarkerSize',14);
        
        % skipping the first case because it is already counted
        if i==1 && j==1
            continue;
        end
        
        binC{count} = [linspaceX' linspaceY'];
        count = count + 1;
    end
end
    
close
end

