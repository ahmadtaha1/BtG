function matrices_generator_gonly(N,Nb,Ng,Nc,b_s,g_s,base,z)
% Author: Ankur Pipri
% Date: 19th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

%This function generates the matrices for the standard form of the problem
%to fed into the quadprog solver for GRID ONLY CASE
global sys_g sys_b sys_dg sys_db cost_n limit_n P1 P2 P3;

N_new=(2*N);
l1=(N_new*g_s)+(Ng*g_s)+Ng;    % Length of Optimisation Vector for problem type 1
%l2=l1-Ng;                                            % Length of Optimisation Vector for problem type 2
l3=(N_new*g_s)+(Ng*g_s);                             % Length of Optimisation Vector for problem type 3
% s1=(2*Nb*b_s)+(Nb*b_s);                              % Building Part

%% Matrices for Problem Type 1
% Aeq
Aeq=cell(1,3);             % Three set of equations: 

q1=sparse(kron(eye(g_s),eye(N_new)));       % coefficient for current grid state
q2=sparse(kron(eye(g_s-1),-sys_dg.A_g));    % coefficient for previous building state
q2=[zeros((N_new),size(q1,2))
    q2,zeros((size(q1,1)-N_new),N_new)];
GSP=q1+q2;                                  % coefficient for grid state part
Aeq{1,1}=GSP;

q4=kron(eye(g_s-1),-sys_dg.B_ug);
gsump=blkdiag(zeros(N_new,Ng),q4);
Aeq{1,2}=gsump;                             % coefficient for mechanical power variations part

q5=repmat(-sys_dg.B_ug,(g_s-1),1);
gsusp=[zeros(N_new,Ng);q5];
Aeq{1,3}=gsusp; % coefficient for building state part

AEQ=sparse(cell2mat(Aeq));
P1.Aeq=AEQ;
P3.Aeq=AEQ(:,1:end-Ng);
%P3.Aeq=P2.Aeq((2*Nb*b_s)+1:end,s1+1:end);

%% H Matrix
h1=blkdiag(zeros(N),cost_n.sqcost_freq*eye(N));
h1=sparse(kron(eye(g_s),h1));
h2=diag(cost_n.sqcost_udelta);
h2=sparse(kron(eye(g_s),h2));
h3=sparse(diag(cost_n.sqcost_usp));
P1.H=blkdiag(h1,h2,h3);
P2.H=P1.H(1:end-Ng,1:end-Ng);
P3.H=blkdiag(h1,h2);

%% f vector (only for grid only time samples)
f2=repmat(cost_n.lincost_udelta,g_s,1);
P3.f=sparse([zeros((N_new*g_s),1);f2]);


%% New ANEQ matrix
gen=cell(2,1);

an1=sparse(zeros(Ng*(g_s),(2*N*g_s)));
an2=sparse(eye(Ng*(g_s)));
% an2=sparse([zeros(Ng*(g_s),Ng),an2]);
an3=sparse(repmat(eye(Ng),g_s,1));
gen{1,1}=[an1,an2,an3];
gen{2,1}=-[an1,an2,an3];
gen_lim=sparse(cell2mat(gen));

Aneq=cell(2,3);

% Aneq{1,1}=zeros(Nc,(2*Nb*b_s));
% Aneq{1,2}=[zeros(Nc,Nb) , -sys_g.PTDF*sys_g.Pi*(-1/(10^6*base)) , zeros(Nc,(Nb*(b_s-2)))];
Aneq{1,1}=zeros(Nc,(2*N*g_s));
Aneq{1,2}=zeros(Nc,Ng*g_s);
Aneq{1,3}=sys_g.PTDF*sys_g.Gamma;

% Aneq{2,1}=zeros(Nc,(2*Nb*b_s));
% Aneq{2,2}=[zeros(Nc,Nb) , sys_g.PTDF*sys_g.Pi*(-1/(10^6*base)) , zeros(Nc,(Nb*(b_s-2)))];
Aneq{2,1}=zeros(Nc,(2*N*g_s));
Aneq{2,2}=zeros(Nc,Ng*g_s);
Aneq{2,3}=-sys_g.PTDF*sys_g.Gamma;

P1.Aneq=sparse(cell2mat(Aneq));
% P1.Aneq=[P1.Aneq;gen_lim];

end

