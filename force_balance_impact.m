function [dudt] = force_balance_impact(ud,b,dp,uc,cVM,dProbe,gamma,rho_c,rho_d,sigma,nu_c,Cp)
% Define force balance equation (Eq. 3)
dudt = ... %time derivative
    3*CD(dp,uc,ud(1),rho_c,rho_d,sigma,nu_c)*rho_c/(4*(rho_d+rho_c*cVM)*dp)*(uc-ud(1))*abs(uc-ud(1))... %drag force
    +(dp^3*(rho_d-rho_c)*9.81*cosd(gamma))/((rho_d+rho_c*cVM)*dp^3)... %body forces
    -(6*b*sigma*dProbe)/((rho_d+rho_c*cVM)*dp^3)... %contact force
    -(3*Cp*rho_d*ud(1)^2*dProbe^2/(4*dp^3*(rho_d+rho_c*cVM)))... %stagnation force
    -(6*Csigma(ud, dp, nu_c)*sigma*(rho_d*ud(1)^2*dp/sigma)^0.25/(pi*dp^2*(rho_d+rho_c*cVM))); %deformation force
end
