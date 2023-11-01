function [duration, freq, amp, resolution] = parseInputs(nargs,args)
% Checks the inputs to the osc() function
% Send me nargin and varargin

    for i = 1:nargs
        assert(isnumeric(args{i}) && args{i} >= 0, 'Input %i must be a positive number', i);
    end
    
    % Duration
    if nargs > 0
        duration = args{1};
    else
        duration = 1; % seconds
    end
    % Frequency
    if nargs > 1
        freq = args{2};
    else
        freq = 1; % Hz aka cycles per second
    end
    % Max amplitude
    if nargs > 2
        amp = args{3};
    else
        amp = 1;
    end
    % Resolution
    if nargs > 3
        resolution = args{4};
        Nq = resolution /2; % Nyquist frequency

        if resolution >= 48000
            warning(['Provided sample rate of %0.2g Hz is unusually large! ' ...
                'Given your input duration of %0.2g, this will produce x and y vectors '...
                'that are both %i elements long!'], ...
                resolution, duration, 1+duration*resolution);
        elseif freq >= Nq
            warning(['Provided frequency of %0.2g Hz exceeds the upper limit of %0.2g!\n' ...
                'Either lower the frequency, or increase your sample rate to at least %0.2g'...
                ], freq, Nq, freq * 2);
        end % warnings
    
    else
        resolution = 8000; % Hz, or this many samples per second
    end
    resolution = 1/resolution; % convert Hz to seconds
end