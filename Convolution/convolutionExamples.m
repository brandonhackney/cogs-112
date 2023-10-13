% Explore different examples of convolution
% Try picking different boxcars and kernels and see how the output changes

% init
close all
boxType = '2box';
kernType = 'flat';

% Get values
% Define boxcar
x = 0:0.1:10; % inventing a time scale of 0-5 sec in 0.1 sec increments
numX = numel(x);
switch boxType
    case 'midline'
        % A single pulse in the middle
        y = zeros([1,numX]);
        y(round(numX/2)) = 1;
    case 'twinPeaks'
        % two unit spikes at 1/3 and 2/3
        y = zeros([1,numX]);
        y(round(numX/3)) = 1;
        y(round(2*numX/3)) = 1;
    case 'sustain'
        % Hold the signal on from 1/3 to 2/3
        y = zeros([1,numX]);
        y(round(numX/3):round(2*numX/3)) = 1;
    case '2box'
        % Like a mix of twinPeaks and sustain:
        % Have an extended signal that happens twice, with a big gap

        % Old method
        % y = zeros([1,numX]);
        % y(round(numX/10):round(3*numX/10)) = 1;
        % y(round(7*numX/10):round(9*numX/10)) = 1;

        [~, y] = oscillator('square', 1, 2, 1, numX);
        y = y + abs(min(y)); % shift up from 0
    case '3'
        % 3 random bumps
        y = zeros([1,numX]);
        temp = randperm(numX);
        inds = temp(1:3);
        y(inds) = .5;
    case 'sine'
        y = sin(x * pi * 2);
    case 'triangle'
        [~,y] = oscillator('triangle', 1, 2, 1, numX);
    otherwise
        error('Invalid boxType');
end
x = ((1:numel(y)) - 1) / 5; % inventing a time scale

% Define kernel
switch kernType
    case 'flat'
        kernel = [.2 .2 .2 .2 .2];
    case 'exp'
        % an exponential curve
        kernel = 0:.5:3;
        kernel = kernel .^ 2;
        kernel = kernel / max(kernel); % scale to unit size
        % kernel = [0 0.05 0.06 0.1 0.5 0.9 0];
    case 'gauss'
        kx = -3:.5:3; % x must be centered on 0
        kernel = normpdf(kx);
        % discard x so everything is positive
    case 'pyramid'
        kernel = [0 0 .5 .5 1 1 .5 .5 0 0];
    case 'steps'
        kernel = [0 0 .2 .2 .4 .4 .6 .6];
    case 'hrf'
        kernel = twoGammaHrf;
        kernel = kernel / max(kernel); % rescale so max is 1
    case 'edge'
        kernel = [0 1 0 -1 0];
    otherwise 
        error('Invalid kernType')
end

% Convolve kernel with boxcar
w = conv(y,kernel);

% Show all three elements at once:
figure();
ymax = max([y,kernel,w]);
ymin = min([y,kernel,w]);
% Add a little buffer
ymax = ymax + (.1 * ymax);
ymin = ymin - abs(.1 * ymin);
subplot(3,1,1); % The signal
    plot(x,y);
    xlabel('Time');
    title('Boxcar');
    ylim([ymin,ymax]);
    xlim([0,max(x)]);
subplot(3,1,2); % the kernel
    plot(x(1:numel(kernel)),kernel);
    xlabel('Time');
    title('kernel');
    ylim([ymin,ymax]);
    xlim([0,max(x)]);
subplot(3,1,3); % the convolution
    plot(x,w(1:numel(x)));
    xlabel('Time');
    title('Convolution of boxcar and kernel');
    ylim([ymin,ymax]);
    xlim([0,max(x)]);