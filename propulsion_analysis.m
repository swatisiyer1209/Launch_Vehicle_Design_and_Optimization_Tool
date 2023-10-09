function [propulsion_parameter]=propulsion_analysis(P_cc1,P_cc2, OF1, OF2,P_e1,P_e2,tb1,tb2,D_e1,D_e2,prop_choice1,prop_choice2,N_eng1,N_eng2)
constants;
%% CEA ANALYSIS
[gamma,T_cc,M]=CEA_Analysis(P_cc1,OF1,P_cc2,OF2,prop_choice1,prop_choice2);

%% IRT
[Isp_vac1,Isp_sl1,Isp_2,epsilon1,epsilon2,C_star1,C_star2]=IRT(gamma,T_cc,M,P_cc1,P_cc2,P_e1,P_e2);

%%  STAGE 1 ENGINE DEFINITION
% Mass flow rate calculation per engine (kg/s)
%Exit Area Calculation
A_e1=(pi*D_e1^2)/4;

%Throat Area Calculation
A_t1=A_e1/epsilon1;
D_t1=sqrt((4*A_t1)/pi);

m_dot1=(P_cc1*100000*A_t1)/C_star1;

%% STAGE 2 ENGINE DEFINITION
%Exit Area Calculation
A_e2=(pi*D_e2^2)/4;

%Throat Area Calculation
A_t2=A_e2/epsilon2;
D_t2=sqrt((4*A_t2)/pi);
m_dot2=(P_cc2*100000*A_t2)/C_star2;


%% Correcting IRT Values
Isp_vac1=eta_isp_vac*Isp_vac1;
Isp_sl1=eta_isp_sl*Isp_sl1;
Isp_2=eta_isp_vac*Isp_2;
m_dot1=eta_mdot*m_dot1;
m_dot2=eta_mdot*m_dot2;
m_dot1_tot=N_eng1*m_dot1;
m_dot2_tot=N_eng2*m_dot2;

%% Thrust Calculation (in N)

%% STAGE 1
F_vac1=N_eng1*(m_dot1*Isp_vac1*g);%+P_e1*100000*A_e1);
F_sl1=N_eng1*(m_dot1*Isp_sl1*g);%+(P_e1-p_a)*100000*A_e1);
%% STAGE 2
F_2=N_eng2*(m_dot2*Isp_2*g);%+P_e2*100000*A_e2);

%% Propellant Mass Calculation
mprop1=(1+k_unused)*(N_eng1*m_dot1*tb1);
mfuel1=mprop1/(1+OF1);
mox1=mprop1-mfuel1;

mprop2=(1+k_unused)*(N_eng2*m_dot2*tb2);
mfuel2=mprop2/(1+OF2);
mox2=mprop2-mfuel2;

%% Module Results:
propulsion_parameter.CEA.gamma1=gamma(1);
propulsion_parameter.CEA.gamma2=gamma(2);
propulsion_parameter.CEA.T_cc1=T_cc(1);
propulsion_parameter.CEA.T_cc2=T_cc(2);
propulsion_parameter.CEA.M1=M(1);
propulsion_parameter.CEA.M2=M(2);

propulsion_parameter.IRT.Isp_vac1=Isp_vac1;
propulsion_parameter.IRT.Isp_sl1=Isp_sl1;
propulsion_parameter.IRT.Isp_2=Isp_2;
propulsion_parameter.IRT.epsilon1=epsilon1;
propulsion_parameter.IRT.epsilon2=epsilon2;

propulsion_parameter.Engine.Exit_Diameter1=D_e1;
propulsion_parameter.Engine.Exit_Area1=A_e1;
propulsion_parameter.Engine.Throat_Diameter1=D_t1;
propulsion_parameter.Engine.Throat_Area1=A_t1;
propulsion_parameter.Engine.m_dot1=m_dot1;

propulsion_parameter.Engine.Exit_Diameter2=D_e2;
propulsion_parameter.Engine.Exit_Area2=A_e2;
propulsion_parameter.Engine.Throat_Diameter2=D_t2;
propulsion_parameter.Engine.Throat_Area2=A_t2;
propulsion_parameter.Engine.m_dot2=m_dot2;
propulsion_parameter.Engine.Engine_Thrust1=F_vac1/N_eng1;
propulsion_parameter.Engine.Engine_Thrust_SeaLevel1=F_sl1/N_eng1;
propulsion_parameter.Engine.Engine_Thrust2=F_2/N_eng2;

propulsion_parameter.Overview.Specific_Impulse1=Isp_vac1;
propulsion_parameter.Overview.Specific_Impulse_SeaLevel1=Isp_sl1;
propulsion_parameter.Overview.Specific_Impulse2=Isp_2;
propulsion_parameter.Overview.Mass_flow_rate_per_engine1=m_dot1;
propulsion_parameter.Overview.Mass_flow_rate_per_engine2=m_dot2;
propulsion_parameter.Overview.Total_Mass_flow_rate1=m_dot1_tot;
propulsion_parameter.Overview.Total_Mass_flow_rate2=m_dot2_tot;

propulsion_parameter.Overview.Total_Thrust1=F_vac1;
propulsion_parameter.Overview.Total_Thrust_SeaLevel1=F_sl1;
propulsion_parameter.Overview.Total_Thrust2=F_2;

propulsion_parameter.Overview.Propellant_Mass1=mprop1;
propulsion_parameter.Overview.Fuel_Mass1=mfuel1;
propulsion_parameter.Overview.Oxidizer_Mass1=mox1;

propulsion_parameter.Overview.Propellant_Mass2=mprop2;
propulsion_parameter.Overview.Fuel_Mass2=mfuel2;
propulsion_parameter.Overview.Oxidizer_Mass2=mox2;

propulsion_parameter.Overview.Area_Ratio1=epsilon1;
propulsion_parameter.Overview.Area_Ratio2=epsilon2;

