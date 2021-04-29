function [Cs] = Csigma(ud, dp, nu_c)
% CSIGMA  This function calculates C_{\sigma} parameter after Eq. (15) of Hohermuth et al. (2021)
% This parameter was calibrated against low and high Reynolds data.
% 

a = -7.2*10^(-8); b = 0.002; c = -0.589;
Rb = dp.*ud./nu_c;
Cs = max(0,a*Rb.^2+b.*Rb+c);

end
