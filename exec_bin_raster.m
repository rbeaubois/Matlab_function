function exec_bin_raster(num_electrode, measurement_duration_min)

%% Get binary file and parameters through hdr file
% Select binary file
    [bin_file, bin_dir] = uigetfile('*.bin');       % Select binary file
    bin_fpath = sprintf("%s%s",bin_dir,bin_file);   % File path
    fprintf(sprintf("[Loading] : %s", bin_file));   % Display file selected
    
% Get parameters from hdr files
    [~, fname_no_ext, ~] = fileparts(bin_fpath);
    hdr_dir             = bin_dir;   % .hdr and .bin files in same directory
    hdr_fpath           = sprintf("%s%s.hdr", hdr_dir, fname_no_ext);

    hdr_fid             = fopen(hdr_fpath);
    file_format         = sscanf(fgetl(hdr_fid), "File Format Version, %d");
    session_start       = sscanf(fgetl(hdr_fid), "Session Start Time, %s");
    sampling_freq       = sscanf(fgetl(hdr_fid), "Sampling freq (Hz), %d");
    conv_factor         = sscanf(fgetl(hdr_fid), "Conversion factor: short to mV, %lf");

    rec_param = struct(... 
    'format', file_format,...
    'start_t', session_start,...
    'Fs', sampling_freq,...
    'conv_f', conv_factor ...
    );
    
    fclose(hdr_fid);

% Load signal from binary file
    measurement_duration_ms                     = measurement_duration_min*60*1000;
    [Signal]                                    = binshort2signal(bin_fpath, measurement_duration_ms, num_electrode, rec_param.conv_f);
    [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.Fs, num_electrode, Signal);

%% Spike detection
visual_on=0;
magnification=5; % magnification *STDEV
%////////////
[All_spikes_pos, All_spikes_neg, Mean_posspks_amp, Mean_negspks_amp, Num_posspks,Num_negspks, All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes]=spike_detection(rec_param.Fs, time_ms, num_electrode, HP_Signal_fix, visual_on, magnification);

%%  Spike Raster plot
A=cell(num_electrode, 1);
for k=1:num_electrode
A{k}=rot90(All_spikes{k, 1});
end
fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = ['Spike Rastor plot'];
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

[x, y]=plotSpikeRaster(A, 'PlotType','vertline');
% plot(x, y);
%% Data

for k=1:num_electrode
    try % General and spike detection
        Data(k).Name='Signal' ;
        Data(k).Order= num2str(k);
        Data(k).Sampling_Rate= rec_param.Fs;
        Data(k).Electrode= electode_position(k);
        Data(k).LP_signal= LP_Signal_fix(:, k);
        Data(k).HP_signal= HP_Signal_fix(:, k);
        Data(k).All_spikes=All_spikes{k};
        Data(k).Interspike_interval=All_interspike_interval_sec{k};
        Data(k).Mean_interspike_interval_sec=Mean_interspike_interval_sec(k);
    catch
    end

    try % Spikes
        Data(k).Mean_negative_spike_amplitude=Mean_negspks_amp(k);
        Data(k).Mean_positice_spike_amplitude=Mean_posspks_amp(k);
        Data(k).number_of_negative_sspikes=Num_negspks(k);
        Data(k).number_of_positive_spikes=Num_posspks(k);
        Data(k).number_of_spikes=Num_posspks(k)+Num_negspks(k);
    catch
    end
 
    try % Raster of spikes
        Data(k).Spike_timing_raster=A{k}; %#ok<*SAGROW>
    catch
    end
end

save_str=num2str(Signal_comp{j, 2});
save_str = strtrim(save_str);
mat='.mat';
dta='cData_';
save_str =strcat(dta, save_str, mat);
save(save_str, 'Data');

end