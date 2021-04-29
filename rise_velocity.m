function [Ur] = rise_velocity(dp, rho_c, rho_d, sigma, nu_c, gamma)
% RISE_VELOCITY This function solves Eq. 13 from Hohermuth et al. (2021).  
% 

Ur=linspace(0.0001,0.0001,length(dp));

    for i=1:1:length(dp)
        Ur_old = 0;
        loop = 0;
        while (Ur_old-Ur(i))^2 > 10^-9 && loop < 10^3
            Ur_old = Ur(i);
            cd = CD(dp(i),0,Ur(i),rho_c,rho_d,sigma,nu_c);
            Ur(i) = (4*dp(i)*9.81*abs(cosd(gamma))*(998-1.1)/(3*cd*998))^0.5;
            Ur(i) = 0.5*(Ur(i) + Ur_old);
            loop = loop + 1;
        end
        
    end
    Ur = Ur.*sign(cosd(gamma));
end



