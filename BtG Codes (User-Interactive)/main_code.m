% This is the main code that simulates the proposed BtG MPC Framework

% Author: Ankur Pipri
% Date: 19th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

%clear;
%close all;
clc;
tic;                  % to check the code execution time for the simulation
clear global test sys_g sys_b sys_dg sys_db gear cost_n limit_n P1 P2...
    P3 Result objective;
global       test sys_g sys_b sys_dg sys_db gear cost_n limit_n P1 P2...
    P3 Result objective;
% Description of global variables:
% test : Structure representing grid network parameters from the MATPOWER case file,
%     test.version: version of matpower, default 2 for structure output
%     test.baseMVA: Base MVA of the system
%     test.bus:     Bus (Nodes) details
%     test.gen:     Generator details
%     test.branch:  Branch (Edges) details
%     test.gencost: Generator cost coefficients
%     test.ref_bus: Reference Bus
% sys_g : Structure representing grid related information,
%     sys_g.bldg_max_load: maximum load drawn by buildings
%     sys_g.base_max_load: maximum load on the grid apart from buildings
%     sys_g.Gamma: Generator to Node incidence matrix (N x Ng)
%     sys_g.Pi: Building to Node incidence matrix (N x Nb)
%     sys_g.PTDF: Power Transfer Distribution Matrix (Nl(or Nc) x N)
%     sys_g.PF: Power flow matrix (Nl(or Nc) x N)
%     sys_g.E_g: Continuous time matrix E_g in equation 7 (2N x 2N)
%     sys_g.A_g: Continuous time matrix A_g in equation 7 (2N x 2N)
%     sys_g.B_ug: Continuous time matrix B_ug in equation 7 (2N x Ng)
%     sys_g.B_gub: Continuous time matrix A_ub in equation 7 (2N x Nb)
%     sys_g.B_wg: Continuous time matrix B_wg in equation 7 (2N x (N+Nb))
%     sys_g.bl: Grid base load (known disturbance of the system) (N x total no. of grid samples in the simulation)
%     sys_g.umisc: Buildings miscellaneous load other than HVAC (known disturbance of the system) 
%                  (N x total no. of grid samples in the simulation)
%     sys_g.w_g: [sys_g.bl;sys_g.umisc], total known disturbance in the system
% sys_dg : Structure that contains state space matrices for the discretised grid system using Gear's method
%     sys_dg.A_hat: matrix A_g^{hat} as defined in equation 9
%     sys_dg.A_g: discretised form of matrix sys_g.A_g
%     sys_dg.B_gub: discretised form of matrix sys_g.B_gub
%     sys_dg.B_ug: discretised form of matrix sys_g.B_ug
%     sys_dg.B_wg: discretised form of matrix sys_g.B_wg
% sys_b : Structure representing Building related information,
%     sys_b.peak: Building's HVAC peak load (in KW)
%     sys_b.cop: Coefficient of Performance for HVAC System, \mu_HVAC
%     sys_b.Ab: Continuous time ss matrix A_b given in equation 2 (2Nb x 2Nb)
%     sys_b.Bub: Continuous time ss matrix B_ub given in equation 2 (2Nb x Nb)
%     sys_b.Bwb: Continuous time ss matrix B_wb given in equation 2 (2Nb x 3Nb)
%     sys_b.wb: Building disturbances (weather data etc.) (3Nb x total no. building samples in the simulation)
%     sys_b.ub: HVAC control inputs as a result of Bang bang control method (Nb x total no. building samples in the simulation)
%     sys_b.utb: Total building energy consumption during bang bang control (Nb x total no. building samples in the simulation)
%     sys_b.umisc: miscellaneous loads other than HVAC loads in the buildings (Nb x total no. building samples in the simulation)
%     sys_b.g0: buildings initial condition (not used in this code)
%     sys_b.Tz: zone temperatures profile in case of bang bang control method
%     sys_b.init: Buildings true initial condition as in case of bang bang control
% sys_db : Structure that contains state space matrices for the discretised buildings system using Gear's method
%     sys_db.A_hat: matrix A_b^{hat} as defined in equation 10
%     sys_db.Ab: discretised form of matrix sys_b.Ab
%     sys_db.Bub: discretised form of matrix sys_b.Bub
%     sys_db.Bwb: discretised form of matrix sys_b.Bwb
% gear : gear's variables as defined in the paper in equations 9 & 10
%     gear.beta0: \beta_0 as defined in the paper (scalar)
%     gear.alphai: \alpha as defined in the paper (gk x 1) 
% cost_n : Structure containing the cost coefficients for all the parameters involved
%     cost_n.gw: weight on the grid cost (scalar)
%     cost_n.sqcost_udelta: squared term cost coefficient for mechanical power variations, \Delta u_g
%     cost_n.lincost_udelta: linear term cost coefficient for mechanical power variations, \Delta u_g
%     cost_n.const_udelta: constant term cost coefficient for mechanical power variations, \Delta u_g
%     cost_n.sqcost_usp: squared term cost coefficient for mechanical power setpoints, \bar u_g (J_ug)
%     cost_n.lincost_usp: linear term cost coefficient for mechanical power setpoints, \bar u_g (b_ug)
%     cost_n.const_usp: constant term cost coefficient for mechanical power setpoints, \bar u_g (c_ug)
%     cost_n.sqcost_freq: squared term cost coefficient for frequency deviation from 60 Hz
%     cost_n.ubreal: time varying linear term cost coefficient for HVAC Power Consumption (hourly)
%     cost_n.lincost_ub: linear term cost coefficient for HVAC Power Consumption (at building samples), (c_b)
% limit_n : Contains limits to various parameters of the problem
%     limit_n.lf: Line loading limits (Nl or Nc x 1)
%     limit_n.ug_sps_high: Upper bounds on mechanical power setpoints (Ng x 1)
%     limit_n.ug_sps_low: Lower bounds on mechanical power setpoints (Ng x 1) 
%     limit_n.bs_high: Upper bounds on building states [T_wall;T_zone] 
%     limit_n.hvac_high: Upper bounds on HVAC Power
%     limit_n.angles_high: Upper bounds on bus angles (N x 1)
%     limit_n.freq_high: Maximum deviation allowed in frequency
%     limit_n.bs_low: Lower bounds on building states [T_wall;T_zone] 
%     limit_n.hvac_low: Lower bounds on HVAC Power
%     limit_n.angles_low: Lower bounds on bus angles (N x 1)
%     limit_n.freq_low: Minimum deviation allowed in frequency
%     limit_n.ug_vars_high: Upper bounds on mechanical power variations (Ng x 1)
%     limit_n.ug_vars_low: Lower bounds on mechanical power vaiations (Ng x 1)
% P1, P2, P3 are the structure which contains the quadprog constant matrices like H, f, Aeg, Aneq, constant box constraints etc.
% for three different types of optimization problems as described later in this script
% Result : This contains the final set of optimal inputs and states
%     Result.B_States: Optimal building states (2Nb x no. of building states)
%     Result.G_States: Optimal grid states (2N x no. of grid states)
%     Result.B_HVAC: Optimal building control inputs, HVAC Power (Nb x no. of building states)
%     Result.G_ump: Optimal grid control inputs, mechanical power variations (Ng x no. of grid states)
%     Result.G_usp: Optimal grid control inputs, mechanical power setpoints (Ng x no. of grid states)
%     Result.G_gen: Total generation (\bar u_g + \Delta u_g) sampled at grid sampling frequency
%     Result.G_load: Total load (u_bl + u_b + u_misc)
%     Result.G_angles: Optimal Bus Angles taken from 'Result.G_States'
%     Result.G_frequencies: Optimal Bus Frequencies taken from 'Result.G_States'
%     Result.B_Wtemp: Optimal wall temperature of the buildings taken from 'Result.B_States'
%     Result.B_Ztemp: Optimal zone temperature of the buildings taken from 'Result.B_States'
% objective : Contains the value of objective function (the cost) under different parameters,
%     objective.freq: Cost due to variations in frequency
%     objective.ugvar: Cost of mechanical power variations 
%     objective.ugsp: Cost of mechanical power setpoints
%     objective.grid: Combined cost of grid (objective.freq + objective.ugvar + objective.ugsp)
%     objective.bldg: Cost of HVAC Power consumption in buildings
%     objective.joint: Total cost of BtG GMPC (objective.grid + objective.bldg)

% Selecting the test case to be simulated:
% This script uses the already present IEEE standard networks given in MATPOWER.
% It is to be noted that for these simulations the total load on these networks is 
% increased by a factor given in the parenthesis. This factor is selected as the 
% maximum safe value of total grid load which yields a feasible solution of the 
% power flow problem using MATPOWER's inbuilt function 'rundcopf'

if(control_case==1)
    test=case9(2.2);      % input the desired case, 
    load('case_9_cost');
    load('case_9_limit');
    load('case_9_sys_b');
    load('case_9_sys_g');
    pcnt_sp=0.3;
elseif(control_case==2)
    test=case14(2.8);    % input the desired case, 
    load('case_14_cost');
    load('case_14_limit');
    load('case_14_sys_b');
    load('case_14_sys_g');
    pcnt_sp=0.5;
elseif(control_case==3)
    test=case30(1.37);    % input the desired case, 
    load('case_30_cost');
    load('case_30_limit');
    load('case_30_sys_b');
    load('case_30_sys_g');
    pcnt_sp=0.5;
elseif(control_case==4)
    test=case57(1);
    load('case_57_cost');
    load('case_57_limit');
    load('case_57_sys_b');
    load('case_57_sys_g');
    pcnt_sp=0.5;
end

% Initializations
sys_b.peak=400;       % Building HVAC peak load value (in KW)
sys_b.cop=3;          % Coefficient of Performance for HVAC System, \mu_HVAC
gk=1;                 % Order for Gear's discretization (This code only works for gk=1)
hg=10;                % Grid Sampling Time (in seconds)
hb=300;               % Building Sampling Time (in seconds)
z=hb/hg;              % where z is a positive integer
T_p=15*60;            % Prediction Horizon (in seconds) (This code works only for hopf=T_p)
days=1;
T_start=(0*3600)+1;           % Simulation Start Time 
T_final=((24*days)-0.25)*3600; % Simulation End Time

%% Adding the required folders to the current Matlab path
% currentdirectory=pwd;
% try
% cd('matpower6.0b1/'); 
% matpower_directory=pwd;
% cd(currentdirectory); 
% addpath(matpower_directory); 
% disp('MATPOWER was sucessfully added to the path'); 
% catch 
% disp('ERROR: unable to find MATPOWER')
% end

%% Getting the State Space Matrices for both the systems:
%[N,Ng,Nb,Nc,buildings]=start();
% The output of this function is,
%     N: Number of buses in the electrical grid network (nodes)
%     Ng: Number of Generators
%     Nb: Total number of buildings
%     Nc: Number of branches in the network, (edges represented as Nl in the paper)
% In addition to these outputs, this function populates the continuous time
% state space matrices in structures sys_g (for grid) and sys_b (for
% buildings). For more details please look into the comments in function.

%% Loading the system parameters used for simulations in the paper

N=size(sys_g.Gamma,1);
Ng=size(sys_g.Gamma,2);
Nb=size(sys_g.Pi,2);
Nc=size(sys_g.PTDF,1);


%% Gear's Discretization Parameters:
gear_param(gk);
% Function 'gear_param(gk)' takes gear's step as input and returns values of gear's
% parameters beta_0 and alpha as defined in equation 9 & 10 in the paper
g_s=(T_p/hg)+1;   % No. of samples of grid dynamics in a prediction horizon (To be an integer)
grid_gear_matrices(hg,gk,N);
% Function 'grid_gear_matrices(hg,gk,N)' takes grid sampling time, gear's
% step size & number of buses as input and returns the discretized system
% state space matrices for the electrical grid dynamics in structure 'sys_dg'
b_s=(T_p/hb)+1; %No. of samples of building dynamics in a prediction horizn (To be an integer)
building_gear_matrices(hb,gk,Nb);
% Function 'building_gear_matrices(hb,gk,Nb)' takes buildings sampling time, gear's
% step size & number of buildings as input and returns the discretized system
% state space matrices for the building dynamics in structure 'sys_dg'

%% Base Load & Building Miscellaneous Loads:
% [sys_g.bl,sys_g.umisc]=demand_curve(Nb,test.baseMVA,hg,T_final,days);
% Function 'demand_curve(Nb,test.baseMVA,hg,T_final,days)' returns the grid
% base load and the buildings miscellaneous load each sampled at the grid
% sampling frequency. Recall that this is the known disturbance for the
% grid problem
% sys_g.w_g=[sys_g.bl;sys_g.umisc];

%% Costs and Limits Declaration:
% Sometimes the line loading limits in the matpower files is given as 0
% which indicates there is no limit for the power transfer. The for loop
% below takes care of any such condition.
% for i=1:1:Nc
%     if(test.branch(i,6)==0)
%         limit_n.lf(i,1)=Inf;
%     else
%         limit_n.lf(i,1)=(1/test.baseMVA)*abs(test.branch(i,6));
%     end
% end
% limit_n.ug_sps_high=(1/test.baseMVA)*test.gen(:,9);
% limit_n.ug_sps_low=(1/test.baseMVA)*test.gen(:,10);
% costs_and_limits(test,hg,hb,T_p);
% The function 'costs_and_limits(test,hg,hb,T_p)' populates the global
% structures cost_n and limit_n as described above

%% Generation of Quadprog matrices 
matrices_generator_new(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z);
% This function calculates the constant matrices of the standard form of 
% three different types of optimization problems as explained in the paper. 
% These matrices will then be fed as inputs to solvers like quadprog or cplex etc.

%% Main Simulation Begins
xb0=sys_b.init;   % Taking the same initial condition as it was for bang bang control method (scenario 1)
xg0=zeros(2*N,1); % Same initial condition for all the scenarios
% xg0=[1.69964703146663;0.612191083355224;-2.25161044603742;2.31771267219512;2.61364071778879;-2.43393282618287;1.72678879623061;1.14044690963687;2.64514135309221;2.80239890522892;3.01961567715650;0.647660988276538;-1.08959354509013;-0.0341008835194554;-0.855154859260110;2.66687691827548;2.11114203673581;-2.65908148871345];

count_tg=((T_start-1)/hg)+1;   % Counter to track number of Grid State changes
count_tb=((T_start-1)/hb)+1;   % Counter to track number of Building State changes
count_tp=((T_start-1)/T_p)+1;  % Counter to track number of Prediction Horizon changes

Result.B_States(:,1)=xb0;       % Declaring the initial condition in the final result
Result.G_States(:,1)=xg0;       % Declaring the initial condition in the final result
time_prep=toc;                  % Time Elapsed for the data preparation before the actual optimization

tic;                            % To check the total simulation time 
for t=T_start:hg:T_final 
    if (mod(t,T_p)==1)         % Check condition for start of the prediction horizon (of T_p seconds)
        disp(t);               
        
        limit_n.ug_vars_high=pcnt_sp*limit_n.ug_sps_high; % setting the \Delta ug limits to be
        limit_n.ug_vars_low=-pcnt_sp*limit_n.ug_sps_high; % ±50% of \bar u_gmax
        
        Problem_1(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z,count_tg,count_tb,xb0,xg0);
        % The function 'Problem_1()' returns the dynamic part of the quadprog inputs
        % to Problem type 1 where OPF, building inputs and grid inputs are optimized 
        % as explained in the paper.
        % Basically this is the RHS of the constraints (disturbances) which keeps on
        % changing as we move ahead in time.
        [X,obj,exitflag] = cplexqp(P1.H,P1.f,P1.Aneq,P1.Bneq,P1.Aeq,...
            P1.Beq,P1.lb,P1.ub,[]);  % calling cplex to solve Problem Type 1
        separator_1(X,N,Nb,Ng,g_s,b_s,count_tg,count_tb,count_tp);  
        % Function to segregate the optimisation variables into final result
        clear X;
        opt_ub=Result.B_HVAC(:,count_tb+1);          
        % Optimal HVAC Power for buildings to be used as a constant till
        % the next building state changes
        opt_usp=Result.G_usp(:,count_tp);    
        % Optimal mechanical power setpoints for generators which the solution 
        % of OPF problem. This vector remains a constant throughout the 
        % current prediction horizon.        
        xg0=Result.G_States(:,count_tg+1); % only the first set of optimal 
        xb0=Result.B_States(:,count_tb+1); % states is taken into the final result and discarding the rest.

        count_tg=count_tg+1; % grid state counter is increased by 1
        count_tb=count_tb+1; % building state counter is increased by 1
        count_tp=count_tp+1; % grid OPF problem solving counter is increased by 1
        
    elseif (mod(t,hb)==1)         % Check condition for start of the building sampling period
        disp(t);                  
        Problem_2(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z,count_tg,count_tb,xb0,xg0,opt_usp);
        % The function 'Problem_2()' returns the dynamic part of the quadprog inputs
        % to Problem type 2 where the building and grid controls are optimized as explained in the paper.
        % Basically this is the RHS of the constraints (disturbances) which keeps on
        % changing as we move ahead in time.
        [X,obj,exitflag] = cplexqp(P2.H,P2.f,[],[],P2.Aeq,...
            P2.Beq,P2.lb,P2.ub,[]);  % calling cplex to solve Problem Type 2
        separator_2(X,N,Nb,Ng,g_s,b_s,count_tg,count_tb);  
        % Function to segregate the optimisation variable into final result
        clear X;
        opt_ub=Result.B_HVAC(:,count_tb+1);                        
        % Optimal HVAC Power for Nb buildings to be used as a constant till 
        % the next building state change
        xg0=Result.G_States(:,count_tg+1); % only the first set of optimal
        xb0=Result.B_States(:,count_tb+1); % states is taken into the final result and discarding the rest.
        count_tg=count_tg+1; % grid state counter is increased by 1
        count_tb=count_tb+1; % building state counter is increased by 1
        
    else
        disp(t);
        Problem_3(N,Nb,Ng,Nc,b_s,g_s,test.baseMVA,z,count_tg,count_tb,xb0,xg0,opt_ub,opt_usp);
        % The function 'Problem_3()' returns the dynamic part of the quadprog inputs
        % to Problem type 2 where the only the grid controls are optimized as explained in the paper.
        % Basically this is the RHS of the constraints (disturbances) which keeps on
        % changing as we move ahead in time.
        [X,obj,exitflag] = cplexqp(P3.H,P3.f,[],[],P3.Aeq,...
            P3.Beq,P3.lb,P3.ub,[]);  % calling cplex to solve Problem Type 3
        separator_3(X,N,Nb,Ng,g_s,b_s,count_tg);  
        % Function to segregate the optimisation variable into final result
        clear X;
        xg0=Result.G_States(:,count_tg+1);
        count_tg=count_tg+1; % grid state counter is increased by 1
    end
end
time_simulate=toc;     % BtG GMPC Problem solving time (in seconds)            

%% Plotting the final set of Results
plot_final_result_BTG(T_final,N,Ng,Nb,hg,hb,T_p,z,g_s,b_s,test.baseMVA);  
% new_plot_two_fig(N,test.baseMVA,T_final,T_p,hg,Result.G_States,Result.G_ump,Result.G_usp,Result.B_HVAC,Result.B_Ztemp);
% This function plots the graphs as given in the paper

%% Cost calculation
[objective.freq,objective.ugvar,objective.ugsp,objective.grid,objective.bldg,objective.joint] = calculating_cost_wow(N,Ng,Nb,hg,hb);
% The function 'calculating_cost_wow' takes N,Ng,Nb,hg,hb, Result and
% cost_n to give the final cost (objective value) of the problem.

% %% Saving Important results
% save('BTG Results','N','Nb','Ng','Nc','T_final','T_p','time_simulate','Result','limit_n','cost_n','test','sys_g','objective');

