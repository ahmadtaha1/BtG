function Problem_2(N,Nb,Ng,Nc,b_s,g_s,base,z,count_tg,count_tb,xb0,xg0,opt_usp)
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

global sys_g sys_b sys_dg sys_db cost_n limit_n P2;

%% Big Matrix BEQ formation

Beq=cell(2,1);

b1=cell(b_s,1);
b1{1,1}=xb0;
for i=2:1:b_s
    b1{i,1}=sys_db.Bwb*sys_b.wb(:,(count_tb-1+i));
end
b1=cell2mat(b1);
Beq{1,1}=b1;

b2=cell(g_s,1);
b2{1,1}=xg0;
for i=2:1:g_s
    b2{i,1}=(sys_dg.B_wg*sys_g.w_g(:,(count_tg-1+i))) + (sys_dg.B_ug*opt_usp);
end
b2=cell2mat(b2);
Beq{2,1}=b2;
P2.Beq=sparse(cell2mat(Beq));

%% Big Matrix F formation
f1=cost_n.lincost_ub(count_tb,1)*ones(Nb*b_s,1) * (2-1);
f2=repmat(cost_n.lincost_udelta,g_s,1) * 1;
P2.f=sparse([zeros((2*Nb*b_s),1);f1;zeros((2*N*g_s),1);f2]);

%% Varying temperature bounds for buildings
[ub1,lb1]=building_limits(count_tb,Nb,b_s);

%% LB vector
% lb1=repmat(limit_n.bs_low,(Nb*b_s),1);
lb2=limit_n.hvac_low*ones(Nb*b_s,1);  % Lower Bounds on HVAC Powers
lb3=repmat([limit_n.angles_low*ones(N,1);limit_n.freq_low*ones(N,1)],g_s,1); % Lower Bounds on Grid States
lb4=limit_n.ug_vars_low;        % Lower Bounds on delta mechanical powers
lb4=repmat(lb4,g_s,1);
P2.lb=[lb1;lb2;lb3;lb4];

%% UB vector
% ub1=repmat(limit_n.bs_high,(Nb*b_s),1);
ub2=limit_n.hvac_high*ones(Nb*b_s,1);  % Upper Bounds on HVAC Powers
ub3=repmat([limit_n.angles_high*ones(N,1);limit_n.freq_high*ones(N,1)],g_s,1);   % Upper Bounds on Grid States
ub4=limit_n.ug_vars_high;         % Upper Bounds on delta mechanical powers
ub4=repmat(ub4,g_s,1);
P2.ub=[ub1;ub2;ub3;ub4];

end