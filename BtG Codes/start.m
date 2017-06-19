% Author: Ankur Pipri
% Date: 19th April 2017
function [N,Ng,Nb,Nc,buildings,bt]=start()
%% This function generates the continuous time state space matrices for grid 
% & Building Dynamics along with some initializations
global test sys_b sys_g ;
% %% Loading the saved file for grid only case
% load('b_data');
%% Initialization
N=size(test.bus,1);      % No. of buses
Ng=size(test.gen,1);     % No. of generators
Nc=size(test.branch,1);  % No. of branches
load_demand=test.bus(:,3);           % Active load demand on buses (in MW)
sys_g.bldg_max_load=0.7*load_demand; % building HVAC load share out of total grid load
sys_g.base_max_load=0.3*load_demand; % rest of the grid load
for i=1:N
if (sys_g.bldg_max_load(i)<=0)
    buildings(i,1)=0;           % as some entries are negative in matpower
else
    buildings(i,1)=round((1000/(sys_b.peak*1.2))*sys_g.bldg_max_load(i));  % No. of buildings on buses
%     buildings(i,1)=round((1000/(sys_b.peak*1))*sys_g.bldg_max_load(i));  % No. of buildings on buses
end
end
Nb=sum(buildings);      % Total no. of buildings
%% Generation of augmented building parameters
sys_b.Ab=sparse([]);
sys_b.Bub=sparse([]);
sys_b.Bwb=sparse([]);
sys_b.wb=[];
sys_b.ub=[];
sys_b.utb=[];
sys_b.umisc=[];
sys_b.g0=[];
sys_b.Tz=[];
sys_b.init=[];
tic;
for i=1:N
    if buildings(i,1)>0
        disp(['Bus ',num2str(i),', Number of Buildings ',num2str(buildings(i,1))]);
        [Ab,Bub,Bwb,wb,ub,utb,umisc,g0,Tz,initial_b] = Bldg_Param(buildings(i,1),2*sys_b.peak);
        sys_b.Ab=blkdiag(sys_b.Ab,Ab);
        sys_b.Bub=blkdiag(sys_b.Bub,sys_b.cop*Bub);     % COP included here
        sys_b.Bwb=blkdiag(sys_b.Bwb,Bwb);
        sys_b.wb=[sys_b.wb;wb];
        sys_b.ub=[sys_b.ub;ub];
        sys_b.utb=[sys_b.utb;utb];
        sys_b.umisc=[sys_b.umisc;umisc];
        sys_b.g0=[sys_b.g0;g0];
        sys_b.Tz=[sys_b.Tz;Tz];
        sys_b.init=[sys_b.init;initial_b];
        clear Ab Bub Bwb wb ub utb umisc g0 Tz;
    end
end
bt=toc;
save('b_data','sys_b');

%% Pi and Gamma Matrices
sys_g.Gamma=sparse(N,Ng);      % Bus-Generator Incidence Matrix
for i=1:Ng
    k=test.gen(i,1);
    sys_g.Gamma(k,i)=1;
end

sys_g.Pi=sparse(N,Nb);         % Bus-Building Incidence Matrix
k=0;
for i=1:N
    if buildings(i,1)>0
        for j=1+k:buildings(i,1)+k
            sys_g.Pi(i,j)=1;
        end
        k=k+buildings(i,1);
    end
end

%% Bus Admittance Matrix
L=zeros(N,N);
for i=1:Nc
    L(test.branch(i,1),test.branch(i,2))=-1/test.branch(i,4);
    L(test.branch(i,2),test.branch(i,1))=-1/test.branch(i,4);
end
sum1=0;
for i=1:N
    for j=1:N
        if (j~=i)
            sum1=sum1+L(j,i);
        end
    end
    L(i,i)=-sum1;
    sum1=0;
end

%% PTDF Matrix
% finding the reference bus
for i=1:N
    if (test.bus(i,2)==3)
        test.ref_bus=i;
    end
end
sys_g.PTDF=makePTDF(test);

%% Power Flow Matrix
sys_g.PF=zeros(Nc,N);
for i=1:Nc
    sys_g.PF(i,test.branch(i,1))=1/test.branch(i,4);
    sys_g.PF(i,test.branch(i,2))=-1/test.branch(i,4);
end

%% E matrix
% m_vals=8+randn(Ng,1);           % Input the M values
% d_vals=3+randn(Ng,1);           % Input the D values

% % for case 9
% d_vals=[9.6;2.5;1];
% m_vals=[23.64;6.4;3.01]/(pi*60);

% % for case 14
% d_vals=[9.6;8;2.5;1.5;1];
% m_vals=[23.64;19.21;6.4;4.9;3.01]/(pi*60);

% for case 30
d_vals=[9.6;8;4.5;2.5;1.5;1];
m_vals=[23.64;19.21;11.60;6.4;4.9;3.01]/(pi*60);

% % for case 57
% d_vals=[9.6;8;4.5;3.9;2.5;1.5;1];
% m_vals=[23.64;19.21;11.60;10.5;6.4;4.9;3.01]/(pi*60);

m_vals=sys_g.Gamma*m_vals;    
d_vals=sys_g.Gamma*d_vals;
M=diag(m_vals);
D=diag(d_vals);

sys_g.E_g=sparse([eye(N) zeros(N)       
                 zeros(N) M]);

%% Other State Space Space Matrices
sys_g.A_g=sparse([zeros(N) eye(N)
                    -L       -D]);
 
sys_g.B_ug=sparse([zeros(N,Ng)
       sys_g.Gamma]);
   
sys_g.B_gub=sparse([zeros(N,Nb)
       -sys_g.Pi]);

B_bl=sparse([zeros(N,N)
       -eye(N)]);

B_misc=sparse([zeros(N,Nb)
         -sys_g.Pi]);

sys_g.B_wg=[B_bl,B_misc];

end
