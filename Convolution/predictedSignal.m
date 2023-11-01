function varargout = predictedSignal(varargin)
% (y, x) = predictedSignal(duration, sampleRate)
% Defaults to a 3-minute signal at sample rate of 20 Hz
close all;
if nargin > 0
    % Duration
    dur = varargin{1};
else
    dur = 60*3;
end
if nargin > 1
    % Sample Rate
    rate = varargin{2};
else
    rate = 800;
end
% Plot condition 1
subplot(7,1,1)
    amp = 1;
    freq = 5/dur;
    phase = 0;
    pwm = 0.35;
    [a,b] = oscillator('square',amp,freq,dur,rate, phase, pwm);
    b = b + abs(min(b)); % remove any negative values
    b = b / max(b); % rescale to unit height
    plot(a,b);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        title('Condition 1');
        ylim([min(b) - abs(.1 * min(b)), max(b) + 0.1 * max(b)]);
% Plot condition 2
subplot(7,1,2)
    amp = 1;
    freq = 5/dur;
    phase = 0.5;
    pwm = 0.35;
    [c,d] = oscillator('square',amp,freq,dur,rate, phase, pwm);
    d = d + abs(min(d)); % remove any negative values
    d = d / max(d); % rescale to unit height
    plot(c,d);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        title('Condition 2');
        ylim([min(b) - abs(.1 * min(b)), max(b) + 0.1 * max(b)]);
% Plot conditions 1 and 2 together
subplot(7,1,3)
    plot(a,[b', d']);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        title('Both conditions overlaid');
        ylim([min(b) - abs(.1 * min(b)), max(b) + 0.1 * max(b)]);
% Generate an HRF kernel
kernel = twoGammaHrf(30,1/rate);
kernel = kernel / max(kernel); % unit height
subplot(7,1,4)
kx = zeros([1,length(a)]);
kx(1:length(kernel)) = kernel;
    plot(a, kx);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        title('HRF kernel');
        ylim([min(b) - abs(.1 * min(b)), max(b) + 0.1 * max(b)]);

% Convolve the vectors with the HRF kernel
b2 = conv(b,kernel, 'same'); b2 = b2/max(b2);
d2 = conv(d, kernel, 'same'); d2 = d2/max(d2);
subplot(7,1,5)
    plot(a,[b2',d2']);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        title('HRF-convolved');
        ylim([min(b) - abs(.1 * min(b)), max(b) + 0.1 * max(b)]);
% Add together to get a predicted brain signal
pred = b2 + d2; pred = pred / max(pred);
subplot(7,1,6)
    plot(a, pred);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        title('Predicted brain signal');
        ylim([min(b) - abs(.1 * min(b)), max(b) + 0.1 * max(b)]);
% Downsample to TR = 3;
subplot(7,1,7)
    sr = rate * 3;
    a1 = a(1:sr:end);
    pred1 = pred(1:sr:end);
    plot(a1,pred1);
        xlabel('Time (sec)');
        ylabel('Amplitude');
        title('Predicted brain signal (Downsampled to TR = 3)');
        ylim([min(b) - abs(.1 * min(b)), max(b) + 0.1 * max(b)]);

% Define outputs
if nargout > 0
    varargout{1} = pred;
end
if nargout > 1
    varargout{2} = a;
end