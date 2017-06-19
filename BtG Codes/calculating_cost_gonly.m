% Author: Ankur Pipri
% Date: 17th April 2017
function [frq_cost,delta_ug_cost,ug_sp_cost,obj_grid,obj_bldg,obj_joint]...
    = calculating_cost_gonly(N,Ng,Nb,hg,hb)
% This function calculates the objective functions separately for grid part
% after the whole mpc 

global cost_n Result
for i=1:1:(size(Result.G_frequencies,2))-1
    c1(1,i)=(Result.G_frequencies(:,i))' * diag(cost_n.sqcost_freq) *...
        Result.G_frequencies(:,i);
    c2(1,i)=(Result.G_ump(:,i)' * diag(cost_n.sqcost_udelta) *...
        Result.G_ump(:,i)) + (Result.G_ump(:,i)' * cost_n.lincost_udelta)...
        + (cost_n.const_udelta'*ones(Ng,1));
end

for i=1:1:(size(Result.G_usp,2))
    c3(1,i)=((Result.G_usp(:,i))' * diag(cost_n.sqcost_usp) *...
        Result.G_usp(:,i)) + ((Result.G_usp(:,i))' * cost_n.lincost_usp)...
        + (cost_n.const_usp'*ones(Ng,1));
end

obj_grid=sum(c1)+sum(c2)+sum(c3);
frq_cost=sum(c1);
delta_ug_cost=sum(c2);
ug_sp_cost=sum(c3);

for i=1:1:(size(Result.B_HVAC,2))-1
    c4(1,i)=(Result.B_HVAC(:,i))' * cost_n.lincost_ub(i,1)*ones(Nb,1);
end
obj_bldg=sum(c4);
obj_joint=obj_grid+obj_bldg;

end