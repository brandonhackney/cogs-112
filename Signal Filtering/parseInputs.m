function [duration, freq, amp, resolution] = parseInputs(nargs,args)
% Checks the inputs to the osc() function
% Send me nargin and varargin

    for i = 1:nargs
        assert(isnumeric(args{i}) && args{i} > 0, 'Input %i must be a positive number', i);
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
        if resolution > 48
            warning(['Provided sample rate of %0.2e kHz is unusually high! ' ...
                'Given your input duration of %0.2e, this will produce x and y vectors '...
                'that are both %i elements long!'], ...
                resolution, duration, 1+duration*resolution*1000);
        elseif resolution < 1
            warning(['Provided sample rate of %0.5f kHz is unusually low! ' ...
                'This is being interpreted as %0.5f samples per second, or '...
                'once every ~%0.2f seconds!'], resolution, resolution * 1000, 1/(resolution * 1000));
        end % warnings
    
    else
        resolution = 8; % kHz, or this many thousand samples per second
    end
    resolution = 1/(resolution * 1000); % convert kHz to seconds
end