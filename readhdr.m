%%
clear all
close all
clc

%% hdr_dir is usually bin_dir so just a variable copy is fine

hdr_dir             = uigetdir();   % Select binary file directory
hdr_files           = dir(fullfile(hdr_dir, '*.hdr')); % Get all binaries files in folder
fpath               = sprintf("%s%s%s",hdr_files(1).folder, filesep, hdr_files(1).name);

fid                 = fopen(fpath);

file_format         = sscanf(fgetl(fid), "File Format Version, %d");
session_start       = sscanf(fgetl(fid), "Session Start Time, %s");
sampling_freq       = sscanf(fgetl(fid), "Sampling freq (Hz), %d");
conv_factor         = sscanf(fgetl(fid), "Conversion factor: short to mV, %lf");

rec_param = struct(... 
'format', file_format,...
'start_t', session_start,...
'sample_f', sampling_freq,...
'conv_f', conv_factor ...
);




