function [trajectory_parameter]= delta_V_analysis(propulsion_parameter,mass_parameter,h_a,h_p,latitude,M_pay)

constants;
F_vac1=propulsion_parameter.Overview.Total_Thrust1;
Isp_vac1=propulsion_parameter.Overview.Specific_Impulse1;
Isp_2=propulsion_parameter.Overview.Specific_Impulse2;

mprop1=propulsion_parameter.Overview.Propellant_Mass1;
mprop2= propulsion_parameter.Overview.Propellant_Mass2;

GLOM=mass_parameter.GLOM;
M_struct1=mass_parameter.Stage.M_struct1;

R_p=(R_e+h_p)*10^3;%in m
R_a=(R_e+h_a)*10^3;

%ORBITAL VELOCITY
a=(R_p+R_a)/2;

V_orbital=sqrt(mu_e*((2/R_p)-(1/a)))+0.25*sqrt(2*g*(R_p-R_e*1000));


del_V_loss=1570; %literature
%del_V_loss=1193.6; %LH2 LH2
%del_V_loss=1264; %CH4 CH4
%del_V_loss=1262.9; %RP1 RP1
%del_V_loss=1324.5; %CH4-LH2
del_V_rot=464*cos(latitude);


trajectory_parameter.del_V.del_V_req=(V_orbital+del_V_loss+del_V_rot); %DEL_V REQUIRED BY THE LAUNCHER TO NOT ONLY REACH ORBIT BUT ALSO OVERCOME LOSSES

%DEL V POTENTIAL FROM DESIGNED LAUNCH VEHICLE

trajectory_parameter.del_V.del_V1=(Isp_vac1*g)*log(GLOM/(GLOM-mprop1));
trajectory_parameter.del_V.del_V2=(Isp_2*g)*log((GLOM-mprop1-M_struct1)/(GLOM-mprop1-M_struct1-mprop2));
trajectory_parameter.del_V.del_V_act=trajectory_parameter.del_V.del_V1+trajectory_parameter.del_V.del_V2;

%initial Thrust to weight

trajectory_parameter.T_W_LV=(propulsion_parameter.Overview.Total_Thrust_SeaLevel1/(GLOM*g));
trajectory_parameter.T_W1=(propulsion_parameter.Overview.Total_Thrust_SeaLevel1/((M_struct1+mprop1)*g));
trajectory_parameter.T_W2=( propulsion_parameter.Overview.Total_Thrust2/((GLOM-M_struct1-mprop1)*g));
end