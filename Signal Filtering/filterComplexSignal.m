function varargout = filterComplexSignal(y,x, sr, filterType, varargin)
% Parse inputs
filterList = {'lowpass','highpass','bandpass'};
assert(numel(y) > 1 && numel(x) > 1, 'First two inputs must be the wave vectors from complexSignal')
assert(ischar(filterType), 'Filter type must be a string');
assert(ismember(filterType, filterList), 'Invalid filter type %s! Options are: %s', strjoin(filterList, ', '));

if nargin > 5
    toplot = varargin{2};
    validVals = {'noplot','plot'};
    assert(ismember(toplot, validVals), 'Final argument must be either "plot" or "noplot"');
else
    toplot = 'plot';
end

% Nyquist
Nq = sr / 2;

% Take Fourier transform
step1 = fft(y);
visFFT = fftshift(abs(step1));
% Define frequency axis for fftshift()-ed data
n = length(visFFT);
fqax = linspace(-Nq,Nq,n);

% Define filter
step2 = step1; % to be modified
z = ifftshift(fqax);
switch filterType
    case 'lowpass'
        % Get the cutoff frequency
        % Only keep the things BELOW this value
        if exist('varargin', 'var')
            cutoff = varargin{1};
            % if you passed a bandpass array, take the lower value
            if numel(cutoff) > 1
                cutoff = cutoff(1);
            end
        else
            % Set a default of 5 Hz
            cutoff = 5;
        end
        % Apply filter
        step2(abs(z) >= cutoff) = 0;
    case 'highpass'
        % Get the cutoff frequency
        % Only keep the things ABOVE this value
        if exist('varargin', 'var')
            cutoff = varargin{1};
            % If you passed a bandpass array, take the higher value
            if numel(cutoff) > 1
                cutoff = cutoff(2);
            end
        else
            cutoff = 1;
        end
        % Apply filter
        step2(abs(z) <= cutoff) = 0;
    case 'bandpass'
        % Get TWO cutoff frequencies
        % Only keep the things BETWEEN these values
        if exist('varargin', 'var')
            cutoff = varargin{1};
            assert(length(cutoff) == 2, 'Cutoff must be a two-element vector when using a bandpass filter');
            cut1 = cutoff(1);
            cut2 = cutoff(2);
        else
            % Low cutoff = 1 Hz
            cut1 = 1;
            % High cutoff = 440 Hz
            cut2 = 440;
        end
        % Report the center band when plotting
        cutoff = mean([cut1, cut2]);
        % Apply the filter
        step2(abs(z) <= cut1 & abs(z) >= cut2) = 0;
end
% step2 is still in frequency space - convert back to a wave with ifft
filtered = ifft(step2);

%% Plot result
switch toplot
    case 'plot'
        ymax = max(max([filtered;y]));
        figure();
        subplot(3,1,1)
            plot(x,y);
            title('Input signal');
            ylim([-ymax, ymax]);
            xlabel('Time (sec)');
        subplot(3,1,2)
            plot(x,y-filtered);
            title(sprintf('Data removed by %s filter at cutoff of %0.2f Hz:', filterType, cutoff));
            ylim([-ymax, ymax]);
            xlabel('Time (sec)');
        subplot(3,1,3)
            plot(x,filtered);
            title('Resulting filtered signal');
            ylim([-ymax, ymax]);
            xlabel('Time (sec)');
    case 'noplot'
        % ...don't
end

% Outputs
if nargout > 0
    varargout{1} = filtered;
end % function