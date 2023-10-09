%%CONSTRAINTS
function [c,ceq]= LV_constraints(x)
global propulsion_parameter ...
    geometry_parameter ...
    trajectory_parameter ...
    mass_parameter...
    

constants;
user_inputs;

prop_choice1=prop_choice(1);
prop_choice2=prop_choice(2);

%%degree to radian
long=longitude*(pi/180);
lat=latitude*(pi/180);

prop_choice1=prop_choice(1);
prop_choice2=prop_choice(2);
long=longitude*(pi/180);
lat=latitude*(pi/180);

%% RETRIEVE DESIGN VARIABLES
P_cc1=x(1);
P_cc2=x(2);
OF1=x(3);
OF2=x(4);
tb1=x(5);
tb2=x(6);
P_e1=x(7);
P_e2=x(8);
D_e1=x(9);
D_e2=x(10);
D_s1=x(11);
D_s2=x(12);
N_eng1 = x(13);
N_eng2 = x(14);


%% ANALYSIS
%PROPULSION MODEL
[propulsion_parameter]=propulsion_analysis(P_cc1,P_cc2, OF1, OF2,P_e1,P_e2,tb1,tb2,D_e1,D_e2,prop_choice1,prop_choice2,N_eng1,N_eng2);

%GEOMETRY MODEL
[geometry_parameter]=geometry_analysis(propulsion_parameter,D_s1,D_s2,prop_choice1,prop_choice2,N_eng1,N_eng2);

%WEIGHT MODEL
[mass_parameter] = weight_analysis(propulsion_parameter,geometry_parameter,D_s1,D_s2,M_pay,prop_choice1,prop_choice2,material_choice,N_eng1,N_eng2);

%TRAJECTORY PARAMETERS
[trajectory_parameter] = delta_V_analysis(propulsion_parameter,mass_parameter,h_a,h_p,lat,M_pay);

%TRAJECTORY CONSTRAINTS

%del_V_requirement
c1=(trajectory_parameter.del_V.del_V_req/trajectory_parameter.del_V.del_V_act)-1;

%Thrust-to-Weight Requirement
c5=(1.36/trajectory_parameter.T_W_LV)-1;

%Minimum Acceleration
c8=(1.5/trajectory_parameter.T_W1)-1;
c9=(0.9/trajectory_parameter.T_W2)-1;
%c9=((0.9)/((propulsion_parameter.Overview.Total_Thrust2)/(mass_parameter.Stage.M_struct2+propulsion_parameter.Overview.Propellant_Mass2)))-1;
%c8=((1.3*g)/((propulsion_parameter.Overview.Total_Thrust_SeaLevel1-g*(mass_parameter.Stage.M_struct1+propulsion_parameter.Overview.Propellant_Mass1))/(mass_parameter.Stage.M_struct1+propulsion_parameter.Overview.Propellant_Mass1)))-1;
%c9=((0.85*g)/((propulsion_parameter.Overview.Total_Thrust2-g*(mass_parameter.Stage.M_struct2+propulsion_parameter.Overview.Propellant_Mass2))/(mass_parameter.Stage.M_struct2+propulsion_parameter.Overview.Propellant_Mass2)))-1;

%GEOMETRY CONSTRAINTS
surface_coverage=[1 0.5 0.65 0.69 0.68 0.67 0.78 0.73 0.69];
c2=((N_eng1*D_e1^2)/(surface_coverage(N_eng1)*D_s1^2))-1;
c3=((N_eng2*D_e2^2)/(surface_coverage(N_eng2)*D_s2^2))-1;



%Summerfield Criterion
c4=((0.4*p_a)/P_e1)-1;


%epsilon 2 constraint
c6=(propulsion_parameter.IRT.epsilon2/150)-1;

%L/D Ratio constraint why does this go to maximum L/D -->
c7=((geometry_parameter.Stage.L_Stage1+geometry_parameter.Stage.L_Stage2+geometry_parameter.Fairing.L_fairing)/(D_s1*15))-1;

if prop_choice2==1 && prop_choice1==3
    c10=(propulsion_parameter.Overview.Specific_Impulse2/460)-1;

    c=[c1 c2 c3 c4 c5 c6 c7 c8 c9 c10] ;
else
    c=[c1 c2 c3 c4 c5 c6 c7 c8 c9] ;
end

ceq=[];

end
