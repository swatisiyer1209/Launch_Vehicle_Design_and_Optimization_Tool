# Launch_Vehicle_Design_and_Optimization_Tool

The Launch Vehicle Design and Optimization Tool was built as part of my Master Thesis titled - Methalox Propellants for Future Launchers. The tool was designed with the intention of using the tool for medium to heavy lift launchers. Therefore, the design variables for launcher geometry are much suited for such launchers. To analyse small launch vehicles, it is advised to simply vary the design variable bounds as per requirement. The design simulation process takes somewhere between 10 to 15 minutes.

To use the tool the following inputs are required:
1.	Payload mass (in kg)
2.	Apogee altitude (in km)
3.	Perigee altitude (in km)
4.	Longitude (in degrees)
5.	Latitude (in degrees)
6.	Propellant choice for both stages (entered as an array corresponding to propellant choice):
    a.	1: LOX/LH2 (Hydrolox)
    b.	2: LOX/RP1 (Kerolox)
    c.	3: LOX/CH4 (Methalox)
    Example : [2 1]: represents Kerolox-powered stage 1 and Hydrolox-powered stage 2
7.	Material choice (entered as a number corresponding to material type)
    a.	1: Al 7075-T6
    b.	2: Al-Li 2195
    c.	3: Al 2014-T6
    d.	4: 4340 Steel
    e.	5: Ti 6Al-4V
    f.	6: CFRP
8.	Optimization Objective (entered as a number corresponding to material type)
    a.	1: Minimize GLOM
    b.	2: Minimize Dry Mass

To perform the design and optimization, run the LV_Design code by running the following command:

_**LV_Design (M_pay, h_a, h_p, longitude, latitude, prop_choice, material_choice, opti_objective)**_

Results Output from Code
1.	Genetic Algorithm plot
2.	LV_Results_initial.mat  GA optimization results in Matlab file
3.	LV_Results_initial.dat  GA optimization results in .Dat file
4.	Optimization Function Plot  SQP plot
5.	LV_Tuned_Results.mat  GA+SQP optimization results 
6.	LV_Tuned_Results.dat  GA+SQP optimization results.dat file 
7.	Empty Mass Distribution  Pie chart showing the breakdown of empty mass
8.	Total Mass Distribution  Pie chart showing mass fractions

Reminder
•	Change the path of where the results are saved according to your folder location. 

Limitations:
•	The tool considers an estimate of gravitational and aerodynamic loss identified from the literature.

Interested in the project ? You can read the report here: https://repository.tudelft.nl/islandora/object/uuid:ba92d788-a566-43f5-82f8-959d3b7e38b5
