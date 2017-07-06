clc;
clear all;
close all;
disp('Hello');
disp('Press 1 for case 9');
disp('Press 2 for case 14');
disp('Press 3 for case 30');
disp('Press 4 for case 57');
control_case=input('Please enter the case file to be Simulated  ');
if(control_case~=1 && control_case~=2 && control_case~=3 && control_case~=4)
    return;
end
disp('                            ');
disp('Press 1 for Scenario 1');
disp('Press 2 for Scenario 2');
disp('Press 3 for Scenario 3');
control_scenario=input('Please enter the Scenario which is to be Simulated  ');

if(control_scenario==1)
    run main_code_gonly_scenario_1
elseif(control_scenario==2)
    run main_code_gonly_scenario_2
elseif(control_scenario==3)
    run main_code
else
    return;
end
