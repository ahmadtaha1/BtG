function separator_3(X,N,Nb,Ng,g_s,b_s,count_tg)
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
XGS=X(1:(2*N*g_s));                                  % Extraction of Grid States
XUMP=X((2*N*g_s)+1:end);   % Extraction of Mechanical Power Variations

for k=1:2
    Xg(:,k)=XGS(((k-1)*2*N)+1:(k*2*N));
end

for k=1:2
    Xump(:,k)=XUMP(((k-1)*Ng)+1:k*Ng);
end

Result.G_States(:,count_tg+1)=Xg(:,2);
Result.G_ump(:,count_tg+1)=Xump(:,2);

end