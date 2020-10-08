%--------------------------------------------------------
% Read binary file with NEA layout
%   > File has to be one trace
%
%--------------------------------------------------------

%% Clear
clear all   % Clear all workspace
close all   % Close all windows
clc         % Clear command window

%% Get binary files
binf_get_type = 'one';
[bin_fpath, nb_binf] = get_bin_files(binf_get_type);

%% Raster plot from binary file
trace_time      = 1;    % seconds
save_path       = uigetdir(pwd,'Select saving folder');
save_data       = false;
save_fig        = false;

save_param      = struct( ...
    'path', save_path, ...
    'data', save_data, ...
    'fig',  save_fig ...
);

% Raster plot of one file
if strcmp(binf_get_type, 'one')
    exec_bin_raster(bin_fpath, trace_time, save_param);
% Raster plot of all files
elseif strcmp(binf_get_type, 'all')
    for i = 1:nb_binf
        exec_bin_raster(bin_fpath(i), trace_time, save_param);
    end
end