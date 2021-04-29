function [ufilt,spikes] = roc(u)
% ROC This function implements the Robust outlier cutoff based on the maximum absolute deviation and the 
% universal threshold. This is a simplification of the method of Goring and Nikora (2002), incorporating
% the discussion of Wahl (2003). This filtering uses robust estimators to decide if a velocity measurement
% is too far from the expected value. This is then replaced by a "nan".
% 
% This function inputs:
%   u: unfiltered velocity vector
%   
% This function returns:
%   ufilt: velocity series where the detected outliers take "nan"
%   spikes: the percentage of data filtered out.
%

k = 1.483; % based on a normal distribution, see Rousseeuw and Croux (1993)

% robust estimation of the variance:
umed = nanmedian(u); % expected value estimated trhough MED
ustd = k * nanmedian( abs(u - umed)); % ust estimated through MAD

% universal threshold:
N = length(u);
lambdau = sqrt(2*log(N));
kustd = lambdau*ustd;

i_rep = zeros(N, 1); %which are to be replaced (by NaN).
for i = 1:N
    if abs((u(i)-umed)/kustd) > 1.0
        ufilt(i) = nan;
        i_rep(i) = 1;
    else
        ufilt(i) = u(i);
    end
end

spikes = sum(i_rep)/N*100; % number of spikes
end

