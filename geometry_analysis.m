function [geometry_parameter]=geometry_analysis(propulsion_parameter,D_s1,D_s2,prop_choice1,prop_choice2,N_eng1,N_eng2)
%% GEOMETRY DISCIPLINE

constants;

F_vac1= propulsion_parameter.Overview.Total_Thrust1;
F_2= propulsion_parameter.Overview.Total_Thrust2;

mfuel1=propulsion_parameter.Overview.Fuel_Mass1;
mox1=propulsion_parameter.Overview.Oxidizer_Mass1;

mfuel2=propulsion_parameter.Overview.Fuel_Mass2;
mox2=propulsion_parameter.Overview.Oxidizer_Mass2;

%% STAGE 1

%Engine Length
if prop_choice1==1
    geometry_parameter.Engine.L_eng1=(0.1667*(F_vac1/N_eng1)^0.2238);
end
if prop_choice1==2
    geometry_parameter.Engine.L_eng1=0.1362*(F_vac1/N_eng1)^0.2279;
end
if prop_choice1==3
    geometry_parameter.Engine.L_eng1=eta_L_methane*0.1362*(F_vac1/N_eng1)^0.2279;
end

%Storage Tank Length
geometry_parameter.Stage.L_tank1=(((mfuel1/rho_f(prop_choice1))+(mox1/rho_ox)+(pi*D_s1^3)/6)*(1+V_ullage)*(4/(pi*D_s1^2)));

%Intestage Length
geometry_parameter.Stage.L_IS1=geometry_parameter.Engine.L_eng1+0.2*D_s1;

%% STAGE 2
%Engine Length
if prop_choice2==1
    geometry_parameter.Engine.L_eng2=(0.1667*(F_2/N_eng2)^0.2238);
end
if prop_choice2==2
    geometry_parameter.Engine.L_eng2=0.1362*(F_2/N_eng2)^0.2279;
end
if prop_choice2==3
    geometry_parameter.Engine.L_eng2=eta_L_methane*0.1362*(F_2/N_eng2)^0.2279;
end

%Storage Tank Length
geometry_parameter.Stage.L_tank2=(((mfuel2/rho_f(prop_choice2))+(mox2/rho_ox)+(pi*D_s2^3)/6)*(1+V_ullage)*(4/(pi*D_s2^2)));

%Intestage Length
geometry_parameter.Stage.L_IS2= geometry_parameter.Engine.L_eng2+0.287*D_s2;

%% Fairing:
geometry_parameter.Fairing.L_fairing=1.1035*D_s2^1.6385+2.3707;
%% Stage

geometry_parameter.Stage.L_Stage1=(geometry_parameter.Stage.L_tank1+geometry_parameter.Stage.L_IS1);
geometry_parameter.Stage.L_Stage2=(geometry_parameter.Stage.L_tank2+geometry_parameter.Stage.L_IS2);