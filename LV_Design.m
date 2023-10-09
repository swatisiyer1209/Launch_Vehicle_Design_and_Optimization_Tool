%% This code runs an optimization of launch vehicle design based on user input;
%Limitations: 
% 1. Only 2 stage launchers possible
% 2. Based on assumed trajectory loss
% 3. Specific Impulse correction factor and Dsicharge coefficient same for different propellants

%% The user can select:
%1. Propellant Choices for both stages
    %1. LOX/LH2
    %2. LOX/RP1
    %3. LOX/CH4
    
%2. Launch vehicle material
    %1. Al 7075-T6
    %2. Al-Li 2195
    %3. Al 2014-T6
    %4. Steel
    %5. Titanium alloy
    %6. CFRP
    
%3. Objective
    %1. Minimize GLOM
    %2. Minimize dry weight

%% Apart from this, the user must input:
%1. Payload Mass
%2. Target Orbit Characteristics (Apogee and Perigee altitude,inclination)
%3. Launch site location (longitude and latitude)

%% The output from the analysis gives an overview of the optimized launch vehicle
%1. Propulsion Module (Thrust,Specific Impulse, Chamber Pressure, Mixture Ratio, Expansion Ratio)
%2. Trajectory Module (Delta V, Thrust-to-Weight ratio)
%3. Weights and Geometry Module (Overall mass and dimension of launch vehicle and its components)

%% START:

function LV_Design(M_pay,h_a,h_p,longitude,latitude,prop_choice,material_choice,opti_objective)
warning("off");

%%Retrieve user selection and inputs:
%Propellant choice for the stages
prop_choice1=prop_choice(1);
prop_choice2=prop_choice(2);

user_inputs;

global propulsion_parameter ...
    geometry_parameter ...
    mass_parameter ...
    trajectory_parameter...
    cost_parameter...

%% Initial Value (same as Falcon 9 v1.1 for LOX/RP1 and LOX/CH4, same as Delta IV for LOX/LH2)
%%STAGE 1
if prop_choice1==1 %LOX/LH2
    P_cc1=102.6;
    OF1=6;
    tb1=245;
    P_e1=0.5779;
    D_e1=2.43;
    D_s1=5;
    N_eng1=1;
end

if prop_choice1==2 || prop_choice1==3 %LOX/RP1 || LOX/CH4
    P_cc1=97;
    OF1=2.34;
    tb1=180;
    P_e1=0.5107;
    D_e1=1.07;
    D_s1=3.7;
    N_eng1=9;
end

%%STAGE 2
if prop_choice2==1 %LOX/LH2
    P_cc2=44.4;
    OF2=5.88;
    tb2=400;
    P_e2=0.0108;
    D_e2=2.15;
    D_s2=5;
    N_eng2=1;
end
if prop_choice2==2 || prop_choice2==3 %LOX/RP1 | |LOX/CH4
    P_cc2=97;
    OF2=2.36;
    tb2=375;
    P_e2=0.0629;
    D_e2=2.5;
    D_s2=3.7;
    N_eng2=1;
end

x0=[P_cc1 P_cc2 OF1 OF2 tb1 tb2 P_e1 P_e2 D_e1 D_e2 D_s1 D_s2 N_eng1 N_eng2];
%% Bounds
%STAGE 1
if prop_choice1==1
    lb_of1=5;
    ub_of1=6;
end
if prop_choice1==2
    lb_of1=2;
    ub_of1=3;
end
if prop_choice1==3
    lb_of1=1.35;
    ub_of1=3.35;
end

%STAGE 2
if prop_choice2==1
    lb_of2=5;
    ub_of2=6;
end
if prop_choice2==2
    lb_of2=2;
    ub_of2=3;
end
if prop_choice2==3
    lb_of2=1.35;
    ub_of2=3.35;
end

lb=[30 30 lb_of1 lb_of2 100 100 0.05 0.001 0.52 0.94 3 3 1 1];
ub=[200 200 ub_of1 ub_of2 300 500 1 0.1 5 5 5.5 5.5 9 3];

%% Optimization

%% Genetic Algorithm    
    fun= @Optim_Analysis;
   nvars=14;

    A=[];
    b=[];
    Aeq=[];
    beq=[];
    nonlcon= @LV_constraints;
    intcon=[13 14];
    options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', {@gaplotbestf,@gaplotstopping});
    options.InitialPopulationMatrix = x0;
    options.Display='iter';
    
    tic;
    [x,fval,exitflag,output]=ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,intcon,options);

    toc;
    
    % Saved file
    savefig('C:\Users\swati\Desktop\LV Design Codes\Initial_Results\Genetic Algorithm.fig');
    elapsedTime=toc;
    iterations=output.generations;
    
    if exitflag < 0
        fun= @Optim_Analysis;
        nvars=14;
        A=[];
        b=[];
        Aeq=[];
        beq=[];
        nonlcon= @LV_constraints;
        intcon=[13 14];
        options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', {@gaplotbestf,@gaplotstopping});
        options.InitialPopulationMatrix = x0;
        options.Display='iter';
    
        tic;
    [x,fval,exitflag,output]=ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,intcon,options);
        toc;
        %Saved file
        savefig('C:\Users\swati\Desktop\LV Design Codes\Initial_Results\Genetic Algorithm2.fig');
        elapsedTime=elapsedTime+toc;
        iterations=iterations+output.generations;
    end
    

    % Results.mat
    prop_option=["LOX/LH2" "LOX/RP1" "LOX/CH4"];
    material_option=["Al 7075-T6" "Al-Li 2195" "Al 2014-T6" "4340 Steel" "Ti 6Al-4V"  "CFRP" ];
    objective_option=["Minimize Gross Lift-Off Mass" "Minimize Dry Mass" "Minimize Cost per Flight"];
    
    Results_initial.Mission.Payload_Mass=M_pay;
    Results_initial.Mission.Apogee=h_a;
    Results_initial.Mission.Perigee=h_p;
    Results_initial.Mission.Longitude=longitude;
    Results_initial.Mission.Latitude=latitude;
    
    Results_initial.User_Input.Stage1_Propellant=prop_option(prop_choice1);
    Results_initial.User_Input.Stage2_Propellant=prop_option(prop_choice2);
    Results_initial.User_Input.Material=material_option(material_choice);
    Results_initial.User_Input.Material=objective_option(opti_objective);
    
    Results_initial.Design_Variables.Chamber_Pressure1=x(1);
    Results_initial.Design_Variables.Chamber_Pressure2=x(2);
    Results_initial.Design_Variables.Mixture_Ratio1=x(3);
    Results_initial.Design_Variables.Mixture_Ratio2=x(4);
    Results_initial.Design_Variables.Burn_time1=x(5);
    Results_initial.Design_Variables.Burn_time2=x(6);
    Results_initial.Design_Variables.Exit_Pressure1=x(7);
    Results_initial.Design_Variables.Exit_Pressure2=x(8);
    Results_initial.Design_Variables.Exit_Diameter1=x(9);
    Results_initial.Design_Variables.Exit_Diameter2=x(10);
    Results_initial.Design_Variables.Stage_Diameter1=x(11);
    Results_initial.Design_Variables.Stage_Diameter2=x(12);
    Results_initial.Design_Variables.Number_of_engines1=round(x(13));
    Results_initial.Design_Variables.Number_of_engines2=round(x(14));
    
    Results_initial.Propulsion=propulsion_parameter;
    Results_initial.Geometry=geometry_parameter;
    Results_initial.Mass=mass_parameter;
    Results_initial.Trajectory=trajectory_parameter;  
    Cost=cost_parameter;
    
    constants;
    c1=(Results_initial.Trajectory.del_V.del_V_req/Results_initial.Trajectory.del_V.del_V_act);
    c2=(N_eng1*D_e1^2)/(D_s1^2);
    c3=(N_eng2*D_e2^2)/(D_s2^2);
    c4=P_e1/1.10325;
    c5=(Results_initial.Trajectory.T_W_LV);
    c6=Results_initial.Propulsion.IRT.epsilon2;
    c7=(Results_initial.Geometry.Stage.L_Stage1+Results_initial.Geometry.Stage.L_Stage2+Results_initial.Geometry.Fairing.L_fairing)/x(11) ;
    c8=(Results_initial.Trajectory.T_W1);
    c9=(Results_initial.Trajectory.T_W2);
    
    Results_initial.Constraint.Del_V=c1; %del_V_act- del-V_req >=0
    Results_initial.Constraint.Exit_Dia1= c2; %0.8Ds1>=3*D_e1
    Results_initial.Constraint.Exit_Dia2= c3; %0.8Ds2>=3*D_e2
    Results_initial.Constraint.Summerfield=c4; %P_e/P_a >=0.4
    Results_initial.Constraint.T_W1=c5; %T-W1>1.01
    Results_initial.Constraint.epsilon2=c6; %epsilon2 <200
    Results_initial.Constraint.L_D=c7; %L_D <20
    Results_initial.Constraint.Min_acc_1=c8; %del_V1_frac
    Results_initial.Constraint.Min_acc_2=c9; %del_V2_frac
   
    %Saved file
    save('C:\Users\swati\Desktop\LV Design Codes\Initial_Results\LV_Results_initial.mat','Results_initial','elapsedTime','iterations')    ;
        
 %RESULTS.dat
  constants;
  user_inputs;


if h_a<=1600
    orbit="LEO";
end
if h_a >1600
    orbit="GTO";
end
if prop_choice1==1
    prop_option1="LOX-LH2";
end
if prop_choice1==2
    prop_option1="LOX-RP1";
end
if prop_choice1==3
    prop_option1="LOX-CH4";
end

if prop_choice2==1
    prop_option2="LOX-LH2";
end
if prop_choice2==2
    prop_option2="LOX-RP1";
end
if prop_choice2==3
    prop_option2="LOX-CH4";
end
if material_choice == 1
    material_str="Al 7075-T6";
end

if material_choice == 2
    material_str="Al-Li 2195";
end

if material_choice == 3
    material_str="Al 2014-T6";
end

if material_choice == 4
    material_str="4340 Steel";
end

if material_choice == 5
    material_str= "Ti 6Al-4V" ;
end

if material_choice==6
    material_str="CFRP";
end

mypath='C:\Users\swati\Desktop\LV Design Codes\Initial_Results\Initial_Results';
 
baseFileName  =fullfile(mypath,sprintf('LV_Results_initial_%s_%s_Material_%d_%s.dat',prop_option1,prop_option2,material_choice,orbit));

Results_initial_to_File={'USER INPUT', '', ''; ....
                '***********', '', '';...
                'Payload Mass(kg)', M_pay, '';...
                'Perigee Altitude (km)',h_p,'';...
                'Apogee Altitude (km)',h_a,'';...
                'Propellant', prop_option1,prop_option2;...
                'Material Choice',material_str,'';...
                'Longitude',longitude,'';...
                'Latitude',latitude,'';...
                '','','';...
                '','','';...
                'OPTIMUM DESIGN VARIABLES','','';...
                '************************', '', '';...
                'Chamber Pressure (bar)',Results_initial.Design_Variables.Chamber_Pressure1,Results_initial.Design_Variables.Chamber_Pressure2;...
                'Mixture Ratio',Results_initial.Design_Variables.Mixture_Ratio1,Results_initial.Design_Variables.Mixture_Ratio2;...
                'Burn Time (s)',Results_initial.Design_Variables.Burn_time1,Results_initial.Design_Variables.Burn_time2;...
                'Exit Pressure (bar)',Results_initial.Design_Variables.Exit_Pressure1,Results_initial.Design_Variables.Exit_Pressure2;...
                'Engine Exit Diameter (m)',Results_initial.Design_Variables.Exit_Diameter1,Results_initial.Design_Variables.Exit_Diameter2;...
                'Stage Diameter (m)',Results_initial.Design_Variables.Stage_Diameter1,Results_initial.Design_Variables.Stage_Diameter2;...
                'Number of Engines',Results_initial.Design_Variables.Number_of_engines1,Results_initial.Design_Variables.Number_of_engines2;...
                 '','','';...
                '','','';...
                'PROPULSION CHARACTERISTICS','','';...
                '**************************', '', '';...
                'Vacuum Specific Impulse (s)',Results_initial.Propulsion.Overview.Specific_Impulse1,Results_initial.Propulsion.Overview.Specific_Impulse2;...
                'Vacuum Thrust (kN)',Results_initial.Propulsion.Overview.Total_Thrust1/1000,Results_initial.Propulsion.Overview.Total_Thrust2/1000;...
                'Delta V (m/s)',Results_initial.Trajectory.del_V.del_V1,Results_initial.Trajectory.del_V.del_V2;...
                 '','','';...
                '','','';...
                'GEOMETRY CHARACTERISTICS','','';...
                '**************************', '', '';...
                'Expansion Ratio',Results_initial.Propulsion.IRT.epsilon1,Results_initial.Propulsion.IRT.epsilon2;...
                'Engine Length (m)',Results_initial.Geometry.Engine.L_eng1,Results_initial.Geometry.Engine.L_eng2;...
                'Tank Length (m)',Results_initial.Geometry.Stage.L_tank1,Results_initial.Geometry.Stage.L_tank2;...
                'Interstage Length (m)',Results_initial.Geometry.Stage.L_IS1,Results_initial.Geometry.Stage.L_IS2;...
                'Fairing Length (m)','',Results_initial.Geometry.Fairing.L_fairing;...
                '','','';...
                '','','';...
                'MASS CHARACTERISTICS','','';...
                '*********************', '', '';...
                'Propellant Mass (kg)',Results_initial.Propulsion.Overview.Propellant_Mass1,Results_initial.Propulsion.Overview.Propellant_Mass2;...
                'Engine Mass (kg)',Results_initial.Mass.Engine.M_eng1_tot,Results_initial.Mass.Engine.M_eng2_tot;...
                'Tank Mass (kg)', Results_initial.Mass.Tank.M_tank1,Results_initial.Mass.Tank.M_tank2;...
                'Interstage Mass (kg)',Results_initial.Mass.Stage.M_IS1,Results_initial.Mass.Stage.M_IS2;...
                'Stage Dry Mass (kg)',Results_initial.Mass.Stage.M_struct1,Results_initial.Mass.Stage.M_struct2;...
                'Avionics Mass (kg)',Results_initial.Mass.Stage.M_avionics1,Results_initial.Mass.Stage.M_avionics2;...
                'EPS Mass (kg)',Results_initial.Mass.Stage.M_EPS1,Results_initial.Mass.Stage.M_EPS2;...
                'Payload Adapter Mass (kg)','',Results_initial.Mass.Stage.M_PLA;...
                'Payload Fairing Mass (kg)','',Results_initial.Mass.Stage.M_fairing;...
                'Launch Pad Interface Mass (kg)',Results_initial.Mass.Stage.M_pad,'';...
                '','','';...
                '','','';...
                'VEHICLE OVERVIEW','','';...
                '*****************', '', '';...
                'Gross Lift-off Weight (kg)',Results_initial.Mass.GLOM,'';...
                'Total Propellant Mass (kg)',Results_initial.Propulsion.Overview.Propellant_Mass1+Results_initial.Propulsion.Overview.Propellant_Mass2,'';...
                'Total Dry Mass (kg)',Results_initial.Mass.Stage.M_struct1+ Results_initial.Mass.Stage.M_struct2,'';...
                'Launch Vehicle Length (m)',Results_initial.Geometry.Stage.L_Stage1+Results_initial.Geometry.Stage.L_Stage2+Results_initial.Geometry.Fairing.L_fairing,''};

fid_op=fopen(baseFileName,"wt");

% Writing data to file
writecell(Results_initial_to_File,baseFileName);


%% TUNING THE OPTIMUM VALUES: (GA+SQP)

N_eng1=x(13);
N_eng2=x(14);

user_inputs_SQP;
x0_SQP=x(1:12); %Storing only non-interger values

global propulsion_parameter ...
    geometry_parameter ...
    mass_parameter ...
    trajectory_parameter

lb_SQP=[30 30 lb_of1 lb_of2 100 100 0.05 0.001 0.52 0.94 3 3];
ub_SQP=[200 200 ub_of1 ub_of2 300 500 1 0.1 5 5 5.5 5.5];

options=optimoptions(@fmincon,...
        'Algorithm','sqp',...
        'Tolx',1e-10,...   %size smallest step. Smaller step causes optimizer to stop
        'TolFun',1e-6,... %TolFun is a lower bound on the change in the value of the objective function during a step
        'TolCon',1e-6,...
        'Display','Iter',...
        'DiffMinChange',1e-5,...
        'DiffMaxChange',1e-3,...
        'FinDiffType','Central',...
        'MaxFunEvals',50000,...
        'MaxIter',10000,...
        'PlotFcns',{@optimplotx,...
        @optimplotfval,@optimplotfirstorderopt});
    
    %     options=optimoptions(@fmincon, 'Display', 'iter','Algorithm','sqp','MaxIterations',15000,'MaxFunEvals',50e4,'FiniteDifferenceStepSize',1e-5,'PlotFcns',{@optimplotx,...
    %        @optimplotfval,@optimplotfirstorderopt});
    
    tic;
    [x,fval,exitflag,output]=fmincon(@(x) Optim_Analysis_SQP(x),x0_SQP,[],[],[],[],lb,ub,@(x) LV_constraints_SQP(x),options);
    toc;
    %Saved file
    savefig('C:\Users\swati\Desktop\LV Design Codes\Initial_Results\Optimization Function Plot.fig');
    
    elapsedTime=elapsedTime+toc;
    iterations=iterations+output.iterations;
    
    
% Tuned RESULTS
objective_option=["Minimize GLOM","Minimize Dry Mass" ,"Minimize Cost per Flight"];
    Mission.Payload_Mass=M_pay;
    Mission.Apogee=h_a;
    Mission.Perigee=h_p;
    Mission.Longitude=longitude;
    Mission.Latitude=latitude;
    
    User_Input.Stage1_Propellant=prop_option(prop_choice1);
    User_Input.Stage2_Propellant=prop_option(prop_choice2);
    User_Input.Material=material_option(material_choice);
    User_Input.Optimization_Objective=objective_option(opti_objective);
    
    Design_Variables.Chamber_Pressure1=x(1);
    Design_Variables.Chamber_Pressure2=x(2);
    Design_Variables.Mixture_Ratio1=x(3);
    Design_Variables.Mixture_Ratio2=x(4);
    Design_Variables.Burn_time1=x(5);
    Design_Variables.Burn_time2=x(6);
    Design_Variables.Exit_Pressure1=x(7);
    Design_Variables.Exit_Pressure2=x(8);
    Design_Variables.Exit_Diameter1=x(9);
    Design_Variables.Exit_Diameter2=x(10);
    Design_Variables.Stage_Diameter1=x(11);
    Design_Variables.Stage_Diameter2=x(12);
    Design_Variables.Number_of_engines1=N_eng1;
    Design_Variables.Number_of_engines2=N_eng2;
    
    Propulsion=propulsion_parameter;
    Geometry=geometry_parameter;
    Mass=mass_parameter;
    Trajectory=trajectory_parameter;  
    Cost=cost_parameter;
    constants;
    c1=(Trajectory.del_V.del_V_req/Trajectory.del_V.del_V_act);
    c2=(N_eng1*D_e1^2)/(D_s1^2);
    c3=(N_eng2*D_e2^2)/(D_s2^2);
    c4=P_e1/1.10325;
    c5=(Trajectory.T_W_LV);
    c6=Propulsion.IRT.epsilon2;
    c7=(Geometry.Stage.L_Stage1+Geometry.Stage.L_Stage2+Geometry.Fairing.L_fairing)/x(11) ;
    c8=(Trajectory.T_W1);
    c9=(Trajectory.T_W2);
    
    
    Constraint.Del_V=c1; %del_V_act- del-V_req >=0
    Constraint.Exit_Dia1= c2; %0.8Ds1>=3*D_e1
    Constraint.Exit_Dia2= c3; %0.8Ds2>=3*D_e2
    Constraint.Summerfield=c4; %P_e/P_a >=0.4
    Constraint.T_W1=c5; %T-W1>1.01
    Constraint.epsilon2=c6; %epsilon2 <200
    Constraint.L_D=c7; %L_D <20
    Constraint.Min_acc_1=c8; %del_V1_frac
    Constraint.Min_acc_2=c9; %del_V2_frac
    
% Saved file
    save('C:\Users\swati\Desktop\LV Design Codes\Initial_Results\LV_Tuned_Results.mat','Mission','User_Input','Design_Variables','Propulsion','Mass','Trajectory','Geometry','Constraint') ;
    pie_chart_SQP;    
    
    mypath='C:\Users\swati\Desktop\LV Design Codes\Initial_Results';

    baseFileName =fullfile(mypath, sprintf('LV_Tuned_Results_%s_%s_Material_%d_%s.dat',prop_option1,prop_option2,material_choice,orbit));

Results_tuned_to_File={'USER INPUT', '', ''; ....
                '***********', '', '';...
                'Payload Mass(kg)', M_pay, '';...
                'Perigee Altitude (km)',h_p,'';...
                'Apogee Altitude (km)',h_a,'';...
                'Propellant', prop_option1,prop_option2;...
                'Material Choice',material_str,'';...
                'Longitude',longitude,'';...
                'Latitude',latitude,'';...
                '','','';...
                '','','';...
                'OPTIMUM DESIGN VARIABLES','','';...
                '************************', '', '';...
                'Chamber Pressure (bar)',Design_Variables.Chamber_Pressure1,Design_Variables.Chamber_Pressure2;...
                'Mixture Ratio',Design_Variables.Mixture_Ratio1,Design_Variables.Mixture_Ratio2;...
                'Burn Time (s)',Design_Variables.Burn_time1,Design_Variables.Burn_time2;...
                'Exit Pressure (bar)',Design_Variables.Exit_Pressure1,Design_Variables.Exit_Pressure2;...
                'Engine Exit Diameter (m)',Design_Variables.Exit_Diameter1,Design_Variables.Exit_Diameter2;...
                'Stage Diameter (m)',Design_Variables.Stage_Diameter1,Design_Variables.Stage_Diameter2;...
                'Number of Engines',Design_Variables.Number_of_engines1,Design_Variables.Number_of_engines2;...
                 '','','';...
                '','','';...
                'PROPULSION CHARACTERISTICS','','';...
                '**************************', '', '';...
                'Vacuum Specific Impulse (s)',Propulsion.Overview.Specific_Impulse1,Propulsion.Overview.Specific_Impulse2;...
                'Vacuum Thrust (kN)',Propulsion.Overview.Total_Thrust1/1000,Propulsion.Overview.Total_Thrust2/1000;...
                'Delta V (m/s)',Trajectory.del_V.del_V1,Trajectory.del_V.del_V2;...
                 '','','';...
                '','','';...
                'GEOMETRY CHARACTERISTICS','','';...
                '**************************', '', '';...
                'Expansion Ratio',Propulsion.IRT.epsilon1,Propulsion.IRT.epsilon2;...
                'Engine Length (m)',Geometry.Engine.L_eng1,Geometry.Engine.L_eng2;...
                'Tank Length (m)',Geometry.Stage.L_tank1,Geometry.Stage.L_tank2;...
                'Interstage Length (m)',Geometry.Stage.L_IS1,Geometry.Stage.L_IS2;...
                'Fairing Length (m)','',Geometry.Fairing.L_fairing;...
                '','','';...
                '','','';...
                'MASS CHARACTERISTICS','','';...
                '*********************', '', '';...
                'Propellant Mass (kg)',Propulsion.Overview.Propellant_Mass1,Propulsion.Overview.Propellant_Mass2;...
                'Engine Mass (kg)',Mass.Engine.M_eng1_tot,Mass.Engine.M_eng2_tot;...
                'Tank Mass (kg)', Mass.Tank.M_tank1,Mass.Tank.M_tank2;...
                'Interstage Mass (kg)',Mass.Stage.M_IS1,Mass.Stage.M_IS2;...
                'Stage Dry Mass (kg)',Mass.Stage.M_struct1,Mass.Stage.M_struct2;...
                'Avionics Mass (kg)',Mass.Stage.M_avionics1,Mass.Stage.M_avionics2;...
                'EPS Mass (kg)',Mass.Stage.M_EPS1,Mass.Stage.M_EPS2;...
                'Payload Adapter Mass (kg)','',Mass.Stage.M_PLA;...
                'Payload Fairing Mass (kg)','',Mass.Stage.M_fairing;...
                'Launch Pad Interface Mass (kg)',Mass.Stage.M_pad,'';...
                '','','';...
                '','','';...
                'VEHICLE OVERVIEW','','';...
                '*****************', '', '';...
                'Gross Lift-off Weight (kg)',Mass.GLOM,'';...
                'Total Propellant Mass (kg)',Propulsion.Overview.Propellant_Mass1+Propulsion.Overview.Propellant_Mass2,'';...
                'Total Dry Mass (kg)',Mass.Stage.M_struct1+ Mass.Stage.M_struct2,'';...
                'Launch Vehicle Length (m)',Geometry.Stage.L_Stage1+Geometry.Stage.L_Stage2+Geometry.Fairing.L_fairing,''};

fid_op=fopen(baseFileName,"wt");

% Writing data to file
writecell(Results_tuned_to_File,baseFileName);


%% FRT Input File
format longG
t = now;
d = datetime(t,'ConvertFrom','datenum');
%% FILE FOR FRT INPUT
baseFileName_FRT =fullfile(mypath, sprintf('FRT_input_%s_%s_%s.dat',prop_option1,prop_option2,orbit));

if prop_choice1==1
    prop_option1="LH2/LOX";
end
if prop_choice1==2
    prop_option1="RP1/LOX";
end
if prop_choice1==3
    prop_option1="CH4/LOX";
end

if prop_choice2==1
    prop_option2="LH2/LOX";
end
if prop_choice2==2
    prop_option2="RP1/LOX";
end
if prop_choice2==3
    prop_option2="CH4/LOX";
end

case_Name = sprintf('%s_%s_%s',prop_option1,prop_option2,orbit);

FRT_File={'Name', ';',case_Name;...
           'Date Saved',';',d;...
           
           'Type',';','Single Run';...
           
          '%% Start of Data %%','','';...
          
          '%Initial Conditions','','';...
          
          'app.H0.Value',';', 0.0000;...
          
          'app.X0.Value',';', 0.0000;...
          
          'app.V0.Value',';'   ,0.0100;...
          
          'app.gamma.Value',';',     89.9000;...
          
          'app.beta.Value',';',     90.0000;...
          
          'app.Lat.Value',';',     latitude;...
          
          'app.Long.Value',';',    longitude;...
          
          '% Mission Parameters','','';...
          
          'app.PayloadMass.Value',';',   M_pay;...
          
          'app.Objective.Value',';',   'Orbit';...
          
          'app.AscentDynPressureLimit.Value',';',   30.0000;...
          
          'app.ExpendablePayload.Value',';',   9782.4270;...
          
          'app.ExpendablePayloadOptions.Value',';',   'Known Value';...
          
          'app.Apogee.Value',';',   h_a;...
          
          'app.Perigee.Value',';',   h_p;...
          
          'app.Circular.Value',';', 0;...
          
          'app.Inclination.Value',';', 28.4;...
          
          'app.InclinationCheck.Value',';', 0;...
                    
          'app.FairingMass.Value',';', Mass.Stage.M_fairing;...
           
          '% First Stage Definition','','';...
          
          'app.D0_1.Value',';', Design_Variables.Stage_Diameter1;...
          
          'app.EmptyMass1.Value',';', Mass.Stage.M_struct1;...
          
          'app.PropMass1.Value',';', Propulsion.Overview.Propellant_Mass1;...
          
          'app.EngineMass1.Value',';', Mass.Engine.M_eng1_tot;...
          
          'app.Rn1.Value',';', 1.5000;...
          
          'app.L1.Value',';', Mass.Tank.M_tank1+Mass.Stage.M_IS1;...
          
          'app.SepOption.Value',';', 'MECO';...
          
          'Material1',';', 'Aluminium';...
          
          'app.T0.Value',';', 280.0000;...
          
          'app.ShellMass.Value',';', 2000.0000;...
          
          'app.InternalHeat.Value',';', 0.0000;...
          
          'app.Ae1.Value',';', (pi*(Design_Variables.Exit_Diameter1)^2)/4;...
          
          'app.At1.Value',';', ((pi*(Design_Variables.Exit_Diameter1)^2)/4)/Propulsion.IRT.epsilon1;...
                    
          'app.Prop1.Value',';', prop_option1;...
          
          'app.Pc1.Value',';',Design_Variables.Chamber_Pressure1*100000 ;...
          
          'app.N_engines1.Value',';',Design_Variables.Number_of_engines1;...
          
          'app.ModelCorrectionDropDown.Value',';','Vacuum';...
          
          'app.FT1_corr.Value',';',Propulsion.Overview.Total_Thrust1;...
          
          'app.Isp1_corr.Value',';',Propulsion.Overview.Specific_Impulse1;...
          
          'app.FT_min1.Value',';',11.0000;...
          
           '% Second  Stage Definition','','';...
          
          'app.D0_2.Value',';', Design_Variables.Stage_Diameter2;...
          
          'app.EmptyMass2.Value',';', Mass.Stage.M_struct2;...
          
          'app.PropMass2.Value',';', Propulsion.Overview.Propellant_Mass2;...
          
          'app.EngineMass2.Value',';', Mass.Engine.M_eng2_tot;...
          
          'app.Rn2.Value',';', 1.5000;...
          
          'app.L2.Value',';', Mass.Tank.M_tank2+Mass.Stage.M_IS2;...
          
          'Material2',';', 'Aluminium';...
          
          'app.T0_2.Value',';', 280.0000;...
          
          'app.ShellMass_2.Value',';', 500.0000;...
          
          'app.InternalHeat_2.Value',';', 0.0000;...
          
          'app.Ae2.Value',';', (pi*(Design_Variables.Exit_Diameter2)^2)/4;...
          
          'app.At2.Value',';', ((pi*(Design_Variables.Exit_Diameter2)^2)/4)/Propulsion.IRT.epsilon2;...
          
          'app.Prop2.Value',';', prop_option2;...
          
          'app.Pc2.Value',';',Design_Variables.Chamber_Pressure2*100000 ;...
          
          'app.N_engines2.Value',';',Design_Variables.Number_of_engines2;...
          
          'app.ModelCorrectionDropDown.Value',';','Vacuum';...
          
          'app.FT2_corr.Value',';',Propulsion.Overview.Total_Thrust2;...
          
          'app.Isp2_corr.Value',';',Propulsion.Overview.Specific_Impulse2;...
          
          'app.FT_min2.Value',';',50.0000};
          
    
fid_op=fopen(baseFileName_FRT,"wt");
writecell(FRT_File,baseFileName_FRT);
