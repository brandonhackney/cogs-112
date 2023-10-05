function hrf = twoGammaHrf( kernelLen, TR, T0, alpha1, alpha2, ...
    beta1, beta2, c, a )

%twoGammaHrf Generate a canonical haemodynamic response function (hrf) 
% modeled as a linear combination of two Gamma functions. Uses the 
% equation preseted in Lindquist, Loh, Atlas & Wager (2009)
%
% INPUTS:
%     kernelLen     Length (in seconds) of the time axis. 
%                     Default = 30 secs
%     TR            Time resolution (in seconds). 
%                     Default = 2 secs
%     T0            Delay of response relative to onset. 
%                     Default = 0 secs
%     alpha1        Time to response peak. 
%                     Default alpha = 6 (corresponds to 5 secs)
%     alpha2        Time to undershoot peak. 
%                     Default alpha = 16 (corresponds to 15 secs)
%     beta1         Response dispersion. 
%                     Default = 1
%     beta2         Undershoot dispersion. 
%                     Default = 1
%     c             Response undershoot ratio. 
%                     Basically, the undershoot Gamma will be multiplied by
%                           1/c
%                     Default = 6
%     a             Amplitude of hrf (takes one of three values) 
%                       1 = Scale peak of hrf to 1
%                       2 = Scale hrf so that its integral is 1
%                       3 = Don't apply any scale (DEFAULT)
%
% OUTPUT:
%     hrf           The two Gamma model of the hrf
%
% 05.11.18
% Daniel Stehr

% Set default arguments (if missing)
switch nargin
    case 0
        a = 3;
        c = 6;
        beta2 = 1;
        beta1 = 1;
        alpha2 = 16;
        alpha1 = 6;
        T0 = 0;
        TR = 2;
        kernelLen = 30;
    case 1
        a = 3;
        c = 6;
        beta2 = 1;
        beta1 = 1;
        alpha2 = 16;
        alpha1 = 6;
        T0 = 0;
        TR = 2;
    case 2
        a = 3;
        c = 6;
        beta2 = 1;
        beta1 = 1;
        alpha2 = 16;
        alpha1 = 6;
        T0 = 0;
    case 3
        a = 3;
        c = 6;
        beta2 = 1;
        beta1 = 1;
        alpha2 = 16;
        alpha1 = 6;
    case 4
        a = 3;
        c = 6;
        beta2 = 1;
        beta1 = 1;
        alpha2 = 16;
    case 5
        a = 3;
        c = 6;
        beta2 = 1;
        beta1 = 1;
    case 6
        a = 3;
        c = 6;
        beta2 = 1;
    case 7
        a = 3;
        c = 6;
    case 8
        a = 3;
end


% Define the time axis
t = 0:TR:kernelLen;

% Define the difference of gamma function
g = {@(t,T0,alpha1,beta1) ((t-T0).^(alpha1-1)).*(beta1^alpha1).*...
                          exp(-beta1*(t-T0))/...
                          factorial(alpha1-1);
     @(t,T0,alpha2,beta2) ((t-T0).^(alpha2-1)).*(beta2^alpha2).*...
                          exp(-beta2*(t-T0))/...
                          factorial(alpha2-1)};
diffGamma = @(t,T0,alpha1,alpha2,beta1,beta2,c) g{1}(t,T0,alpha1,beta1) - ...
    (1/c)* g{2}(t,T0,alpha2,beta2);

% Model the hrf 
hrf = diffGamma(t,T0,alpha1,alpha2,beta1,beta2,c);

% Scale the amplitude of hrf
if a == 1     %This arg is a flag to scale the peak to 1
    fun = @(x) -1*(diffGamma(x,T0,alpha1,alpha2,beta1,beta2,c));
    [~, max] = fminbnd(fun,0,kernelLen);
    s = -1* 1/max;
elseif a == 2    %Scale hrf so its integral is equal to 1
    area = integral(@(x)diffGamma(x,T0,alpha1,alpha2,beta1,beta2,c),0,kernelLen);
    s = 1/area;
elseif a == 3   %Don't apply any scale (DEFAULT)
    s = 1;
end
hrf = hrf.* s;

% % Find new maximum of hrf
% fun = @(x) -s.*(gamma(x,T0,alpha1,beta1) - (1/c)* gamma(x,T0,alpha2,beta2));
% [~, max] = fminbnd(fun,0,kernelLen);

% % Find new minimum of hrf
% fun = @(x) s*(gamma(x,T0,alpha1,beta1) - (1/c)* gamma(x,T0,alpha2,beta2));
% [~, min] = fminbnd(fun,0,kernelLen);

end

