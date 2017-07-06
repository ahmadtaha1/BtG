function Problem_3_gonly(N,Nb,Ng,Nc,b_s,g_s,base,z,count_tg,count_tb,xb0,xg0,opt_ub,opt_usp)
% Author: Ankur Pipri
% Date: 19th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

% Discretization of Grid & Building Dynamics using Gear's k step method.
% This function generates the Matrices to solve the optimisation problem 
% using Quadprog

global sys_g sys_b sys_dg sys_db cost_n limit_n P3;

%% Big Matrix BEQ formation

Beq=cell(g_s,1);
Beq{1,1}=xg0;
for i=2:1:g_s
    Beq{i,1}=(sys_dg.B_wg*sys_g.w_g(:,(count_tg-1+i))) + sys_dg.B_gub*(-1/(10^6*base))*opt_ub + sys_dg.B_ug*opt_usp;
end
P3.Beq=sparse(cell2mat(Beq));

%% Varying temperature bounds for buildings
%[ub1,lb1]=building_limits(count_tb,Nb,b_s);

%% LB vector
lb3=repmat([limit_n.angles_low*ones(N,1);limit_n.freq_low*ones(N,1)],g_s,1); % Lower Bounds on Grid States
lb4=limit_n.ug_vars_low;        % Lower Bounds on delta mechanical powers
lb4=repmat(lb4,g_s,1);
P3.lb=[lb3;lb4];

%% UB vector
ub3=repmat([limit_n.angles_high*ones(N,1);limit_n.freq_high*ones(N,1)],g_s,1);   % Upper Bounds on Grid States
ub4=limit_n.ug_vars_high;         % Upper Bounds on delta mechanical powers
ub4=repmat(ub4,g_s,1);
P3.ub=[ub3;ub4];

end