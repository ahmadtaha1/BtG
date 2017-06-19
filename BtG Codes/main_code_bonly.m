% Author: Ankur Pipri
% Date: 19th April
% This code simulates the decoupled building only MPC problem
clear;
close all;
clc;
tic;                  % to check the code execution time for the simulation
clear global test sys_g sys_b sys_dg sys_db gear cost_n limit_n P1 P2 P3 Result objective;
global       test sys_g sys_b sys_dg sys_db gear cost_n limit_n P1 P2 P3 Result objective;

% Selecting the test case to be simulated
test=case9(2.1);      % input the desired case, max load can be 2.4 times 
% test=case30(1.37);    % input the desired case, max load can be 1.3 times
% test=case57(1);
% test=case14(2.8);    % input the desired case, max load can be 2.9 times
% test=case118(1);    

% Important Initializations
sys_b.peak=400;       % Building HVAC peak load value (in KW)
sys_b.cop=3;          % Coefficient of Performance for HVAC System
gk=1;                 % Order for Gear's discretization
hg=10;                % Grid Sampling Time (in seconds)
hb=300;               % Building Sampling Time (in seconds)
z=hb/hg;              % where z is a positive integer
hopf=15*60;           % OPF problem solving frequency (in seconds)
T_p=15*60;            % Prediction Horizon (in seconds)
days=1;
T_start=(0*3600)+1;           % Simulation Start Time 
T_final=((24*days)-0.25)*3600; % Simulation End Time

%% Adding the required folders to the current Matlab path
currentdirectory=pwd;
try
cd('matpower6.0b1/'); 
matpower_directory=pwd;
cd(currentdirectory); 
addpath(matpower_directory); 
disp('MATPOWER was sucessfully added to the path'); 
catch 
disp('ERROR: unable to find MATPOWER')
end
try
cd('Building Codes/'); 
buildingcodes_directory=pwd;
cd(currentdirectory); 
addpath(buildingcodes_directory); 
disp('Building Codes Folder was sucessfully added to the path'); 
catch 
disp('ERROR: unable to find Building Codes Folder')
end

%% Getting the State Space Matrices for both the systems
[N,Ng,Nb,Nc,buildings,bt]=start();

%% Gear's Discretization Parameters
gear_param(gk);

g_s=(T_p/hg)+1;        % No. of samples of grid dynamics in a prediction horizon = Prediction horizon/sampling time
grid_gear_matrices(hg,gk,N);

b_s=(T_p/hb)+1;        % No. of samples of building dynamics in a prediction horizon = Prediction horizon/sampling time
building_gear_matrices(hb,gk,Nb);

%% Base Load & Building Miscellaneous Loads 
[sys_g.bl,sys_g.umisc]=demand_curve(Nb,test.baseMVA,hg,T_final,days);
sys_g.w_g=[sys_g.bl;sys_g.umisc];

%% Costs and Limits Declaration
for i=1:1:Nc
    if(test.branch(i,6)==0)
        limit_n.lf(i,1)=Inf;
    else
        limit_n.lf(i,1)=(1/test.baseMVA)*abs(test.branch(i,6));
    end
end
limit_n.ug_sps_high=(1/test.baseMVA)*test.gen(:,9);
limit_n.ug_sps_low=(1/test.baseMVA)*test.gen(:,10);
costs_and_limits(test,hg,hb,T_p);

%% Generation of Quadprog matrices 
matrices_generator_bonly(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z);

%% Main Simulation Begins
xb0=sys_b.init;
count_tb=((T_start-1)/hb)+1;    % Counter to keep track of no. of Building State changes

Result.B_States(:,1)=xb0;       % Declaring the initial condition in the final result
time_prep=toc;                  % Time Elapsed for the data preparation before the actual optimization

tic;
for t=T_start:hb:T_final 
        disp(t);                                % step 14 of Algorithm 1
        Problem_2_bonly(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z,count_tb,xb0);
        option=optimoptions('quadprog','Algorithm','interior-point-convex');
        [X,obj,exitflag] = cplexqp(P2.H,P2.f,[],[],P2.Aeq,...
            P2.Beq,P2.lb,P2.ub,[]);  % calling quadprog to solve Problem Type 1
        separator_2_bonly(X,N,Nb,Ng,g_s,b_s,count_tb);  % Function to segregate the optimisation variable into final result
        clear X;
        opt_ub=Result.B_HVAC(:,count_tb+1);                        % Optimal HVAC Power for Nb buildings to be used as a constant till the next building state change
        xb0=Result.B_States(:,count_tb+1);
        count_tb=count_tb+1;
end
time_simulate=toc;                 

%% Plotting the final set of Results
plot_final_result_bonly(T_final,N,Ng,Nb,hg,hb,T_p,z,g_s,b_s,test.baseMVA);  

%% Cost calculation
[objective.bldg] = calculating_cost_bonly(N,Ng,Nb,hg,hb);

% %% Saving Important results
% save('BTG Results','N','Nb','Ng','Nc','T_final','T_p','time_simulate','Result','limit_n','cost_n','test','sys_g','objective');

