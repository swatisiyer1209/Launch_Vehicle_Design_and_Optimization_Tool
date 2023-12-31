function [gamma,T_cc,M]=CEA_Analysis(P_cc1,OF1,P_cc2,OF2,prop_choice1,prop_choice2)
% 
global prop_choice1
global prop_choice2

% Interpolation 

%LOX/LH2   
%OF              %gamma           5                6 
%PRESSURE        30              1.1506           1.1346 
%                200             1.1667           1.1473
 
%OF              %T_cc            5                6 
%PRESSURE        30              3218.27         3389.06 
%                200             3352.33         3595.43      

%OF              %M               5                6 
%PRESSURE        30              11.744          13.333 
%                200             11.899          13.610  


%LOX/RP1   
%OF              %gamma            2               3 
%PRESSURE        30              1.1666		    1.1277
%                200             1.1869		    1.1363 
 
%OF              %T_cc             2               3 
%PRESSURE        30              3274.74		3572.36
%                200             3402.37		3867.24                          


%OF              %M                2               3  
%PRESSURE        30              20.716		    24.422
%                200             20.955		    25.113

%LOX/CH4   
%OF              %gamma           1.35           3.35 
%PRESSURE        30              1.2527		    1.1273
%                200             1.2290		    1.1368
 
%OF              %T_cc            1.35           3.35
%PRESSURE        30              1401.87		3435.1
%                200             1546.98	    3681.64              

%OF              %M               1.35           3.35 
%PRESSURE        30              12.756		    21.302
%                200 	         13.371		    21.821


%% STAGE 1 
if prop_choice1==1 %LOX/LH2
    %gamma interpolation 
    a1=1.1506+(1.1346 -1.1506)*((OF1-5)/(6-5)); 
    b1=1.1667+(1.1473-1.1667)*((OF1-5)/(6-5)); 
    gamma1=a1+(b1-a1)*((200-P_cc1)/(200-30)); 
    
    %T_cc interpolation
    a2=3218.3+( 3389.06-3218.3)*((OF1-5)/(6-5));
    b2=3352.33+(3595.43-3352.33)*((OF1-5)/(6-5));
    T_cc1=a2+(b2-a2)*((200-P_cc1)/(200-30));
    
    %M interpolation
    a3=11.744+(13.333 -11.744)*((OF1-5)/(6-5));
    b3=11.899+(13.610 -11.899)*((OF1-5)/(6-5));
    M1=a3+(b3-a3)*((200-P_cc1)/(200-30));
end

if prop_choice1==2 %LOX/RP1
    %gamma interpolation
    a1=1.1666+(1.1277-1.1666)*((OF1-2)/(3-2));
    b1=1.1869+(1.1363-1.1869)*((OF1-2)/(3-2));
    gamma1=a1+(b1-a1)*((200-P_cc1)/(200-30));
    
    %T_cc interpolation
    a2=3274.74+(3572.36-3274.74)*((OF1-2)/(3-2));
    b2=3402.37+(3867.24-3402.37)*((OF1-2)/(3-2));
    T_cc1=a2+(b2-a2)*((200-P_cc1)/(200-30));
    
    %M interpolation
    a3=20.716+(24.422-20.716)*((OF1-2)/(3-2));
    b3=20.955+(25.113-20.955)*((OF1-2)/(3-2));
    M1=a3+(b3-a3)*((200-P_cc1)/(200-30));
end    
 

if prop_choice1==3 %LOX/CH4
    %gamma interpolation
    a1=1.2527+(1.1273-1.2527)*((OF1-1.35)/(3.35-1.35));
    b1=1.229+(1.1368-1.229)*((OF1-1.35)/(3.35-1.35));
    gamma1=a1+(b1-a1)*((200-P_cc1)/(200-30));
    
    %T_cc interpolation
    a2=1401.87+(3435.1-1401.87)*((OF1-1.35)/(3.35-1.35));
    b2=1546.98+(3681.64-1546.98)*((OF1-1.35)/(3.35-1.35));
    T_cc1=a2+(b2-a2)*((200-P_cc1)/(200-30));
    
    %M interpolation
    a3=12.756+(21.302-12.756)*((OF1-1.35)/(3.35-1.35));
    b3=13.371+(21.821-13.371)*((OF1-1.35)/(3.35-1.35));
    M1=a3+(b3-a3)*((200-P_cc1)/(200-30));
end 

%% STAGE 2
if prop_choice2==1 %LOX/LH2
    %gamma interpolation 
    a1=1.1506+(1.1346 -1.1506)*((OF1-5)/(6-5)); %1.1426
    b1=1.1667+(1.1473-1.1667)*((OF1-5)/(6-5)); %1.157
    gamma2=a1+(b1-a1)*((200-P_cc1)/(200-30)); %1.1494
    
    %T_cc interpolation
    a2=3218.3+( 3389.06-3218.3)*((OF1-5)/(6-5));%3303.68
    b2=3352.33+(3595.43-3352.33)*((OF1-5)/(6-5));
    T_cc2=a2+(b2-a2)*((200-P_cc1)/(200-30));
    
    %M interpolation
    a3=11.744+(13.333 -11.744)*((OF1-5)/(6-5));
    b3=11.899+(13.610 -11.899)*((OF1-5)/(6-5));
    M2=a3+(b3-a3)*((200-P_cc1)/(200-30));
end
if prop_choice2==2 %LOX/RP1
    %gamma interpolation
    a1=1.1666+(1.1277-1.1666)*((OF2-2)/(3-2));
    b1=1.1869+(1.1363-1.1869)*((OF2-2)/(3-2));
    gamma2=a1+(b1-a1)*((200-P_cc2)/(200-30));
    
    %T_cc interpolation
    a2=3274.74+(3572.36-3274.74)*((OF2-2)/(3-2));
    b2=3402.37+(3867.24-3402.37)*((OF2-2)/(3-2));
    T_cc2=a2+(b2-a2)*((200-P_cc2)/(200-30));
    
    %M interpolation
    a3=20.716+(24.422-20.716)*((OF2-2)/(3-2));
    b3=20.955+(25.113-20.955)*((OF2-2)/(3-2));
    M2=a3+(b3-a3)*((200-P_cc2)/(200-30));
end    
 

if prop_choice2==3 %LOX/CH4
    %gamma interpolation
    a1=1.2527+(1.1273-1.2527)*((OF2-1.35)/(3.35-1.35));
    b1=1.229+(1.1368-1.229)*((OF2-1.35)/(3.35-1.35));
    gamma2=a1+(b1-a1)*((200-P_cc2)/(200-30));
    
    %T_cc interpolation
    a2=1401.87+(3435.1-1401.87)*((OF2-1.35)/(3.35-1.35));
    b2=1546.98+(3681.64-1546.98)*((OF2-1.35)/(3.35-1.35));
    T_cc2=a2+(b2-a2)*((200-P_cc2)/(200-30));
    
    %M interpolation
    a3=12.756+(21.302-12.756)*((OF2-1.35)/(3.35-1.35));
    b3=13.371+(21.821-13.371)*((OF2-1.35)/(3.35-1.35));
    M2=a3+(b3-a3)*((200-P_cc2)/(200-30));
end 
%% OUTPUT
gamma=[gamma1 gamma2];
T_cc=[T_cc1 T_cc2];
M=[M1 M2];