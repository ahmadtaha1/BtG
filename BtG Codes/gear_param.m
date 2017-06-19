% Author: Ankur Pipri
% Date: 19th April 2017
function gear_param(gk)
%This function returns the gear's discretization parameters 
global gear;
gear.beta0=0;                    % Gear's variable
alphaisum=0;                     % Gear's variable
gear.alphai=zeros(gk,1);         % This is a vector for higher order
for i=1:1:gk
    gear.beta0=gear.beta0 + (1/i);
end
gear.beta0=1/gear.beta0;
for i=1:1:gk
    for j=i:1:gk
        alphaisum=alphaisum+(1/j)*(nchoosek(j,i));
    end
    gear.alphai(i,1)=((-1)^(i+1))*gear.beta0*alphaisum;
    alphaisum=0;
end
end

