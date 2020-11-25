%%
clear all
clc
close all

A = load('/run/media/rbeaubois/JUZO/Etudes/PHD/mat/exp1/20201028_17h06m09s_validopenloop_1.mat');

nb_row = 8;
nb_col = 8;

for i = 1 : 64
    subplot(nb_row, nb_col, i);
    plot(A.Signal(:,1)/1e3, A.Signal(:,i+1));
    title(sprintf('%d', i));
    xlabel('Time (s)');
    ylabel('Amplitude (mV)');
    % add titles for axis,figure,plot, ... cf plot2D in matlab help
end

%%
    i = 21
    plot(A.Signal(:,1)/1e3, A.Signal(:,i+1));
    title(sprintf('%d', i));
    xlabel('Time (s)');
    ylabel('Amplitude (mV)');

