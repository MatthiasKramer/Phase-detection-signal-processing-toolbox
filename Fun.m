function X = Fun(ud0, C, F, cVM, b, dProbe, dx, gamma, rho_c, rho_d, sigma, nu_c, Cp, T1meas)

    % X = optimization objective 
    X = 2*dx/T1meas - ud0 - fun_ud(ud0, C, F, cVM, b, dProbe, gamma, rho_c, rho_d, sigma, nu_c, Cp, T1meas);


end