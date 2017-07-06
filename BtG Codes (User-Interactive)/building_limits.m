function [ u,l ] = building_limits( count_tb,Nb,b_s )
% Author: Ankur Pipri
% Date: 25th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

% This function helps in declaring the time varying zone temperature
% various cost & limits to the MPC Problem
global limit_n;
%% Limits
if (count_tb>=85 && count_tb<=90)   
    l=cell(b_s,1);
    u=cell(b_s,1);
    l{1,1}=repmat(limit_n.bs_low,Nb,1);
    u{1,1}=repmat(limit_n.bs_high,Nb,1);
    for i=2:b_s
        l{i,1}=l{i-1,1}-repmat([0;0.35],Nb,1);
        u{i,1}=u{i-1,1}-repmat([0;0.35],Nb,1);
    end
    limit_n.bs_low=l{2,1};
    limit_n.bs_low=limit_n.bs_low(1:2,1);
    limit_n.bs_high=u{2,1};
    limit_n.bs_high=limit_n.bs_high(1:2,1);
    l=cell2mat(l);
    u=cell2mat(u);
elseif (count_tb==240)
    limit_n.bs_high=[100;25];
    limit_n.bs_low=[0;22];
    l=repmat(limit_n.bs_low,(Nb*b_s),1);
    u=repmat(limit_n.bs_high,(Nb*b_s),1);
else
    l=repmat(limit_n.bs_low,(Nb*b_s),1);
    u=repmat(limit_n.bs_high,(Nb*b_s),1);
end
    

end

