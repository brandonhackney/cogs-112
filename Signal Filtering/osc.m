function [wave, varargout] = osc(varargin)
% Simple sine wave generator
% [wave, xaxis] = osc(duration, frequency, amplitude, sample rate)
%
% By default, outputs a single cycle at 1 Hz, with 8kHz sample frequency
% Input up to 4 optional parameters to modify the signal:
% 1. Duration of signal in seconds (default 1)
% 2. Frequency in Hz (default 1)
% 3. Max amplitude (default 1)
% 4. Sample rate in Hz (default 8 kHz; anything > 48kHz or < 0.3 Hz produces a warning)
%
% Optional second output is the time vector needed to plot your wave

%% Parse inputs
% I put all the input validation in a different function for simplicity
[duration, freq, amp, resolution] = parseInputs(nargin, varargin);

%% Run calculations
x = 0:resolution:duration;
rad2lin = 2 * pi; % so 1 cycle completes at x = 1, not x = 2 * pi
wave = amp * sin(x * freq * rad2lin);

if nargout > 1
    % Output the time vector needed to plot the wave
    varargout{1} = x;
end

end % function