% Author: Ankur Pipri
% Date: 17th April 2017
function building_gear_matrices( hb,gk,Nb,cop )
%Description: This function creates matrices to represent the discretised 
%system of Building Dynamics via Gear's method 
global sys_b sys_db gear;
sys_db.A_hat=sparse((eye(2*Nb)-(hb*gear.beta0*sys_b.Ab))\eye(2*Nb)); 
sys_db.Ab=zeros(2*Nb,2*Nb,gk);
for i=1:gk
    sys_db.Ab(:,:,i)=gear.alphai(i,1)*sys_db.A_hat;
end
sys_db.Bub=hb*gear.beta0*sys_db.A_hat*sys_b.Bub;
sys_db.Bwb=hb*gear.beta0*sys_db.A_hat*sys_b.Bwb;

end

