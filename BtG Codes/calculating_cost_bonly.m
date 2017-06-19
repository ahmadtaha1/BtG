% Author: Ankur Pipri
% Date: 19th April 2017
function [obj_bldg] = calculating_cost_bonly(N,Ng,Nb,hg,hb)
% This function calculates the objective functions separately for building
% part after solving the mpc for the whole simulation

global cost_n Result
for i=1:1:(size(Result.B_HVAC,2))-1
    c4(1,i)=(Result.B_HVAC(:,i))' * cost_n.lincost_ub(i,1)*ones(Nb,1);
end
obj_bldg=sum(c4);

end