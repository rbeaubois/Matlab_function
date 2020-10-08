%% Clear
clear all
close all
clc

%% Get binary files
binf_get_type = 'one';
[bin_fpath, nb_binf] = get_bin_files(binf_get_type);

%% Raster plot from binary file
trace_time      = 60;    % seconds
save_path       = uigetdir(pwd,'Select saving folder');
save_data       = false;
save_fig        = false;

save_param      = struct( ...
    'path', save_path, ...
    'data', save_data, ...
    'fig',  save_fig ...
);

% % Raster plot of one file
% if strcmp(binf_get_type, 'one')
%     bin_trace_analysis(bin_fpath, trace_time, save_param);
% % Raster plot of all files
% elseif strcmp(binf_get_type, 'all')
%     for i = 1:nb_binf
%         bin_trace_analysis(bin_fpath(i), trace_time, save_param);
%     end
% end

% Read binary file
    [Signal, fname_no_ext, rec_param]           = read_bin(bin_fpath, trace_time);   % Signals of electrodes + name of file + recording parameters

% Filter signal
    [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.fs, rec_param.nb_chan, Signal);

%% Spike detection
    visual_on=0;
    magnification=5; % magnification *STDEV

%% Compute analysis
    [All_spikes_pos, All_spikes_neg, ...
     Mean_posspks_amp, Mean_negspks_amp, ... 
     Num_posspks, Num_negspks, ...
     All_interspike_interval_sec, Mean_interspike_interval_sec, ...
     All_spikes] = spike_detection(rec_param.fs, rec_param.time_s*1e3, rec_param.nb_chan, HP_Signal_fix, visual_on, magnification);
 
 
 
 
 