function [Signal_comp]=init_bin(conversion_index, measurement_duration_min, num_electrode)

%% Get binary file directory
fsep                = filesep;      % Get file separator depending on OS
bin_dir             = uigetdir();   % Select binary file directory
bin_files           = dir(fullfile(bin_dir, '*.bin')); % Get all binaries files in folder
nb_bin              = size(bin_files,1); % Get number of binary files in directory

%% Read binary files
if nb_bin >= 1
    for i=1:nb_bin
        fprintf(sprintf("[Loading] : %s", bin_files(i).name));
        fpath = sprintf("%s%s%s", bin_files(i).folder, fsep, bin_files(i).name);
        measurement_duration_ms = measurement_duration_min*60*1000;
        [Signal] = binshort2signal(fpath,measurement_duration_ms, num_electrode, conversion_index);
        Signal_comp{i, 1} = Signal;
        Signal_comp{i, 2} = bin_files(i).name;
    end
else
    disp ('No .bin files in folder')
end

end