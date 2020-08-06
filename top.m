%--------------------------------------------------------
% Create raster plot from binary file
%   > File has to be one trace
%
%--------------------------------------------------------
%% Clear
clear all
close all
clc

%% Get binary files
binf_get_type = 'all';
[bin_fpath, nb_binf] = get_bin_files(binf_get_type);

%% Raster plot from binary file
nb_electrodes   = 64;   % number of electrodes to outputs
trace_time      = 60;    % seconds
save_path       = uigetdir(pwd,'Select saving folder');
save_data       = false;
save_fig        = true;

% Raster plot of one file
if strcmp(binf_get_type, 'one')
    exec_bin_raster(bin_fpath, nb_electrodes, trace_time, save_path, save_data, save_fig);
% Raster plot of all files
elseif strcmp(binf_get_type, 'all')
    for i = 1:nb_binf
        exec_bin_raster(bin_fpath(i), nb_electrodes, trace_time, save_path, save_data, save_fig);
    end
end
