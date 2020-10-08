function bin_trace_analysis(bin_fpath, rec_duration_secs, save_param)

    % Read binary file
        [Signal, fname_no_ext, rec_param]           = read_bin(bin_fpath, rec_duration_secs);   % Signals of electrodes + name of file + recording parameters
    
    % Filter signal
        [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.fs, rec_param.nb_chan, Signal);
    
    %% Spike detection
        visual_on=0;
        magnification=5; % magnification *STDEV

    %////////////
        [All_spikes_pos, All_spikes_neg, Mean_posspks_amp, Mean_negspks_amp, Num_posspks,Num_negspks, All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes]=spike_detection(rec_param.fs, time_ms, rec_param.nb_chan, HP_Signal_fix, visual_on, magnification);
    
    %%  Spike Raster plot
        A=cell(rec_param.nb_chan, 1);
        for k=1:rec_param.nb_chan
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
        plot(x, y , '.');

    %% Data
    
    for k=1:rec_param.nb_chan
        try % General and spike detection
            Data(k).Name='Signal' ;
            Data(k).Order= num2str(k);
            Data(k).Sampling_Rate= Fs;
            Data(k).Electrode= electode_position(k);
            Data(k).LP_signal= LP_Signal_fix(:, k);
            Data(k).HP_signal= HP_Signal_fix(:, k);
            Data(k).All_spikes=All_spikes{k};
            Data(k).Interspike_interval=All_interspike_interval_sec{k};
            Data(k).Mean_interspike_interval_sec=Mean_interspike_interval_sec(k);
        catch
            warning('Failed to store spike detection data');
        end

        try %spike sorting
            Data(k).Ex_spikes_neg=Extracted_spikes_neg{k};
            Data(k).Ex_spikes_pos=Extracted_spikes_pos{k};
        catch
            warning('Failed to store spike sorting data');
        end

        try % Spikes
            Data(k).Mean_negative_spike_amplitude=Mean_negspks_amp(k);
            Data(k).Mean_positice_spike_amplitude=Mean_posspks_amp(k);
            Data(k).number_of_negative_sspikes=Num_negspks(k);
            Data(k).number_of_positive_spikes=Num_posspks(k);
            Data(k).number_of_spikes=Num_posspks(k)+Num_negspks(k);
        catch
            warning('Failed to store spikes data');
        end

        try %Burst detection
            Data(k).Mean_burst_frequency=Mean_burst_frequency(k);
            Data(k).All_interburst_interval_sec=All_interburst_interval_sec{k};
            Data(k).Inter_event_interval_CV=CV(k);
        catch
            warning('Failed to store burst detection data');
        end

        try % Avalanche
            Data(k).Avalanches_probability=Avalanches_probability;
            Data(k).Avalanches_def_ms=def_avalanch_ms;
        catch
            warning('Failed to store avalanche data');
        end
        
        try % Raster of spikes
            Data(k).Spike_timing_raster=A{k}; %#ok<*SAGROW>
            warning('Failed to store raster data');
        catch
        end
    end
    
    % Save results
        if save_param.data
            save_str=num2str(Signal);
            save_str = strtrim(save_str);
            mat='.mat';
            dta='cData_';
            save_str =strcat(dta, save_str, mat);
            save(save_str, 'Data');
        end
        
        if save_param.fig
            fig_path = sprintf("%s%s%s.fig", save_param.path, filesep, fname_no_ext);
            savefig(fig1,fig_path);
            jpg_path = sprintf("%s%s%s.jpg", save_param.path, filesep, fname_no_ext);
            saveas(fig1,jpg_path);
            close(fig1)
        end    
    
end