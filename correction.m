function [ucorr] = correction(Cinst,Finst,umeas,deltaX,b,rho_c,rho_d,sigma,cVM,gamma,dProbe,nu_c,Cp)

options = optimset('Display','off','TolX',1e-8);

if ~isnan(umeas)
    T1meas = (deltaX)./umeas;
    ud0 = umeas*1.15;
     
    if Cinst<=0.3
            try
                ucorr = fsolve(@(ud0)Fun(ud0, Cinst, Finst, cVM, b, dProbe, deltaX, gamma, rho_c, rho_d, sigma, nu_c, Cp, T1meas), ud0, options); %solve Eq. (5), i.e., optimization problem
            catch
                ucorr = NaN; %assign NaN if optimization fails
            end
    else
        ucorr=umeas;
    end
else
    ucorr=NaN;    
end

end