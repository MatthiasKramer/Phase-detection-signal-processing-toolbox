function Cd = CD(dp,uc,ud,rho_c,rho_d,sigma,nu)
% calculate drag coefficient after:
% Tomiyama, A., Kataoka, I., Fukuda, T. & Sakaguchi, T. (1995).
% Drag coefficients of bubbles: 2nd report, drag coefficient for a swarm of bubbles and its applicabilityto transient flow.
% Transactions of the Japan Society of Mechanical Engineers Series B61, 2810?2817.
    if uc == ud
        Cd = 0;
    else
        Re = abs(uc-ud).*dp./nu; %bubble reynolds number
        Et = 9.81*(rho_c-rho_d).*dp.^2./sigma; %Eotvoes number
        Cd = max(min((24./Re).*(1+0.15.*Re.^0.687),72./Re),8/3.*Et./(Et+4));
    end
end