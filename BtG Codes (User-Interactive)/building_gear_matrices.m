function building_gear_matrices( hb,gk,Nb,cop )
% Author: Ankur Pipri
% Date: 17th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

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

