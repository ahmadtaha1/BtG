function grid_gear_matrices( hg,gk,N )
%This function creates matrices to represent the discretised system of...
%Grid Dynamics via Gear's method 
global sys_g sys_dg gear;

sys_dg.A_hat=sparse((sys_g.E_g-(hg*gear.beta0*sys_g.A_g))\eye(2*N)); 
sys_dg.A_g=zeros(2*N,2*N,gk);
for i=1:gk
    sys_dg.A_g(:,:,i)=gear.alphai(i,1)*sys_dg.A_hat*sys_g.E_g;
end
sys_dg.B_gub=hg*gear.beta0*sys_dg.A_hat*sys_g.B_gub;
sys_dg.B_ug=hg*gear.beta0*sys_dg.A_hat*sys_g.B_ug;
sys_dg.B_wg=hg*gear.beta0*sys_dg.A_hat*sys_g.B_wg;

end