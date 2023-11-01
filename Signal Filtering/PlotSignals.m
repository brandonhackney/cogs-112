%% Section 1 - generating a test signal
% We will generate three different waves and combine them into one
% We will then try to filter one of these waves out of the compound wave
clear; clc; close all;

% First, pick three different frequencies (in Hz)
% frequencies(1) = 0.1;
frequencies(1) = 0.025;
frequencies(2) = 5;
frequencies(3) = 15;

% This is the temporal resolution of the output signal
% It's how many times per second you take a sample
% The theoretical maximum frequency you can detect is half the sample rate
% For fMRI data, the SR is 1/TR, so usually 0.33.
% But... just keep 8000 for now.
sampleRate = 8000; % don't touch just yet

% This generates a compound wave from your three frequencies
% and plots the whole process for transparency
[y,x] = complexSignal(frequencies, sampleRate);


%% Section 2 - filtering your compound signal

% Pick one of three options: lowpass, highpass, or bandpass
% Lowpass keeps low frequencies and cuts out higher frequencies
% Highpass keeps high frequencies and cuts out lower frequencies
% Bandpass keeps everything between 2 frequencies and cuts everything else
filterType = 'highpass';

% Also pick the cutoff frequency for the filter
% e.g. a highpass with a cutoff of 5 Hz will remove anything 5 Hz or lower
% A lowpass with a cutoff of 500 Hz will remove anything >= 500 Hz
% A bandpass of [40 60] removes anything below 40 and above 60
% Try playing around with these values to get a sense for what they do
cutoff = 5;


% Now I'll run the filter, showing the input, the output, and difference
filterComplexSignal(y,x,sampleRate, filterType, cutoff);


%% Section 3 - Do it again with something that looks like MRI data

% Generate a predicted signal
% Corrupt it with noise and some other signals (multiple freqs & amps)

% Use the filtering techniques we normally run:
% Highpass at 1Hz to cut out scanner drift
% ...a lowpass of some sort?