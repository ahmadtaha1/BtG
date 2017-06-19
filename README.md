# Codes Introduction

The codes contain three folders that are described as follows. This page also contains the main mauscript titled Buidlings-To-Grid Integration Framework. 

# BtG-Codes

This repository contains the required MATLAB codes for the research paper titled Buildings-to-Grid Integration Framework.

The codes in this folder requires MATPOWER data and functions to be executed. The user is requested to add MATPOWER folder into the MATLAB's current path.

The simulations for the proposed Buildings to Grid Integration is performed to compare the results with the decoupled grid Model Predictive Control (MPC) results where two different types of building HVAC control inputs are fed to the grid MPC. For more details please refer to the research paper mentioned above.

## For Execuing Scenario I:

Step 1- Open the file 'main_code_gonly.m', select the IEEE case file to be simulated given in line 13-17.

Step 2- Uncomment lines 85-87 and comment lines 90-92.

Step 3- Uncomment line 182 and comment lines 183-184.

Step 4- Open the function 'start.m', comment line 8 and uncomment lines 26-55.

Step 5- After line 112, select the correct set of values according to the simulation case file chosen in step 1.

Step 6- Open 'new_plot_two_fig.m' select the title of the plot in lines 36-38 and 76-78 to be Scenario-I.

Step 7- Execute 'main_code_gonly.m' to simulate Scenario I of the test case selected.

## For Executing Scenario II:

Step 1- Open file 'main_code_bonly.m', select the same case file which is used for Scenario 1.

Step 2- Open the function 'start.m', uncomment line 8 and comment lines 26-55. This will load the same building input parameters as used for Scenario I.

Step 3- After line 112, make sure that the correct set of values are included according to the simulation case file chosen in step 1.

Step 4- Execute 'main_code_bonly.m' to simulate the decoupled building only MPC code on the selected set of buildings.

Step 5- Open the file 'main_code_gonly.m', select the same case file which is used for 'main_code_bonly.m'.

Step 6- Comment lines 85-87 and uncomment lines 90-92.

Step 7- Comment line 182 and uncomment lines 183-184.

Step 8- Open 'new_plot_two_fig.m' select the title of the plot in lines 36-38 and 76-78 to be Scenario-II.

Step 9- Execute 'main_code_gonly.m' to simulate Scenario II of the test case selected.

## For Execuing Scenario III:

Step 1- Open the file 'main_code.m', select the IEEE case file to be simulated given in line 13-17. Step 2- Open 'new_plot_two_fig.m' select the title of the plot in lines 36-38 and 76-78 to be BtG-GMPC. Step 3- Execute 'main_code.m' to simulate Scenario III of the test case selected.

# MAT Files

This repository includes all the .mat files for the solution of the optimization problems for all scenarios for all casefiles. 

# MAT Files

This repository includes all the MATLAB .fig files for the plots of the solutions for all scenarios for all casefiles. 

