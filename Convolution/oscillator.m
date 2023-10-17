function [x,y] = oscillator(waveform,amplitude,frequency,duration,sampleRate, varargin)
% Select a waveform, then generate X and Y vectors representing that wave.
%
% [x,y] = oscillator(waveform,amplitude,frequency,duration,sampleRate, phase, pulsewidth)
%
% x = time vector (for the x axis)
% y = wave vector (for the y axis)
% waveform: 'sine', 'square', 'saw', 'triangle'
% amplitude is a scalar value (in dB?)
% frequency is a scalar value in Hz
% duration is time in seconds the wave will last
% sampleRate is the number of desired samples per second.
% For instance, the 44.1kHz sampling rate you usually see in music would be
% sampleRate = 44100
% (Optional) phase offset is a percentage of the frequency to shift by
% e.g. 0.5 offsets by half the wavelength
% (Optional) pulse width modulation is a percentage of time the wave is on
%
% Please keep the sample rate inversely proportional to the length!
% A 3-second long wave at 44.1kHz sampling rate produces two vectors 
% that are each 132,300 elements long!
% Long samples at high sampling rates can thus generate extremely large,
% computationally-intensive vectors very quickly. I therefore recommend
% using a low-resolution sampling rate, like 8 kHz, for longer waves.
%
% The output can be plotted using plot(x,y)
% and can be played using sound(y,sampleRate)

% Phase offset
if nargin > 5
    phase = varargin{1};
else
    phase = 0;
end

% Pulse width modulation
if nargin > 6
    pwm = varargin{2};
else
    pwm = 0.5;
end

    % generate x axis vector
    stepSize = 1/sampleRate;
        x = 0:stepSize:duration-stepSize;
    % init
        y = 0;
    
    switch waveform
        case 'sine'
            y = amplitude * sin(2*pi* frequency * x + (2*pi * phase));
        case 'square'
            % There's a built-in square wave function with PWM!
            pwm = pwm * 100; % since it is entered as a percentage
            y = amplitude * square(2*pi * frequency* x + (2*pi * phase), pwm);
        case 'saw'
            % There is a built-in sawtooth function!
            y = amplitude * sawtooth(2*pi * frequency * x + (2*pi * phase));
        case 'triangle'
            % You can use the sawtooth function!! Set the 'maximum' at 0.5
            y = amplitude * sawtooth(2*pi * frequency* x + (2*pi * phase), 0.5);
    end
end