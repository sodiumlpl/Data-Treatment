%% Clear Matlab

clear classes
close all
clc

%% Create Acquisition class

test_treatment = Treatment.Treatment;

%% start GUI

test_treatment.treatment_main_gui;

%%

delete(test_treatment)