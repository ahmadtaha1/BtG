function matrices_generator_bonly(N,Nb,Ng,Nc,b_s,g_s,base,z)
%This function generates the matrices for the standard form of the problem
%to fed into the quadprog solver
global sys_g sys_b sys_dg sys_db cost_n limit_n P1 P2 P3;

s1=(2*Nb*b_s)+(Nb*b_s);                              % Building Part

%% Matrices for Problem Type 1
% Aeq
Aeq=cell(1,2);             % Three set of equations: 1-Building states

p1=sparse(kron(eye(b_s),eye(2*Nb)));      % coefficient for current building state
p2=sparse(kron(eye(b_s-1),-sys_db.Ab));   % coefficient for previous building state
p2=[zeros(2*Nb,size(p1,2))
    p2,zeros((size(p1,1)-2*Nb),2*Nb)];
BSP=p1+p2;                             % Buildings State Part in Big Aeq Matrix
Aeq{1,1}=BSP;
p3=sparse(kron(eye(b_s-1),-sys_db.Bub));
bsub=[zeros(2*Nb,Nb+size(p3,2))
      zeros(size(p3,1),Nb),p3];        % coefficient for ub
Aeq{1,2}=bsub;

AEQ=sparse(cell2mat(Aeq));
P2.Aeq=AEQ;

%% H Matrix
P2.H=zeros(s1,s1);

end