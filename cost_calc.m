function [cost_parameter] = cost_calc(propulsion_parameter,mass_parameter,N_eng1,N_eng2)
user_inputs;
prop_choice1=prop_choice(1);
prop_choice2=prop_choice(2);
% Conversion for European values
    MYr2EU=301200; % Man-year cost in euros
    MYrH=52*5*8; % Amount of hours in a man Year
    US2EU=301200/337100; %Conversion from dolalrs to EU needed for propellant cost
    f8=0.86; % productivity correction factor for EU (ESA)
    learning_factor=0.8;
    f9=1.07;
    f10=0.8;
    f11=0.5;
    n_stages=2;
    LpA=10;
    
    M_eng2=mass_parameter.Engine.M_eng2;
    M_eng1=mass_parameter.Engine.M_eng1;
    
    M_dry1= mass_parameter.Stage.M_struct1-M_eng1*N_eng1;
    M_prop1=propulsion_parameter.Overview.Propellant_Mass1;
    
    M_dry2= mass_parameter.Stage.M_struct2-M_eng2*N_eng2;
    M_prop2=propulsion_parameter.Overview.Propellant_Mass2;

    GLOW=mass_parameter.GLOM;
%% C_UNIT
    
    
    f4(1)=(1+87)^(log(learning_factor)/log(2));
    f4(2)=(1+87)^(log(learning_factor)/log(2));
    
    % Liquid Turbo Pump Engine Development Cost
    f4_engine(1)=((1+87)*N_eng1)^(log(learning_factor)/log(2));
    f4_engine(2)=((1+87)*N_eng2)^(log(learning_factor)/log(2));
    
    
    if prop_choice1==1 %LOX/LH2
     F_V(1)=1.84*M_dry1^0.59*f4(1)*f8*f10*f11;
     F_E(1)=3.15*M_eng1^0.535*f4_engine(1)*f8*f10*f11*N_eng1;
     P_C(1)=M_prop1*(6/7*0.21+1/7*7.16)*US2EU;
    end
    
    if prop_choice1==2 ||prop_choice1==3    %LOX/RP1 or LOX/CH4
    F_V(1)=1.265*M_dry1^0.59*f4(1)*f8*f10*f11;
    F_E(1)=1.9*M_eng1^0.535*f4_engine(1)*f8*f10*f11*N_eng1;
    P_C(1)=M_prop1*(3/3.56*0.21+1/3.56*3.2)*US2EU;
    end
    
    if prop_choice2==1 %LOX/LH2
    F_V(2)=1.84*M_dry2^0.59*f4(1)*f8*f10*f11;
    F_E(2)=3.15*M_eng1^0.535*f4_engine(1)*f8*f10*f11*N_eng1;
     P_C(2)=M_prop2*(6/7*0.21+1/7*7.16)*US2EU;
    end
    
    if prop_choice2==2 ||prop_choice2==3     %LOX/RP1 or LOX/CH4
        F_V(2)=1.265*M_dry2^0.59*f4(1)*f8*f10*f11;
        F_E(2)=1.9*M_eng1^0.535*f4_engine(1)*f8*f10*f11*N_eng1;
        P_C(2)=M_prop2*(3/3.56*0.21+1/3.56*3.2)*US2EU;
    end
    
    cost_parameter.C_unit=1.25^n_stages*(sum(F_V)+sum(F_E))*f9*MYr2EU; 
    cost_parameter.C_P=sum(P_C);
   
    
   
    
    %% C_C
    N=n_stages;
    fv(1)=0.8;
    fv(2)=0.8;
    f4_launch=1;
    fc=1;
    LpT=LpA;
    for j=2:1+LpT
        f4_launch=f4_launch+j^(log(learning_factor)/(log(2)));
    end
    f4_launch=LpT^(log(learning_factor)/log(2));
    
    cost_parameter.C_C=8*(GLOW/1e6)^0.67*LpA^(-0.9)*N^0.78*mean(fv)*fc*mean(f4_launch)*f8*f11;
    
    
    %% C_M
    
    Q_N(1)=0.4;
    Q_N(2)=0.4;
    
    
    cost_parameter.C_M=20*sum(Q_N)*LpA^(-0.65)*f4_launch*f8;
    
    
    
    
    %% C_DOC
    cost_parameter.C_DOC=(cost_parameter.C_C+cost_parameter.C_M)*MYr2EU+cost_parameter.C_P;
    %% IOC
    % Indirect Operations Cost
    x_data=[1 2 3 4 5 6 7 8 9 10 11 12];
    y_data=[45 34 29 27 24.5 23 22.5 21 20 19 18 17.5];
    cost_parameter.C_IOC=interp1(x_data,y_data,LpA,'pchip','extrap')*MYr2EU;
    
    %% C_OPS
    
   cost_parameter.C_ops=cost_parameter.C_DOC+cost_parameter.C_IOC;
    
    %% CPF
    cost_parameter.C_cpf=(cost_parameter.C_unit+cost_parameter.C_ops);