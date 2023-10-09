%% Constants: 
%This file consists of constants assumed in this study


%Universal Gas constant (J/K mol)
R_A=8314;

%Gravitational Acceleration (m/s^2)
g=9.81;



%Mass flow rate correction Factor
eta_mdot=0.9458;

%Vacuum Specific Impulse correction Factor  
eta_isp_vac=0.9344;

%% FOR SA
%eta_mdot=0.96; %LH2 LH2
%eta_mdot=0.985; % RP1 RP1 or CH4 CH4

%eta_isp_vac=0.9762;%LH2 LH2
%eta_isp_vac=0.9672; %RP1 RP1
%eta_isp_vac=0.9692; %CH4 CH4


%Sea Level Specific Impulse correction Factor
eta_isp_sl=0.9063;

%Residual Propellant factor
k_unused=0.0032;

%Sea level Ambient Pressure (bar)
p_a=1.01325;

%Fuel Density (kg/m^3)
rho_f=[70.8 810 425];

%Oxidizer Density (kg/m^3)
rho_ox=1141;

%Ullage Volume Factor 
V_ullage=0.1;

%Methane Engine Length correction factor  
eta_L_methane=1.1571;

%Methane Engine Mass correction factor
eta_M_methane=1.3029;

% Storage tank Pressure (Pa)
P_tank=4*10^5;


%Safety Factor - Factors of safety are defined to cover chosen load level probability,
%assumed uncertainty in mechanical properties and manufacturing but not a
%lack of engineering effort.
%(https://ecss.nl/standard/ecss-e-st-32-10c-rev-2-structural-factors-of-safety-for-spaceflight-hardware-15-may-2019/)

SF=1.4;

%% MATERIAL AND PROPERTIES

%Material choices
%%CASTELLINI (page 134 Table 32) & STEPHANE

%material=["Al 7075-T6" "Al-Li 2195" "Al 2014-T6" "4340 Steel" "Ti 6Al-4V" "CFRP"];
%Tank material allowable stress

%Tank material allowable stress
sigma_t=[570*10^6 710*10^6 483*10^6 1793*10^6 1030*10^6  810*10^6];

%Propellant Storage Tank density (kg/m^3)
rho_tank=[2600  2700 7833 4420  1600];

k_SM=[1 1 1 1 1 1.59];

%% ENVIRONMENT PROPERTIES

%Radius of Earth (km)
R_e=6368;

%Gravitational Parameter (m^3/ s^2)
mu_e= 3.986004418e14;
