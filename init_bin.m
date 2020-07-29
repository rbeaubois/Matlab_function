 function [Signal_comp]=init_bin(conversion_index, measurement_duration_min, num_electrode)
currentFolder = pwd;
% mkdir Analyzing_data
MyFolderInfo = dir; 

%% bin reading
list_bin = ls('*.bin');
bin_file_number=size(list_bin, 1);

if 1 <= bin_file_number
     for i=1:bin_file_number
           disp ('loding');
           disp (list_bin(i, :));
           
          bin_filename=[currentFolder, '\', list_bin(i, :)];
          measurement_duration_ms=measurement_duration_min*60*1000;
         [Signal]=binshort2signal(bin_filename,measurement_duration_ms, num_electrode, conversion_index);
         Signal_comp{i, 1}=Signal;
         Signal_comp{i, 2}=list_bin(i, :);
     end
else
     
    disp ('OK')
end

 end