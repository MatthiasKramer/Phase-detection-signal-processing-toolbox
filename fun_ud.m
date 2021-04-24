function ud_t = fun_ud(ud0, C, F, cVM, b, dProbe, gamma, rho_c, rho_d, sigma, nu_c, Cp, T1meas)
	% Numerical solution of particle force balance (Eq. 3)

    dp = 1.5*ud0*C/F;   % particle diameter assumend constant during interaction (calculate based on last iteration)
    ur = rise_velocity(dp, rho_c, rho_d, sigma, nu_c, gamma);    % rise velocity after Tomiyama for slightly contaminated systems
    uc = ud0 - ur;      % calculate uc for drag calc
    sol = ode45(@(t,ud)force_balance_impact(ud,b,dp,uc,cVM,dProbe,gamma,rho_c,rho_d,sigma,nu_c,Cp), [0 T1meas], ud0);      % solution of ode du/dt
    if max(sol.x) < T1meas
        ud_t = NaN;
    else
        ud_t = deval(sol, T1meas);      % evaluate solution at t=T1meas
    end

end