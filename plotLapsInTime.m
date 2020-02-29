function plotLapsInTime(uniqPaths, seqPaths, lapsIdeal, lapsTime, dTraj, ecc, cTrajT, labels)
%PLOTLAPSINTIME plotting the different runs in time alongside their labels
%
% Written by:
% Christoforos A Papasavvas 
% Yale School of Medicine
% Feb 2019


% eccentricity of dTraj
dTraj_ecc = ecc(dTraj);

% make up the title text
load('colorM.mat')
colorM = colorM/255;
titleTxt = cell(size(uniqPaths));
for i= 1: length(uniqPaths)
    [~,mI] = min( abs(uniqPaths{i}(1) - lapsIdeal(:)));
    A = lapsIdeal(mI);
    [~,mI] = min( abs(uniqPaths{i}(end) - lapsIdeal(:)));
    Z = lapsIdeal(mI);
    ctext = sprintf('{%f %f %f}', colorM(i,:));
    titleTxt{i} = ['\color[rgb]' ctext labels{i} ' : ' num2str(A) '->' num2str(Z)];
end

plot(cTrajT, dTraj_ecc, 'k')
hold on

for i = 1: length(lapsTime)
    A = lapsIdeal(i,1);
    Z = lapsIdeal(i,2);
    cI = mod(seqPaths(i), size(colorM,1));
    plot(cTrajT(lapsTime(i,1):lapsTime(i,2)), dTraj_ecc(lapsTime(i,1):lapsTime(i,2)), 'Color', colorM(cI,:))
    text(cTrajT(lapsTime(i,1)), dTraj_ecc(lapsTime(i,1))+0.05+0.5*rand, num2str(A), 'Color', colorM(cI,:))
    text(cTrajT(lapsTime(i,2)), dTraj_ecc(lapsTime(i,2))+0.05+0.5*rand, num2str(Z), 'Color', colorM(cI,:))
end
hold off
title(titleTxt, 'Interpreter','tex')
xlabel('time (s)')
ylabel('trajectory eccentricity')


end

