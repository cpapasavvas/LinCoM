function [cell_of_Cells, fp] = loadCells(fp)
% Load a cell array with the spiketimes of the different cells


if isempty(fp)
    disp('Choose a mat file...')
    fprintf('\n')
    [file,path] = uigetfile('*.mat', 'Select mat file with the spiketimes');
    fp = fullfile(path,file);
else
    disp('Loading preselected spiketimes file...')
    fprintf('\n')    
end

if ~exist(fp, 'file')
    error('no file selected')
end

load(fp)

var_struct = whos;
classes = {var_struct.class};

IND1 = strcmp(classes,'cell');

var_struct_sub = var_struct(IND1);

for i =1 : length(var_struct_sub)
    currVar =  eval(var_struct_sub(i).name);
    if size(currVar,2) == 1
        cell_of_Cells = currVar;
        return
    end
    if size(currVar,1) == 1
        cell_of_Cells = currVar';
        return
    end
end

error('no cell array found')
end

