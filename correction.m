function [ucorr] = correction(Cinst,Finst,umeas,deltaX,b,rho_c,rho_d,sigma,cVM,gamma,dProbe,nu_c,Cp)
% CORRECTION This function implements the bubble-probe bias correctection, as defined in:
%--------------------------------------------------------------------------%
% B. Hohermuth, M. Kramer, S. Felder and D. Valero (2021)
% Velocity bias in intrusive gas-liquid flow measurements
% Nature Communications
%--------------------------------------------------------------------------%
%   This correction accounts for forces acting on a bubble while interacting with a metal
%   needle.
%
%   This function inputs:
%       Cinst: instantaneous void fraction
%       Finst: instantaneous bubble count rate
%       umeas: measured velocity (through AWCC, previously).
%       deltaX: distance between tip 1 and 2.
%       b: contact force parameter/surface tension multiplier (i.e. 1).
%       rho_c: carrier phase density (water)
%       rho_d: dispersed phase density (air)
%       sigma: surface tension coefficient
%       cVM: Virtual Mass coefficient
%       gamma: alignment of the bubble trajectory with the probe-wise direction.
%       dProbe: diameter of outer electrode
%       nu_c: viscosity carrier phase (water)
%       Cp: impact pressure coefficient (bubble against the probe tip).
%
%   This function returns:
%       ucorr: corrected velocity, after iteratively finding the velocity of the bubble
%           previous to probe interaction.
%


options = optimset('Display','off','TolX',1e-8);

if ~isnan(umeas)
    T1meas = (deltaX)./umeas;
    ud0 = umeas*1.15; % first guess of the undisturbed (corrected) velocity.
     
    if Cinst<=0.3 % if (bubble flow == True)
            try
                ucorr = fsolve(@(ud0)Fun(ud0, Cinst, Finst, cVM, b, dProbe, deltaX, gamma, rho_c, rho_d, sigma, nu_c, Cp, T1meas), ud0, options); % solve Eq. (5), i.e., optimization problem
            catch
                ucorr = NaN; % assign NaN if optimization fails
            end
    else % flow regime not corresponding to bubble flow
        ucorr=umeas;
    end
else % umeas was a nan.
    ucorr=NaN;    
end

end
