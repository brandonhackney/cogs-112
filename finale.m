% Setup
addpath('Convolution');
addpath('Signal Filtering');

% constants
duration = 60*3; % 3-minute signal
sr = 800; % Hz

% Generate test signal
[y,x] = predictedSignal(duration, sr);
% Corrupt with noise
freqs = [.003, 1/duration, (sr-1)/2];
[y2,x2] = complexSignal(freqs, sr, duration, 'noplot');
noise = rand([1,numel(y2)]);

mrSignal = (y + y2 + noise);
mrSignal = mrSignal / max(mrSignal); % percent signal change

% Show the corrupted signal
figure();
subplot(2,1,1)
plot(x,mrSignal);
title('Corrupted signal');

% Now un-corrupt it as best you can
cutoff = .01;
processed = filterComplexSignal(mrSignal,x,sr,'highpass', cutoff, 'noplot');
subplot(2,1,2)
plot(x,processed);
title(sprintf('Highpass-filtered with cutoff %0.2f to remove scaner drift', cutoff));