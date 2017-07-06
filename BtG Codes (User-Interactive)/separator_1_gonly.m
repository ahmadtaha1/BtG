function separator_1_gonly(X,N,Nb,Ng,g_s,b_s,count_tg,count_tb,count_tp)
% Author: Ankur Pipri
% Date: 19th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

%This function generates the output from the optimisation vector 
%of Problem type 1
global Result;
% XBS=X(1:2*Nb*b_s);                                     % Extraction of Building States
% XUG=X((2*Nb*b_s)+1:(2*Nb*b_s)+(Nb*b_s));             % Extraction of HVAC Powers
XGS=X(1:(2*N*g_s));                                  % Extraction of Grid States
XUMP=X((2*N*g_s)+1:end);                          % Extraction of Mechanical Power Variations

% for k=1:2
%     Xb_t(:,k)=XBS(((k-1)*2*Nb)+1:k*2*Nb);
% end
% 
% for k=1:2
%     Xug(:,k)=XUG(((k-1)*Nb)+1:k*Nb);
% end

for k=1:2
    Xg(:,k)=XGS(((k-1)*2*N)+1:(k*2*N));
end

for k=1:2
    Xump(:,k)=XUMP(((k-1)*Ng)+1:k*Ng);
end

Xsp=XUMP(end-Ng+1:end,1);

% Result.B_States(:,count_tb+1)=Xb_t(:,2);
% Result.B_HVAC(:,count_tb+1)=Xug(:,2);
Result.G_States(:,count_tg+1)=Xg(:,2);
Result.G_ump(:,count_tg+1)=Xump(:,2);
Result.G_usp(:,count_tp)=Xsp;

end

