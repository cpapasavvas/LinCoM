function cell_of_Cells = loadCells()
% Load a cell array with the spiketimes of the different cells


[file,path] = uigetfile('*.mat', 'Select mat file with the spiketimes');
filename = fullfile(path,file);

if ~exist(filename)
    error('no file selected')
end

load(filename)

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

