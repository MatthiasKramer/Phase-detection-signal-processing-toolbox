function [ufilt,spikes] = roc(u)
%Robust outlier cutoff based on the maximum absolute deviation and the 
%universal threshold
%23/04/2018
%u: velocity vector

k = 1.483; % based on a normal distro, see Rousseeuw and Croux (1993)

%robust estimation of the variance:
umed = nanmedian(u); % expected value estimated trhough MED
ustd = k * nanmedian( abs(u - umed)); % ust estimated through MAD

%universal threshold:
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

spikes = sum(i_rep)/N*100; %number of spikes
end

