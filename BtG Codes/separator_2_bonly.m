% Author: Ankur Pipri
% Date: 19th April 2017
function separator_2_bonly(X,N,Nb,Ng,g_s,b_s,count_tb)
%This function generates the output from the optimisation vector 
%of Problem type 1
global Result;
XBS=X(1:2*Nb*b_s);                                     % Extraction of Building States
XUG=X((2*Nb*b_s)+1:(2*Nb*b_s)+(Nb*b_s));             % Extraction of HVAC Powers

for k=1:2
    Xb_t(:,k)=XBS(((k-1)*2*Nb)+1:k*2*Nb);
end

for k=1:2
    Xug(:,k)=XUG(((k-1)*Nb)+1:k*Nb);
end

Result.B_States(:,count_tb+1)=Xb_t(:,2);
Result.B_HVAC(:,count_tb+1)=Xug(:,2);

end