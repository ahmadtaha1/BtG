% Author: Ankur Pipri
% Date: 19th April 2017
function Problem_2_bonly(N,Nb,Ng,Nc,b_s,g_s,base,z,count_tb,xb0)
% Discretization of Grid & Building Dynamics using Gear's k step method.
% This function generates the Matrices to solve the optimisation problem 
% using Quadprog

global sys_g sys_b sys_dg sys_db cost_n limit_n P2;

%% Big Matrix BEQ formation

Beq=cell(1,1);

b1=cell(b_s,1);
b1{1,1}=xb0;
for i=2:1:b_s
    b1{i,1}=sys_db.Bwb*sys_b.wb(:,(count_tb-1+i));
end
b1=cell2mat(b1);
Beq{1,1}=b1;

P2.Beq=sparse(cell2mat(Beq));

%% Big Matrix F formation
f1=cost_n.lincost_ub(count_tb,1)*ones(Nb*b_s,1);
P2.f=sparse([zeros((2*Nb*b_s),1);f1]);

%% Varying temperature bounds for buildings
[ub1,lb1]=building_limits(count_tb,Nb,b_s);

%% LB vector
% lb1=repmat(limit_n.bs_low,(Nb*b_s),1);
lb2=limit_n.hvac_low*ones(Nb*b_s,1);  % Lower Bounds on HVAC Powers
P2.lb=[lb1;lb2];

%% UB vector
% ub1=repmat(limit_n.bs_high,(Nb*b_s),1);
ub2=limit_n.hvac_high*ones(Nb*b_s,1);  % Upper Bounds on HVAC Powers
P2.ub=[ub1;ub2];

end