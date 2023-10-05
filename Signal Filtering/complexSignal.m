function varargout = complexSignal(varargin)
% Generates 3 waves of different frequencies and adds them, plotting result
% Optionally output the wave and time vector for further analysis

%% Play with these values to see how they impact the end result
frequencies{1} = 0.1;
frequencies{2} = 1;
frequencies{3} = 7;

%% Nuts and bolts
% Parse input
if nargin > 0
    dur = varargin{1};
else
    dur = 10; % default to a 10 sec signal
end

% Calculate wave vectors
[wave1, x] = osc(dur,frequencies{1}); % low freq
wave2 = osc(dur, frequencies{2}); % medium freq
wave3 = osc(dur, frequencies{3}); % high freq
combo = wave1 + wave2 + wave3;

% Plot the results
figure();
subplot(4,1,1);
    % Low freq wave
    plot(x,wave1);
    title('Low freq wave');
    xlabel('Time (sec)');
    ylim([-max(combo), max(combo)]);
subplot(4,1,2)
    plot(x,wave2);
    title('Mid freq wave');
    xlabel('Time (sec)');
    ylim([-max(combo), max(combo)]);
subplot(4,1,3)
    plot(x,wave3);
    title('High freq wave');
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