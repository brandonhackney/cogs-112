function filterComplexSignal(y,x,filterType, sr)
% Parse inputs
filterList = {'lowpass','highpass','bandpass'};
assert(numel(y) > 1 && numel(x) > 1, 'First two inputs must be the wave vectors from complexSignal')
assert(ischar(filterType), 'Filter type must be a string');
assert(ismember(filterType, filterList), 'Invalid filter type %s! Options are: %s', strjoin(filterList, ', '));

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
switch filterType
    case 'lowpass'
        % Cutoff freq = 5 Hz
        % Remove anything above 5 Hz (and below -5 Hz)
        cutoff = 5; % ??
        step2(ifftshift(fqax) >= cutoff & ifftshift(fqax) <= -cutoff) = 0;
        % Apply filter
    case 'highpass'
        % Cutoff freq = 1 Hz
        % Remove anything below 1Hz (and above -1 Hz)
        cutoff = 1;
        step2(ifftshift(fqax) <= cutoff & ifftshift(fqax) >= -cutoff) = 0;
    case 'bandpass'
        % Low cutoff = 1 Hz
        cut1 = 1;
        % High cutoff = 440 Hz
        cut2 = 440;
        % Remove anything below the low cutoff or above the high cutoff
        % And anything above -cut1 or below -cut2
        % This is kind of complicated...
        cutoff = [cut1 cut2];

end
filtered = ifft(step2);

ymax = max(max([filtered;y]));
% Plot result
figure();
subplot(3,1,1)
    plot(x,y);
    title('Input signal');
    ylim([-ymax, ymax]);
    xlabel('Time (sec)');
subplot(3,1,2)
    plot(x,filtered);
    title(sprintf('%s-filtered signal at cutoff %0.2f Hz', filterType, cutoff));
    ylim([-ymax, ymax]);
    xlabel('Time (sec)');
subplot(3,1,3)
    plot(x,y-filtered);
    title('What was filtered');
    ylim([-ymax, ymax]);
    xlabel('Time (sec)');
end % function