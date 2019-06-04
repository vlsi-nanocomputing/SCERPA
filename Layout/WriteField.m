function [ output_args ] = Untitled4( input_args )
%UNTITLED4 Summary of this function goes here
%   write 1st degree interpolation field on the .txt files
%% Import the width
[~, ~, raw] = xlsread('.\Electrode_Settings.xlsx','Sheet1','B3:B3');

%% Create output variable
Electrode_space = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw;

%% Import the gap
[~, ~, raw] = xlsread('.\Electrode_Settings.xlsx','Sheet1','B5:B5');

%% Create output variable
electrode_head_margin = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw;

[~, ~, raw] = xlsread('.\Electrode_Settings.xlsx','Sheet1','B6:B6');

%% Create output variable
electrode_tail_margin = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw;
%% Compute actual field
electrode_gap=electrode_tail_margin+electrode_head_margin;

gap_map=[2 10 20];
[c index] = min(abs(gap_map-electrode_gap));

filename=
end

