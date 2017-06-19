% Author: Ankur Pipri
% Date: 19th April 2017
function costs_and_limits(mpc,hg,hb,T_p)
% This function declares the cost and and bounds for various parameters
% used in the Big Problem (including buildings and grid)
global cost_n limit_n;
base=mpc.baseMVA;
high=1;        % cost of delta ug is higher than ug setpoint by this factor
%% Costs
cost_n.gw=0.9;  % weight for grid cost in the combined problem
cost_n.sqcost_udelta=(2*base^2)*(hg/3600)*high*mpc.gencost(:,5);
cost_n.lincost_udelta=0*base*(hg/3600)*high*mpc.gencost(:,6);
cost_n.const_udelta=0*(hg/3600)*high*mpc.gencost(:,7);
cost_n.sqcost_usp=(2*base^2)*(T_p/3600)*mpc.gencost(:,5);
cost_n.lincost_usp=base*(T_p/3600)*mpc.gencost(:,6);
cost_n.const_usp=(T_p/3600)*mpc.gencost(:,7);
cost_n.sqcost_freq=5000*10;
k=0;
cost_n.ubreal=-10*[0.055;0.05;0.0455;0.05;0.057;0.056;0.057;0.058;0.06;...
    0.062;0.065;0.065;0.068;0.069;0.071;0.075;0.08;0.09;0.085;0.075;...
    0.072;0.065;0.064;0.061];   %Original cost curve (taken -ve considering
                                %-ve sign of P_hvac after optimization
for i=1:1:24
    for j=1:1:(3600/hb)
        cost_n.lincost_ub(k+j,1)=cost_n.ubreal(i,1);
    end
    k=k+(3600/hb);
end
cost_n.lincost_ub=(hb/(3600*1000))*cost_n.lincost_ub;

%% Limits

limit_n.bs_high=[100;25];%23            % Higher Bounds on Building States
limit_n.hvac_high=0;%*0.01;
limit_n.angles_high=Inf;
limit_n.freq_high=2*pi*0.5;

limit_n.bs_low=[0;22];%20               % Lower Bounds on Building States
limit_n.hvac_low=-800*1000;             % HVAC peak (in Watts)
limit_n.angles_low=-Inf;
limit_n.freq_low=-2*pi*0.5;

end