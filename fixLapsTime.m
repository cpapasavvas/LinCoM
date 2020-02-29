function lapsTime = fixLapsTime(lapsTime,lapsActual, dTraj)
%FIXLAPSTIME fixes inaccuracies in lapsTime
% considering that lapsTime indicate the first timepoint entered in a bin,
% there is a problem with the last bin and first bin in a run. The stay in
% the last bin has duration 0 and the stay in the first bin is
% overestimated. This is fixed here
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019

for i = 1: size(lapsTime,1)
    counter = 0;
    while lapsActual(i,1) == dTraj(lapsTime(i,1) + counter)
        counter = counter + 1;
    end
    if counter == 0
        error('Mismatch between laps and dTraj')
    end
    lapsTime(i,1) = lapsTime(i,1) + floor(counter/2);
    
    counter = 0;
    while lapsTime(i,2) + counter <= length(dTraj) ... 
            && lapsActual(i,2) == dTraj(lapsTime(i,2) + counter)
        counter = counter + 1;
    end
    if counter == 0
        error('Mismatch between laps and dTraj')
    end
    lapsTime(i,2) = lapsTime(i,2) + floor(counter/2);
end

end

