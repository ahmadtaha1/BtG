#Final-BtG-Codes

This repository contains the required MATLAB codes for the following research papers:

1. A.F.Taha, N.Gatsis, B. Dong, A.Pipri, Z.Li, "Buildings-to-Grid Integration Framework" submitted to IEEE Trans. on Smart Grids, submitted March 2017.

2. Z.Li, A.Pipri, B.Dong, N.Gatsis, A.F.Taha, N.Yu, "Modelling, Simulation and Control of Smart and Connected Communities" submitted to International Building Performance Simulation Association , Building Simulation Conference 2017.

If you are using any part of this material in your research, please cite the above references.

The codes in this folder requires MATPOWER data and functions to be executed. The user is requested to add MATPOWER folder into the MATLAB's current path.
The simulations for the proposed Buildings to Grid Integration is performed to compare the results with the decoupled grid Model Predictive Control (MPC) results where two different types of building HVAC control inputs are fed to the grid MPC. For more details please refer to the research paper [1] mentioned above.


##For Execuing Scenario I:

Step 1- Open the file 'main_code_gonly.m', select the IEEE case file to be simulated given in line 123-126.

Step 2- Uncomment lines 211-213 and comment lines 216-218.

Step 3- Uncomment line 314 and comment lines 315-316.

Step 4- Open the function 'start.m', comment line 14 and uncomment lines 32-61.

Step 5- After line 118, select the correct set of values according to the simulation case file chosen in step 1.

Step 6- Open 'new_plot_two_fig.m' select the title of the plot in lines 42-44 and 82-84 to be Scenario-I.

Step 7- Execute 'main_code_gonly.m' to simulate Scenario I of the test case selected.


##For Executing Scenario II:

Step 1- Open file 'main_code_bonly.m', select the same case file which is used for Scenario 1.

Step 2- Open the function 'start.m', uncomment line 14 and comment lines 32-61. This will load the same building input parameters as used for Scenario I.

Step 3- After line 118, make sure that the correct set of values are included according to the simulation case file chosen in step 1.

Step 4- Execute 'main_code_bonly.m' to simulate the decoupled building only MPC code on the selected set of buildings.

Step 5- Open the file 'main_code_gonly.m', select the same case file which is used for 'main_code_bonly.m'.

Step 6- Comment lines 211-213 and uncomment lines 216-218.

Step 7- Comment line 314 and uncomment lines 315-316.

Step 8- Open 'new_plot_two_fig.m' select the title of the plot in lines 42-44 and 82-84 to be Scenario-II.

Step 9- Execute 'main_code_gonly.m' to simulate Scenario II of the test case selected.


##For Execuing Scenario III:

Step 1- Open the file 'main_code.m', select the IEEE case file to be simulated given in line 123-126.

Step 2- Open 'new_plot_two_fig.m' select the title of the plot in lines 42-44 and 82-84 to be BtG-GMPC.

Step 3- Execute 'main_code.m' to simulate Scenario III of the test case selected.

