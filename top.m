%--------------------------------------------------------
% Create raster plot from binary file
%   > File has to be one trace
%
%--------------------------------------------------------

%% Clear
    clear all
    close all
    clc

%% Path handling
    addpath('functions')

%% Get binary files
    binf_get_type = 'one';
    [bin_fpath, nb_binf] = get_bin_files(binf_get_type);

%% Analysis from binary files
    trace_time      = 60;    % seconds
    save_path       = uigetdir(pwd,'Select saving folder');
    save_data       = false;
    save_fig        = false;

    save_param      = struct( ...
        'path', save_path, ...
        'data', save_data, ...
        'fig',  save_fig ...
    );


    for i = 1:nb_binf
        bin_trace_analysis(bin_fpath(i), trace_time, save_param);
    end

