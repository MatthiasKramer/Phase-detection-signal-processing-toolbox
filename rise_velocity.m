function [Ur] = rise_velocity(dp, rho_c, rho_d, sigma, nu_c, gamma)
% RISE_VELOCITY This function solves Eq. 6 from Hohermuth et al. (2021).
%
%   In non-horizontal flows, the pseudo-steady relative bubble velocity due to buoyancy
%   in probe-wise direction.
% 
%   This function inputs:
%       dp: diameter particle
%       rho_c: carrier phase density (water)
%       rho_d: dispersed phase density (air)
%       sigma: surface tension coefficient [needed for CD.m]
%       nu_c: viscosity carrier phase (water) [needed for CD.m]
%       gamma: probe-wise-bubble alignment.
%
%   This function returns:
%       Ur: pseudo-steady relative bubble velocity due to buoyancy
%           in probe-wise direction
%

Ur=linspace(0.0001,0.0001,length(dp));

    for i=1:1:length(dp)
        Ur_old = 0;
        loop = 0;
        while (Ur_old-Ur(i))^2 > 10^-9 && loop < 10^3 % tol and maxiter
            Ur_old = Ur(i);
            cd = CD(dp(i),0,Ur(i),rho_c,rho_d,sigma,nu_c); % update the drag coefficient
            Ur(i) = (4*dp(i)*9.81*abs(cosd(gamma))*(rho_c-rho_d)/(3*cd*rho_c))^0.5;
            Ur(i) = 0.5*(Ur(i) + Ur_old);
            loop = loop + 1;
        end
        
    end
    Ur = Ur.*sign(cosd(gamma));
end

