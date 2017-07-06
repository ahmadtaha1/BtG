function matrices_generator_new(N,Nb,Ng,Nc,b_s,g_s,base,z)
% Author: Ankur Pipri
% Date: 19th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

%This function generates the matrices for the standard form of the problem
%to fed into the quadprog/cplex solver
global sys_g sys_b sys_dg sys_db cost_n limit_n P1 P2 P3;

N_new=(2*N);
l1=((2*Nb)*b_s)+(Nb*b_s)+(N_new*g_s)+(Ng*g_s)+Ng;    % Length of Optimisation Vector for problem type 1
l2=l1-Ng;                                            % Length of Optimisation Vector for problem type 2
l3=(N_new*g_s)+(Ng*g_s);                             % Length of Optimisation Vector for problem type 3
s1=(2*Nb*b_s)+(Nb*b_s);                              % Building Part

%% Matrices for Problem Type 1
% Aeq
Aeq=cell(2,5);             % Three set of equations: 1-Building states
                           %                         2-Grid States
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
Aeq{1,3}=sparse(2*Nb*b_s,(N_new*g_s)); % coefficient for grid state part
Aeq{1,4}=sparse(2*Nb*b_s,(Ng*g_s));        % coefficient for mechanical power variations part
Aeq{1,5}=sparse(2*Nb*b_s,Ng);        % coefficient for mechanical power setpoints part

Aeq{2,1}=zeros(N_new*g_s,(2*Nb*b_s)); % coefficient for building state part
q3=repmat(-sys_dg.B_gub*(-1/(10^6*base)),z,1);
q3=kron(eye(b_s-1),q3);
gsug=blkdiag(zeros(N_new,Nb),q3);
Aeq{2,2}=gsug;                              % coefficient for HVAC powers part
q1=sparse(kron(eye(g_s),eye(N_new)));       % coefficient for current grid state
q2=sparse(kron(eye(g_s-1),-sys_dg.A_g));    % coefficient for previous grid state
q2=[zeros((N_new),size(q1,2))
    q2,zeros((size(q1,1)-N_new),N_new)];
GSP=q1+q2;                                  % coefficient for grid state part
Aeq{2,3}=GSP;
q4=kron(eye(g_s-1),-sys_dg.B_ug);
gsump=blkdiag(zeros(N_new,Ng),q4);
Aeq{2,4}=gsump;                             % coefficient for mechanical power variations part
q5=repmat(-sys_dg.B_ug,(g_s-1),1);
gsusp=[zeros(N_new,Ng);q5];
Aeq{2,5}=gsusp; % coefficient for building state part

AEQ=sparse(cell2mat(Aeq));
P1.Aeq=AEQ; % for Problem type I
P2.Aeq=AEQ(:,1:end-Ng); % for problem type II
P3.Aeq=P2.Aeq((2*Nb*b_s)+1:end,s1+1:end);   % for Problem type III

%% H Matrix
h1=blkdiag(zeros(N),cost_n.sqcost_freq*eye(N)) * 1;
h1=sparse(kron(eye(g_s),h1));
h2=diag(cost_n.sqcost_udelta) * 1;
h2=sparse(kron(eye(g_s),h2));
h3=sparse(diag(cost_n.sqcost_usp) * 1);
P1.H=blkdiag(zeros(s1,s1),h1,h2,h3);
P2.H=P1.H(1:end-Ng,1:end-Ng);
P3.H=blkdiag(h1,h2);

%% f vector (only for grid only time samples)
f2=repmat(cost_n.lincost_udelta,g_s,1);
P3.f=sparse([zeros((N_new*g_s),1);f2] * 1);


%% New ANEQ matrix
gen=cell(2,1);

an1=sparse(zeros(Ng*(g_s),s1+(2*N*g_s)));
an2=sparse(eye(Ng*(g_s)));
an3=sparse(repmat(eye(Ng),g_s,1));
gen{1,1}=[an1,an2,an3];
gen{2,1}=-[an1,an2,an3];
gen_lim=sparse(cell2mat(gen));

Aneq=cell(2,5);

Aneq{1,1}=zeros(Nc,(2*Nb*b_s));
Aneq{1,2}=[zeros(Nc,Nb) , -sys_g.PTDF*sys_g.Pi*(-1/(10^6*base)) , zeros(Nc,(Nb*(b_s-2)))];
Aneq{1,3}=zeros(Nc,(2*N*g_s));
Aneq{1,4}=zeros(Nc,Ng*g_s);
Aneq{1,5}=sys_g.PTDF*sys_g.Gamma;

Aneq{2,1}=zeros(Nc,(2*Nb*b_s));
Aneq{2,2}=[zeros(Nc,Nb) , sys_g.PTDF*sys_g.Pi*(-1/(10^6*base)) , zeros(Nc,(Nb*(b_s-2)))];
Aneq{2,3}=zeros(Nc,(2*N*g_s));
Aneq{2,4}=zeros(Nc,Ng*g_s);
Aneq{2,5}=-sys_g.PTDF*sys_g.Gamma;

P1.Aneq=sparse(cell2mat(Aneq));
% P1.Aneq=[P1.Aneq;gen_lim];

end

