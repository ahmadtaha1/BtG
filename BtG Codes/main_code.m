% Author: Ankur Pipri
% Date: 19th April 2017

% This is the main code that simulates the proposed BtG MPC Framework
clear;
close all;
clc;
tic;                  % to check the code execution time for the simulation
clear global test sys_g sys_b sys_dg sys_db gear cost_n limit_n P1 P2...
    P3 Result objective;
global       test sys_g sys_b sys_dg sys_db gear cost_n limit_n P1 P2...
    P3 Result objective;

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
g_s=(T_p/hg)+1;   % No. of samples of grid dynamics in a prediction horizon 
grid_gear_matrices(hg,gk,N);
b_s=(T_p/hb)+1; %No. of samples of building dynamics in a prediction horizn
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
matrices_generator_new(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z);

%% Main Simulation Begins
xb0=sys_b.init;
xg0=zeros(2*N,1);

count_tg=((T_start-1)/hg)+1;   % Counter to track no. of Grid State changes
count_tb=((T_start-1)/hb)+1;   % Counter to track no. of Building State changes
count_tp=((T_start-1)/T_p)+1;  % Counter to track no. of Prediction Horizon changes

Result.B_States(:,1)=xb0;       % Declaring the initial condition in the final result
Result.G_States(:,1)=xg0;       % Declaring the initial condition in the final result
time_prep=toc;                  % Time Elapsed for the data preparation before the actual optimization

tic;
for t=T_start:hg:T_final 
    if (mod(t,T_p)==1)         % Check condition for start of the prediction horizon (of time_predict seconds)
        disp(t);                                % step 4 of Algorithm 1
        
        limit_n.ug_vars_high=0.5*limit_n.ug_sps_high;
        limit_n.ug_vars_low=-0.5*limit_n.ug_sps_high;
        
        Problem_1(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z,count_tg,count_tb,xb0,xg0);
        option=optimoptions('quadprog','Algorithm','interior-point-convex');
        [X,obj,exitflag] = cplexqp(P1.H,P1.f,P1.Aneq,P1.Bneq,P1.Aeq,...
            P1.Beq,P1.lb,P1.ub,[]);  % calling quadprog to solve Problem Type 1
                
        separator_1(X,N,Nb,Ng,g_s,b_s,count_tg,count_tb,count_tp);  % Function to segregate the optimisation variable into final result
        clear X;
        opt_ub=Result.B_HVAC(:,count_tb+1);                        % Optimal HVAC Power for Nb buildings to be used as a constant till the next building state change
        opt_usp=Result.G_usp(:,count_tp);    
        xg0=Result.G_States(:,count_tg+1);
        xb0=Result.B_States(:,count_tb+1);

%         limit_n.ug_vars_high=limit_n.ug_sps_high - opt_usp;
%         limit_n.ug_vars_low=limit_n.ug_sps_low - opt_usp;
         
        count_tg=count_tg+1;
        count_tb=count_tb+1;
        count_tp=count_tp+1;
        
    elseif (mod(t,hb)==1)         % Check condition for start of the building sampling period
        disp(t);                                % step 14 of Algorithm 1
        Problem_2(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z,count_tg,count_tb,xb0,xg0,opt_usp);
        option=optimoptions('quadprog','Algorithm','interior-point-convex');
        [X,obj,exitflag] = cplexqp(P2.H,P2.f,[],[],P2.Aeq,...
            P2.Beq,P2.lb,P2.ub,[]);  % calling quadprog to solve Problem Type 1
        separator_2(X,N,Nb,Ng,g_s,b_s,count_tg,count_tb);  % Function to segregate the optimisation variable into final result
        clear X;
        opt_ub=Result.B_HVAC(:,count_tb+1);                        % Optimal HVAC Power for Nb buildings to be used as a constant till the next building state change
        xg0=Result.G_States(:,count_tg+1);
        xb0=Result.B_States(:,count_tb+1);
        count_tg=count_tg+1;
        count_tb=count_tb+1;
        
    else
        disp(t);
        Problem_3(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z,count_tg,count_tb,xb0,xg0,opt_ub,opt_usp);
        option=optimoptions('quadprog','Algorithm','interior-point-convex');
        [X,obj,exitflag] = cplexqp(P3.H,P3.f,[],[],P3.Aeq,...
            P3.Beq,P3.lb,P3.ub,[]);  % calling quadprog to solve Problem Type 3
        separator_3(X,N,Nb,Ng,g_s,b_s,count_tg);  % Function to segregate the optimisation variable into final result
        clear X;
        xg0=Result.G_States(:,count_tg+1);
        count_tg=count_tg+1;
    end
end
time_simulate=toc;                 

%% Plotting the final set of Results
plot_final_result(T_final,N,Ng,Nb,hg,hb,T_p,z,g_s,b_s,test.baseMVA);  
new_plot_two_fig(N,test.baseMVA,T_final,T_p,hg,Result.G_States,Result.G_ump,Result.G_usp,Result.B_HVAC,Result.B_Ztemp);

%% Cost calculation
[objective.freq,objective.ugvar,objective.ugsp,objective.grid,objective.bldg,objective.joint] = calculating_cost_wow(N,Ng,Nb,hg,hb);

% %% Saving Important results
% save('BTG Results','N','Nb','Ng','Nc','T_final','T_p','time_simulate','Result','limit_n','cost_n','test','sys_g','objective');

