function Results(propulsion_parameter,geometry_parameter,mass_parameter,trajectory_parameter,x)
constants;
user_inputs;
prop_option=["LOX/LH2" "LOX/RP1" "LOX/CH4"];
material_option=["Al 7075-T6" "Al-Li 2195" "Al 2014-T6" "4340 Steel" "Ti 6Al-4V"  "CFRP" ];

prop_choice1=prop_choice(1);
prop_choice2=prop_choice(2);

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

baseFileName = sprintf('Output_%s_%s_Material_%d_%s_Opitimization_%d.txt',prop_option1,prop_option2,material_choice,orbit,opti_algo);
fid_op=fopen(baseFileName,"wt");
fprintf(fid_op,"USER INPUT \n");
fprintf(fid_op,"***********\n");
fprintf(fid_op,"Payload Mass (kg): %.2f\n",M_pay);
fprintf(fid_op,"Perigee Altitude (km): %.2f\n",h_p);
fprintf(fid_op,"Apogee Altitude (km): %.2f\n",h_a);
fprintf(fid_op,"Stage 1 Propellant: %s \n",prop_option1);
fprintf(fid_op,"Stage 2 Propellant: %s \n",prop_option2);
fprintf(fid_op,"material_choice: %s \n",material_str);
fprintf(fid_op,"Longitude: %.2f \n",longitude);
fprintf(fid_op,"Latitude: %.2f \n",latitude);

fprintf(fid_op,"\n");
fprintf(fid_op,"\n");
fprintf(fid_op,"OPTIMUM DESIGN VARIABLES \n");
fprintf(fid_op,"**************************\n");
fprintf(fid_op,"Stage 1 Chamber Pressure (bar) : %.2f \n",x(1));
fprintf(fid_op,"Stage 2 Chamber Pressure (bar) : %.2f \n",x(2));
fprintf(fid_op,"Stage 1 Mixture Ratio : %.2f \n",x(3));
fprintf(fid_op,"Stage 2 Mixture Ratio : %.2f \n",x(4));
fprintf(fid_op,"Burn Time - Stage 1 (s) : %.2f \n",x(5));
fprintf(fid_op,"Burn Time - Stage 2 (s) : %.2f \n",x(6));
fprintf(fid_op,"Exit Pressure - Stage 1 (bar) : %.2f \n",x(7));
fprintf(fid_op,"Exit Pressure - Stage 2 (bar) : %.2f \n",x(8));
fprintf(fid_op,"Stage 1 Engine Exit Diameter (m) : %.2f \n",x(9));
fprintf(fid_op,"Stage 2 Engine Exit Diameter (m) : %.2f \n",x(10));
fprintf(fid_op,"Stage 1 Diameter (m) : %.2f \n",x(11));
fprintf(fid_op,"Stage 2 Diameter (m) : %.2f \n",x(12));
fprintf(fid_op,"Number of Engines Stage 1 : %d \n",floor(x(13)));
fprintf(fid_op,"Number of Engines Stage 2 : %d \n",floor(x(14)));
fprintf(fid_op,"\n");
fprintf(fid_op,"\n");
fprintf(fid_op,"PROPULSION CHARACTERISTICS \n");
fprintf(fid_op,"****************************\n");
fprintf(fid_op,"PARAMETER                              STAGE 1       STAGE 2    \n");
fprintf(fid_op,"\n");
fprintf(fid_op,"Vacuum Specific Impulse (s):           %.2f       %.2f \n", propulsion_parameter.Overview.Specific_Impulse1, propulsion_parameter.Overview.Specific_Impulse2);
fprintf(fid_op,"Vacuum Thrust (kN):                    %.2f       %.2f \n", propulsion_parameter.Overview.Total_Thrust1/1000, propulsion_parameter.Overview.Total_Thrust2/1000);
fprintf(fid_op,"Delta V (m/s):                         %.2f       %.2f \n",trajectory_parameter.del_V.del_V1,trajectory_parameter.del_V.del_V2);
fprintf(fid_op,"\n");
fprintf(fid_op,"\n");
fprintf(fid_op,"GEOMETRY CHARACTERISTICS \n");
fprintf(fid_op,"****************************\n");
fprintf(fid_op,"Expansion Ratio:                       %.2f       %.2f \n",propulsion_parameter.IRT.epsilon1,propulsion_parameter.IRT.epsilon2);
fprintf(fid_op,"Engine Length (m):                     %.2f         %.2f \n", geometry_parameter.Engine.L_eng1, geometry_parameter.Engine.L_eng2);
fprintf(fid_op,"Tank Length (m):                       %.2f       %.2f \n",geometry_parameter.Stage.L_tank1,geometry_parameter.Stage.L_tank2);
fprintf(fid_op,"Interstage Length (m):                 %.2f         %.2f \n",geometry_parameter.Stage.L_IS1,geometry_parameter.Stage.L_IS2);
fprintf(fid_op,"Fairing Length (m):                     -           %.2f \n",  geometry_parameter.Fairing.L_fairing);
fprintf(fid_op,"\n");
fprintf(fid_op,"\n");
fprintf(fid_op,"MASS CHARACTERISTICS \n");
fprintf(fid_op,"****************************\n");
fprintf(fid_op,"Propellant Mass (kg):                  %.2f     %.2f \n",propulsion_parameter.Overview.Propellant_Mass1,propulsion_parameter.Overview.Propellant_Mass2);
fprintf(fid_op,"Engine Mass (kg):                      %.2f      %.2f \n",mass_parameter.Engine.M_eng1_tot,mass_parameter.Engine.M_eng2_tot);
fprintf(fid_op,"Tank Mass (kg):                        %.2f      %.2f \n",mass_parameter.Tank.M_tank1,mass_parameter.Tank.M_tank2);
fprintf(fid_op,"Interstage Mass (kg):                  %.2f       %.2f \n",mass_parameter.Stage.M_IS1,mass_parameter.Stage.M_IS2);
fprintf(fid_op,"Stage Dry Mass (kg):                   %.2f       %.2f \n",mass_parameter.Stage.M_struct1,mass_parameter.Stage.M_struct2);
fprintf(fid_op,"Avionics Mass (kg):                    %.2f           %.2f \n",mass_parameter.Stage.M_avionics1,mass_parameter.Stage.M_avionics2);
fprintf(fid_op,"EPS Mass (kg):                         %.2f         %.2f \n",mass_parameter.Stage.M_EPS1,mass_parameter.Stage.M_EPS2);
fprintf(fid_op,"Payload Adapter Mass (kg):              -           %.2f \n",mass_parameter.Stage.M_PLA);
fprintf(fid_op,"Payload Fairing Mass (kg):              -           %.2f \n",mass_parameter.Stage.M_fairing);
fprintf(fid_op,"Launch Pad Interface Mass (kg):        %.2f        -  \n",mass_parameter.Stage.M_pad);
fprintf(fid_op,"\n");
fprintf(fid_op,"\n");
fprintf(fid_op," VEHICLE OVERVIEW\n");
fprintf(fid_op,"****************************\n");
fprintf(fid_op,"Gross Lift-off Weight (kg):%.2f \n",mass_parameter.GLOM);
fprintf(fid_op,"Total Propellant Mass (kg):%.2f \n",propulsion_parameter.Overview.Propellant_Mass1+propulsion_parameter.Overview.Propellant_Mass2);
fprintf(fid_op,"Total Dry Mass (kg):%.2f \n", mass_parameter.Stage.M_struct1+ mass_parameter.Stage.M_struct2);
fprintf(fid_op,"Launch Vehicle Length (m):%.2f \n",geometry_parameter.Stage.L_Stage1+geometry_parameter.Stage.L_Stage2+geometry_parameter.Fairing.L_fairing);
%fprintf(fid_op,"Structural Ratio:%.2f \n",(M_eng1+M_eng2+M_tank1+M_tank2+M_IS1+M_IS2+M_avionics+M_EPS+M_PLA+M_pad+M_fairing)/GLOM);

fclose(fid_op);