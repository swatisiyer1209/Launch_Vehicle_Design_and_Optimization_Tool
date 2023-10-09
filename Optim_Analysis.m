function [f]= Optim_Analysis(x)
user_inputs;
global propulsion_parameter ...
    geometry_parameter ...
    trajectory_parameter ...
    mass_parameter ...
    cost_parameter...


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

%MASS MODEL
[mass_parameter] = weight_analysis(propulsion_parameter,geometry_parameter,D_s1,D_s2,M_pay,prop_choice1,prop_choice2,material_choice,N_eng1,N_eng2);

%TRAJECTORY PARAMETERS
[trajectory_parameter] = delta_V_analysis(propulsion_parameter,mass_parameter,h_a,h_p,lat,M_pay);

% [cost_parameter] = cost_calc(propulsion_parameter,mass_parameter,N_eng1,N_eng2);

%OBJECTIVE FUNCTION
if opti_objective ==1 %minimize GLOM
    obj_parameter=mass_parameter.GLOM;
    f=LV_objective(obj_parameter);
end

if opti_objective==2 %dry weight
    obj_parameter=mass_parameter.Stage.M_struct1+mass_parameter.Stage.M_struct2;
    f=LV_objective(obj_parameter);
end
% 
% if opti_objective==3 %cost
%     obj_parameter=cost_parameter.C_cpf;
%     f=LV_objective(obj_parameter);
% end


