function [ufilt,spikes] = roc(u)
% Robust Outlier Cutoff based on the Maximum Absolute Deviation and the 
% Universal Threshold
%   23/04/2018
% u: velocity vector

k = 1.483; % based on a normal distro, see Rousseeuw and Croux (1993)

% Robust estimation of the variance:
umed = nanmedian(u);
ustd = k * nanmedian( abs(u - umed));
% Universal threshold:
N = length(u);
lambdau = sqrt(2*log(N));

i_rep = zeros(N, 1);

for i = 1:N
   
    if abs((u(i)-umed)/(lambdau*ustd)) > 1.0
        
        ufilt(i) = nan;
        i_rep(i) = 1;
        
    else
        
        ufilt(i) = u(i);
        
    end
end

spikes = sum(i_rep)/N*100;

%fprintf('ROC, Spikes(percent): %2.8f %%\n', spikes)

% Additional data:

end

