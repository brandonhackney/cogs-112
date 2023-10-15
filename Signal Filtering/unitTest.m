close all;
% Generate test signal
[y, x] = complexSignal;

sr = 8000; % sample rate
Nq = sr/2; % Nyquist frequency

% Take Fourier transform
step1 = fft(y);
visFFT = fftshift(abs(step1));

% Calculate x axis in frequency space
% If you go from 0 to length, not length - 1/sr, it's off by one
% This fits, but is actually inaccurate...
% fqax = (x * sr * sr) / (length(x) - rem(length(x), sr));

% If you do fftshift:
n = length(visFFT);
fqax = linspace(-Nq,Nq,n);


% Define filter
step2 = step1;
% % High-pass filtering at 1 Hz:
%     cutoff = 1; % Hz
%     step2(ifftshift(fqax) <= cutoff & ifftshift(fqax) >= -cutoff) = 0;

% Low-pass filtering at 5Hz:
% We need to identify positive and negative frequencies beyond 5Hz
% fqax defines frequencies, but lines up with an fftshift()ed vector
% So first, we ifftshift fqax so that it lines up with the not-shifted data
cutoff = 5; % ??
z = ifftshift(fqax);
% Now, we can use the indices from this new vector to modify our FFT data
% Remember that the FFT data covers positive and negative frequencies
% So instead of setting up two inequalities, just use abs(z) to do both
step2(abs(z) >= cutoff) = 0;
% Now ifft out of frequency space to get a time-domain wave
% This should be a filtered version of the input y data
filtered = ifft(step2); % actual output - should be non-complex filtered
% And this vector lets us visualize the filtered wave's power spectrum
vis2 = fftshift(abs(step2));


figure();
subplot(5,1,1)
    plot(x,y);
    title('Input signal')
    xlabel('Time (sec)');
    ylabel('Amplitude');
subplot(5,1,2)
    plot(fqax, visFFT);
    title(sprintf('Amplitude spectrum, Nyquist freq = %i', Nq));
    xlabel('Frequency (Hz)');
    ylabel('Power');
subplot(5,1,3)
    cutoffFreq = 40;
    ind1 = find(fqax == -cutoffFreq);
    ind2 = find(fqax == cutoffFreq);
    plot(fqax(ind1:ind2), visFFT(ind1:ind2));
    title('Amplitude spectrum, windowed on frequencies 0 through 40 Hz');
    xlabel('Frequency (Hz)');
    ylabel('Power');
subplot(5,1,4)
    plot(fqax(ind1:ind2), vis2(ind1:ind2))
    title('Post-filter amplitude spectrum, windowed to 40 Hz');
    xlabel('Frequency (Hz)');
    ylabel('Power');
subplot(5,1,5)
    plot(x,filtered);
    title('FILTERED SIGNAL')
    xlabel('Time (sec)');
    ylabel('Amplitude');