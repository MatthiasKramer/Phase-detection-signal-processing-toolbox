function [Cs] = Csigma(ud, dp, nu_c)
% calculate C_{\sigma} after Eq. (15)
a = -7.2*10^(-8); b = 0.002; c = -0.589;
Rb = dp.*ud./nu_c;
Cs = max(0,a*Rb.^2+b.*Rb+c);
end