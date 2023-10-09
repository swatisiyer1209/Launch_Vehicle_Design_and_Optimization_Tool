function [mass_parameter] = weight_analysis(propulsion_parameter,geometry_parameter,D_s1,D_s2,M_pay,prop_choice1,prop_choice2,material_choice,N_eng1,N_eng2)

constants;

F_vac1= propulsion_parameter.Overview.Total_Thrust1;
F_2= propulsion_parameter.Overview.Total_Thrust2;
mprop1=propulsion_parameter.Overview.Propellant_Mass1;
mprop2=propulsion_parameter.Overview.Propellant_Mass2;

L_eng1=geometry_parameter.Engine.L_eng1;
L_tank1=geometry_parameter.Stage.L_tank1;
L_IS1=geometry_parameter.Stage.L_IS1;
L_fairing=geometry_parameter.Fairing.L_fairing;

L_eng2=geometry_parameter.Engine.L_eng2;
L_tank2=geometry_parameter.Stage.L_tank2;
L_IS2=geometry_parameter.Stage.L_IS2;

%% STAGE 1
%Engine Mass:
if prop_choice1==1
    mass_parameter.Engine.M_eng1=(1.866*10^-10*(F_vac1/N_eng1)^2+0.00130*(F_vac1/N_eng1)+77.4);
    mass_parameter.Engine.M_eng1_tot=mass_parameter.Engine.M_eng1 *N_eng1;
end
if prop_choice1==2
    mass_parameter.Engine.M_eng1=1.104*10^-3*(F_vac1/N_eng1)+27.702;
    mass_parameter.Engine.M_eng1_tot=mass_parameter.Engine.M_eng1 *N_eng1;
end
if prop_choice1==3
    mass_parameter.Engine.M_eng1=eta_M_methane*(1.104*10^-3*(F_vac1/N_eng1)+27.702);
    mass_parameter.Engine.M_eng1_tot=mass_parameter.Engine.M_eng1 *N_eng1;
end

%Total Tank Mass:

%tank thickness
mass_parameter.Tank.t=(P_tank*SF*D_s1)/sigma_t(material_choice);

%Tank Insulation Mass
if prop_choice1==1
    mass_parameter.Tank.M_TPS_f1=1.2695*(pi*D_s1*(N_eng1*L_eng1+L_tank1)+pi*D_s1^2);
end
if prop_choice1==2
    mass_parameter.Tank.M_TPS_f1=0;
end

if prop_choice1==3
    mass_parameter.Tank.M_TPS_f1=0.9765*(pi*D_s1*(N_eng1*L_eng1+L_tank1)+pi*D_s1^2);
end

mass_parameter.Tank.M_TPS_ox=0.9765*(pi*D_s1*(N_eng1*L_eng1+L_tank1)+pi*D_s1^2);

%Intertank Mass
mass_parameter.Tank.M_IT1=5.4015*pi*D_s1^2*(3.2808*D_s1)^0.5169;

mass_parameter.Tank.M_tank1=(((pi*D_s1*L_tank1+(pi*D_s1^2)/2)* mass_parameter.Tank.t)*rho_tank(material_choice)+ mass_parameter.Tank.M_IT1 + mass_parameter.Tank.M_TPS_f1 +  mass_parameter.Tank.M_TPS_ox);

%Interstage Mass
mass_parameter.Stage.M_IS1=k_SM(material_choice)*7.7165*(pi*D_s1*L_IS1)*(3.3208*D_s1)^0.4856;

%% STAGE 2
%Engine Mass:
if prop_choice2==1
    mass_parameter.Engine.M_eng2=(1.866*10^-10*(F_2/N_eng2)^2+0.00130*(F_2/N_eng2)+77.4);
    mass_parameter.Engine.M_eng2_tot=mass_parameter.Engine.M_eng2 *N_eng2;
end
if prop_choice2==2
    mass_parameter.Engine.M_eng2=1.104*10^-3*(F_2/N_eng2)+27.702;
    mass_parameter.Engine.M_eng2_tot=mass_parameter.Engine.M_eng2 *N_eng2;
end
if prop_choice2==3
    mass_parameter.Engine.M_eng2=eta_M_methane*(1.104*10^-3*(F_2/N_eng2)+27.702);
    mass_parameter.Engine.M_eng2_tot=mass_parameter.Engine.M_eng2 *N_eng2;
end

%Total Tank Mass:

%tank thickness
mass_parameter.Tank.t=(P_tank*SF*D_s2)/sigma_t(material_choice);

%Tank Insulation Mass
if prop_choice2==1
    mass_parameter.Tank.M_TPS_f2=1.2695*(pi*D_s2*(N_eng2*L_eng2+L_tank2)+pi*D_s2^2);
end
if prop_choice2==2
    mass_parameter.Tank.M_TPS_f2=0;
end

if prop_choice2==3
    mass_parameter.Tank.M_TPS_f1=0.9765*(pi*D_s2*(N_eng2*L_eng2+L_tank2)+pi*D_s2^2);
end

mass_parameter.Tank.M_TPS_ox=0.9765*(pi*D_s2*(N_eng2*L_eng2+L_tank2)+pi*D_s2^2);


%Intertank Mass
mass_parameter.Tank.M_IT2=3.8664*pi*D_s2^2*(3.2808*D_s2)^0.6025;

mass_parameter.Tank.M_tank2=(((pi*D_s2*L_tank2+(pi*D_s2^2)/2)* mass_parameter.Tank.t)*rho_tank(material_choice)+ mass_parameter.Tank.M_IT2 + mass_parameter.Tank.M_TPS_f2 + mass_parameter.Tank.M_TPS_ox);

%Interstage Mass
mass_parameter.Stage.M_IS2=k_SM(material_choice)*5.5234*(pi*D_s2*L_IS2)*(3.3208*D_s2)^0.5210;

%% Fairing
mass_parameter.Stage.M_fairing=49.3218*(L_fairing*D_s2)^0.9054;

%% Payload Adapter
mass_parameter.Stage.M_PLA=0.00477536*M_pay^1.01317;

%% Pad Interface
mass_parameter.Stage.M_pad=25.736*pi*((D_s1^2)/4)*(3.2808*D_s1)^0.5498;

%% Avionics and EPS
mass_parameter.Stage.M_avionics1=0.25*(246.76+1.3183*D_s1*(N_eng1*L_eng1+L_tank1+L_IS1));
mass_parameter.Stage.M_EPS1=0.3321* mass_parameter.Stage.M_avionics1;

mass_parameter.Stage.M_avionics2=0.25*(246.76+1.3183*D_s2*(N_eng2*L_eng2+L_tank2+L_IS2+ L_fairing));
mass_parameter.Stage.M_EPS2=0.3321* mass_parameter.Stage.M_avionics2;



%% Structural Mass
%%Stage 1:
mass_parameter.Stage.M_struct1=(mass_parameter.Engine.M_eng1_tot+ mass_parameter.Tank.M_tank1+mass_parameter.Stage.M_IS1+  mass_parameter.Stage.M_pad+ mass_parameter.Stage.M_avionics1 + mass_parameter.Stage.M_EPS1 );
mass_parameter.Stage.M_struct2=(mass_parameter.Engine.M_eng2_tot+ mass_parameter.Tank.M_tank2+mass_parameter.Stage.M_IS2+ mass_parameter.Stage.M_PLA + mass_parameter.Stage.M_fairing + mass_parameter.Stage.M_avionics2 + mass_parameter.Stage.M_EPS2);

%% Gross Lift-off Mass:
mass_parameter.GLOM=mass_parameter.Engine.M_eng1_tot+mass_parameter.Engine.M_eng2_tot+ mass_parameter.Tank.M_tank1+ mass_parameter.Tank.M_tank2+mass_parameter.Stage.M_IS1+mass_parameter.Stage.M_IS2+ mass_parameter.Stage.M_fairing + mass_parameter.Stage.M_PLA + mass_parameter.Stage.M_pad + mass_parameter.Stage.M_avionics1 + mass_parameter.Stage.M_EPS1 + mass_parameter.Stage.M_avionics2 + mass_parameter.Stage.M_EPS2 +  mprop1 + mprop2 +M_pay;
