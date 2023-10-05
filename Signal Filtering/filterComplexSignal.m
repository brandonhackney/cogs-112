function filterComplexSignal(y,x,filterType)
% Parse inputs
filterList = {'lowpass','highpass','bandpass'};
assert(numel(y) > 1 && numel(x) > 1, 'First two inputs must be the wave vectors from complexSignal')
assert(ischar(filterType), 'Filter type must be a string');
assert(ismember(filterType, filterList), 'Invalid filter type %s! Options are: %s', strjoin(filterList, ', '));

% 
switch filterType
    case 'lowpass'
        % Cutoff freq = x
    case 'highpass'
        % Cutoff freq = y
    case 'bandpass'
        % Center freq = x
        % Filter width = y
        
end

ymax = max(max([x;y]));
% Plot result
figure();
subplot(2,1,1)
    plot(x,y);
    title('Input signal');
    ylim([-ymax, ymax]);
    xlabel('Time (sec)');
subplot(2,1,2)
    plot(x,z);
    title('Filtered signal: %s', filterType);
    ylim([-ymax, ymax]);
    xlabel('Time (sec)');
end % function