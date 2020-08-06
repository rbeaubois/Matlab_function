function [Signal]=binshort2signal(bin_filename,measurement_duration_ms, num_electrode, conversion_index)
% Open file
fileID_bin                  = fopen(bin_filename);

% Set measurement duration
measurement_duration_data   = measurement_duration_ms*20;

% Read binary file
A = fread(fileID_bin,[num_electrode measurement_duration_data],'short', 'n');
time_temp=[measurement_duration_ms: -0.05: 0];
time = rot90(time_temp);
time(measurement_duration_ms+1, :)=[];

% Rearrange data in the variable Signal
trans_A = transpose(A);
B=trans_A*conversion_index;
Signal=horzcat(time, B);

% Close file
fclose(fileID_bin);

end