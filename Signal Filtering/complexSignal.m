function varargout = complexSignal(varargin)
% Generates 3 waves of different frequencies and adds them, plotting result
% Optionally output the wave and time vector for further analysis

% Parse input
if nargin > 0
    frequencies = varargin{1};
    assert(length(frequencies) == 3, 'Please enter three frequencies as a single, 3-element vector');
else
    frequencies(1) = 0.1;
    frequencies(2) = 5;
    frequencies(3) = 15;
end

if nargin > 1
    sr = varargin{2};
else
    sr = 8000; % default to 8kHz sample rate
end

if nargin > 2
    dur = varargin{3};
else
    dur = 10; % default to a 10 sec signal
end

% Calculate wave vectors
[wave1, x] = osc(dur,frequencies(1),1,sr); % low freq
wave2 = osc(dur, frequencies(2),1,sr); % medium freq
wave3 = osc(dur, frequencies(3),1,sr); % high freq
combo = wave1 + wave2 + wave3;

% Plot the results
figure();
subplot(4,1,1);
    % Low freq wave
    plot(x,wave1);
    title(sprintf('Low freq wave: %0.2f Hz', frequencies(1)));
    xlabel('Time (sec)');
    ylim([-max(combo), max(combo)]);
subplot(4,1,2)
    plot(x,wave2);
    title(sprintf('Mid freq wave: %0.2f Hz', frequencies(2)));
    xlabel('Time (sec)');
    ylim([-max(combo), max(combo)]);
subplot(4,1,3)
    plot(x,wave3);
    title(sprintf('High freq wave: %0.2f Hz', frequencies(3)));
    xlabel('Time (sec)');
    ylim([-max(combo), max(combo)]);
subplot(4,1,4)
    plot(x,combo);
    title('Combined signal');
    xlabel('Time (sec)');
    ylim([-max(combo), max(combo)]);

% Outputs
if nargout > 0
    % Output 1 is the combined wave
    varargout{1} = combo;
end
if nargout > 1
    % Output 2 is the time vector
    varargout{2} = x;
end