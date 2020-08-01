function showPrel(polyline, frame)
%SHOWPREL presents the preliminary graph

hold off
imshow(frame)
title('preliminary graph')

for i = 1: length(polyline)
    for j= 1: size(polyline{i},1) -1
        linspaceX = linspace(polyline{i}(j,1), polyline{i}(j+1,1), 2);
        linspaceY = linspace(polyline{i}(j,2), polyline{i}(j+1,2), 2);

        hold on
        plot(linspaceX, linspaceY, 'k.-');
    end
end

fprintf('\n')
disp('Review the preliminary graph drawn')
disp('Press any key to continue')
pause
close

end

