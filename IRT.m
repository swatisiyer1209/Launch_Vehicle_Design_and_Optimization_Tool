function [Isp_vac1,Isp_sl1,Isp_2,epsilon1,epsilon2,C_star1, C_star2]=IRT(gamma,T_cc,M,P_cc1,P_cc2,P_e1,P_e2)

constants;
%%IN THIS FUNCTION THE IDEAL ROCKET THEORY CALCULATIONS ARE PERFORMED 
%% STAGE 1
%Vandenkerckhove Function

    vand_func1=sqrt(gamma(1))*((2/(gamma(1)+1))^((gamma(1)+1)/(2*(gamma(1)-1))));

    C_star1=sqrt((R_A/M(1))*T_cc(1))/vand_func1;


% Expansion Ratio
    epsilon1=vand_func1/sqrt(((2*gamma(1))/(gamma(1)-1))*(1-(P_e1/P_cc1)^((gamma(1)-1)/(gamma(1))))*(P_e1/P_cc1)^(2/gamma(1)));

%Coefficient of thrust (vacuum)
    Cf1_vac=vand_func1*sqrt(((2*gamma(1))/(gamma(1)-1))*(1-(P_e1/P_cc1)^((gamma(1)-1)/(gamma(1)))))+(P_e1/P_cc1)*epsilon1;
    Cf1_sl=vand_func1*sqrt(((2*gamma(1))/(gamma(1)-1))*(1-(P_e1/P_cc1)^((gamma(1)-1)/(gamma(1)))))+((P_e1-p_a)/P_cc1)*epsilon1;

%Exhaust Velocity (m/s)
    Ve1_vac=Cf1_vac*C_star1;
    Ve1_sl=Cf1_sl*C_star1;

%Specific Impulse (s)
    Isp_vac1=Ve1_vac/g;
    Isp_sl1=Ve1_sl/g;

%% STAGE 2
%Vandenkerckhove Function

    vand_func2=sqrt(gamma(2))*((2/(gamma(2)+1))^((gamma(2)+1)/(2*(gamma(2)-1))));

    C_star2=sqrt((R_A/M(2))*T_cc(2))/vand_func2;
    
% Expansion Ratio
    epsilon2=vand_func2/sqrt(((2*gamma(2))/(gamma(2)-1))*(1-(P_e2/P_cc2)^((gamma(2)-1)/(gamma(2))))*(P_e2/P_cc2)^(2/gamma(2)));

%Coefficient of thrust (vacuum)
    Cf2=vand_func2*sqrt(((2*gamma(2))/(gamma(2)-1))*(1-(P_e2/P_cc2)^((gamma(2)-1)/(gamma(2)))))+(P_e2/P_cc2)*epsilon2;

%Exhaust Velocity (m/s)
    Ve_2=Cf2*C_star2;

%Specific Impulse (s)
    Isp_2=Ve_2/g;



