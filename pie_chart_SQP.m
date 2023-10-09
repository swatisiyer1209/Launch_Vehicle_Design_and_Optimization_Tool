%%PIE CHART
addpath('C:\Users\swati\Desktop\Improved Tool Results\Initial_Results');
load('LV_Tuned_Results.mat');

figure(3)
Mass_Distribution_Dry=[ Mass.Engine.M_eng1+Mass.Engine.M_eng2  Mass.Tank.M_tank1+Mass.Tank.M_tank2 Mass.Stage.M_IS1+Mass.Stage.M_IS2  Mass.Stage.M_fairing Mass.Stage.M_EPS1+Mass.Stage.M_avionics1+Mass.Stage.M_EPS2+Mass.Stage.M_avionics2  Mass.Stage.M_PLA  Mass.Stage.M_pad];
labels = {'Engine Structural Mass','Propellant Storage Mass','Interstage Mass', 'Fairing Mass', 'Electrical Mass', 'Payload Launcher Adapter Mass','Pad Interface Mass'};
pie(Mass_Distribution_Dry) ;
lgd = legend(labels);
title("Empty Mass Distribution");
savefig('C:\Users\swati\Desktop\LV Design Codes\Initial_Results\Empty Mass Distribution.fig');
figure(4)
Mass_Distribution=[Propulsion.Overview.Propellant_Mass1+Propulsion.Overview.Propellant_Mass2 Mass.Stage.M_struct1+Mass.Stage.M_struct2 Mission.Payload_Mass];
labels = {'Propellant Mass','Structural Mass', 'Payload Mass'};
pie(Mass_Distribution) ;
title("Total Mass Distribution");
lgd = legend(labels);
savefig('C:\Users\swati\Desktop\LV Design Codes\Initial_Results\Total Mass Distribution.fig');