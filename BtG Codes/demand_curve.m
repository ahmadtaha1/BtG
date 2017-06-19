% Author: Ankur Pipri
% Date: 19th April 2017
function [bl,pmisc] = demand_curve(Nb,base,hg,t,days) 
% This function prepares the grid disturbances (grid base load and the 
% building's miscellaneous loads) at grid's sampling frequency
global test sys_g sys_b;
dct=24*3600;                 % Data collection time taken as 24 hrs
d1=[0.78;0.70;0.64;0.62;0.63;0.70;0.91;1.01;0.99;0.98;0.96;0.96;0.97;...
    0.95;0.95;1.01;1.19;1.45;1.51;1.49;1.40;1.27;1.04;0.92]; %Originalcurve
d1(25,1)=d1(1,1);
factor=sum(sys_g.base_max_load)/(1.51*base);   % Original curve is shifted 
                                               % up by this factor,1.51pu
                                               % is max in original curve
d1=d1*factor;
t=0;
k=3600/hg;
for i=1:24
    d3(((k*t)+1):((k*t)+k),1)=linspace(d1(i,1),d1(i+1,1),k);
    t=t+1;
end
pcnt=test.bus(:,3)/sum(test.bus(:,3));
bl=pcnt*d3';

sys_b.umisc(:,289)=sys_b.umisc(:,1);    % umisc values (in KW)
for b=1:1:Nb
    t=0;
    k=300/hg;
    for i=1:1:288
        pmisc(b,((k*t)+1):((k*t)+k))=...
            linspace(sys_b.umisc(b,i),sys_b.umisc(b,i+1),k);
        t=t+1;         % to make data available at grid sampling frequency
    end
end
pmisc=(1/(1000*base))*pmisc;    %KW values converted in pu

end        