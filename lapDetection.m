function [lapsActual, lapsIdeal, lapsTime] = lapDetection(uniqB, connM, endsI, commI, commitMap, dTraj, ecc, frame)
%LAPDETECTION detects the laps/runs based on the dTraj, the ends and
%commitment points
% it returns the sequence of detected runs (actual and ideal) and their
% timings
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


% squeezing the dTraj to the time of first entry to a bin
timeI = [];
for i = length(dTraj): -1 : 2
    if dTraj(i-1)== dTraj(i)
        dTraj(i)=[];
    else
        timeI = [i; timeI];
    end
end
timeI = [1; timeI];

% eccentricity of dTraj
dTraj_ecc = ecc(dTraj);

[~, peakI] = findpeaks(dTraj_ecc);
peakV = dTraj(peakI)';

% the first and last traj positions can also be considered local max
if dTraj_ecc(1) > dTraj_ecc(2)
    peakI = [1 peakI];
    peakV = [dTraj(1) peakV];
end
if dTraj_ecc(end) > dTraj_ecc(end-1)
    peakI = [peakI length(dTraj_ecc)];
    peakV = [peakV dTraj(end)];
end

% the peak points represent return points
% remove all the return points that are not part of the commitMap
peakC = commitMap(peakV);
peakI(peakC==0)=[];
peakV(peakC==0)=[];
peakC(peakC==0)=[];


% produce the peakC and remove peaks that indicate small moves back and forth
% there is a leeway parameter allowing this
leeway = 4;
for i = length(peakC)-1 : -1 : 1
    if peakC(i) == peakC(i+1) && dTraj_ecc(peakI(i)) ~= dTraj_ecc(peakI(i+1))
        minEcc = min([dTraj_ecc(peakI(i)) dTraj_ecc(peakI(i+1))]);
        minInterEcc = min(dTraj_ecc(peakI(i):peakI(i+1)));
        if minEcc - minInterEcc < leeway
            % the one which is less eccentric is removed  
            if dTraj_ecc(peakI(i)) > dTraj_ecc(peakI(i+1))
                peakC(i+1)=[];
                peakV(i+1)=[];
                peakI(i+1)=[];
            elseif dTraj_ecc(peakI(i)) < dTraj_ecc(peakI(i+1))
                peakC(i)=[];
                peakV(i)=[];
                peakI(i)=[];
            end
        end
    end
end
% further exclusion of peaks, case of three consecutive appearances of the same end 
for i = length(peakC)-2 : -1 : 1
    if peakC(i) == peakC(i+1) && peakC(i+1) == peakC(i+2)
        peakC(i+1)=[];
        peakV(i+1)=[];
        peakI(i+1)=[];
    end
end

% mark the runs
lapsActual = [];
lapsIdeal= [];
lapsT = [];
lapsTime = [];
for i = 1: length(peakC)-1
    if peakC(i) ~= peakC(i+1)
        lapsActual = [lapsActual; peakV(i) peakV(i+1)];
        lapsIdeal = [lapsIdeal; peakC(i) peakC(i+1)];
        lapsT = [lapsT; peakI(i) peakI(i+1)];                       %save discrete time
        lapsTime = [lapsTime; timeI(peakI(i)) timeI(peakI(i+1))];   %save continuous time
    end
end

disp('Laps detected')



demoFig = figure;
imshow(frame)
hold on
for i = 1: length(connM)  
    xp = uniqB([connM(i,1) connM(i,2)], 1);
    yp = uniqB([connM(i,1) connM(i,2)], 2);
    plot(xp, yp, 'ko-','MarkerSize', 11);
end
for i = endsI
    text(uniqB(i,1)+10, uniqB(i,2), num2str(i), 'Color', 'g')
end

% save figure for later, if needed
% savefig('frameLabeled.fig')

k = input('Type D for visual demonstration of the detected laps (anything else to skip): ','s');
if ~strcmp(k,'D')
    close
    return
end

% add button to break the loop, works much better in Linux rather than MSWin 
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop', ...
                         'Callback', 'delete(gcbf)');

figure(demoFig)

for i = 1: length(dTraj)
    
    % find and remove the previous scatter points
    hSc = findobj('type','scatter');
    if ~isempty('hSc')
        delete(hSc)
    end
    
    % scatter the most eccentric bins, ends of tracks
    scatter(uniqB(endsI,1), uniqB(endsI,2), 200, 'go')
    
    % scatter the commitment points
    scatter(uniqB(commI,1), uniqB(commI,2), 200, 'yo') 
    
    % scatter the lap trace
    currLapI = xor(i> lapsT(:,1), i> lapsT(:,2));
    currLapStartT = lapsT(currLapI,1);
    currLapTrace = dTraj(currLapStartT: i-1);
    scatter(uniqB(currLapTrace,1), uniqB(currLapTrace,2), 100, 'o','MarkerFaceColor', [0.4 0.5 1], 'MarkerEdgeColor', [0.4 0.5 1])
    
    
    % scatter the current point on the discrete trajectory
    scatter(uniqB(dTraj(i),1), uniqB(dTraj(i),2), 110, 'bo', 'filled')
    pause(0.001)
    
    if ismember(i, lapsT(:,2))
        A = lapsIdeal(currLapI,1);
        Z = lapsIdeal(currLapI,2);
        title(sprintf('Run detected ( %s -> %s ). Press enter to continue...', num2str(A), num2str(Z)))
        
        f1 = figure;
        plot(dTraj_ecc, 'k')
        hold on
        text(lapsT(currLapI,1), dTraj_ecc(lapsT(currLapI,1)), num2str(A), 'Color', 'g')
        text(lapsT(currLapI,2), dTraj_ecc(lapsT(currLapI,2)), num2str(Z), 'Color', 'g')
        plot(currLapStartT: i, dTraj_ecc(currLapStartT: i), 'b:', 'LineWidth', 3)
        ylabel('trajectory eccentricity')
        xlabel('timestep')
        title(sprintf('Run detected ( %s -> %s ). Press enter to continue...', num2str(A), num2str(Z)))
        
        set(ButtonHandle,'Enable','off')
        pause
        delete(f1)
        % break loop when button is pressed
        if ~ishandle(ButtonHandle)
            disp('Process stopped by user');
            break;
        end
        set(ButtonHandle,'Enable','on')
        title('')
    end
end

if ishandle(demoFig)
    close(demoFig)
end

end

