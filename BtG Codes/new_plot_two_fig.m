% Author: Ankur Pipri
% Date: 19th April 2017
function new_plot_two_fig(N,base,time,T_p,hg,g_states,g_ump,g_usp,b_hvac,b_zt)
%This function plots the two figures in the paper for different scenarios.
close all;
%% Defining different scales for plotting figures
time=time/3600; % converting simulation time in Hours to display in the plots
scale1=linspace(0,time,size(g_states(:,1:end-1),2));
scale2=linspace(0,time,size(b_hvac(:,1:end-1),2));
fs=24;
lw=3;

%% Getting total generation curve
% Total generation
r=1;
for i=1:1:size(g_usp,2)
    usp(:,r:r+(T_p/hg)-1)=repmat(g_usp(:,i),1,(T_p/hg));
    r=r+(T_p/hg);
end
g_gen=usp(:,1:size(g_ump,2)-1)+g_ump(:,2:end);

%% Plotting the Bus Frequencies and the total generation 
g_freq=g_states(N+1:2*N,:);
figure(1)
% Frequencies
subplot(2,1,1)
for n=1:N
stairs(scale1,60+(inv(2*pi))*(g_freq(n,1:end-1)),'LineWidth',lw);
hold on;
end
set(gca,'XLim',[0 24],'YLim',[59.986 60.002],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[59.986:0.004:60.002],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[59.990:0.004:60.002],'fontname','Times New Roman','fontsize',fs);
% lg=legend('$f_1$','$f_2$','$f_3$','$f_4$','$f_5$','$f_6$','$f_7$','$f_8$','$f_9$','$f_{10}$','$f_{11}$','$f_{12}$','$f_{13}$','$f_{14}$');
% set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$\omega$ (Hz)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('BtG-GMPC: Bus Frequencies and Actual Power Generation','interpreter','latex','fontsize',fs);
title('Scenario II: Bus Frequencies and Actual Power Generation','interpreter','latex','fontsize',fs);
% title('Scenario I: Bus Frequencies and Actual Power Generation','interpreter','latex','fontsize',fs);

% Generation
subplot(2,1,2)
max_g=max(g_gen*base);
min_g=min(g_gen*base);
X=[scale1(1,1:end),fliplr(scale1(1,1:end))];                %#create continuous x value array for plotting
Y=[min_g,fliplr(max_g)];
avg_g=mean(g_gen*base,1);
fill(X,Y,[0.78 0.96 0.82],'EdgeColor',[0.78 0.96 0.82]);
hold on;
plot(scale1,avg_g,'color',[0.35 0.84 0.61],'linewidth',lw);
set(gca,'XLim',[0 24],'YLim',[0 400],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[0:50:400],'fontname','Times New Roman','fontsize',fs);
l=legend('Power Generation Range','Average Generation');
set(l,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$\bar{u_g} + \Delta u_g$ (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Actual Power Generation from Generators (u_sp+u_var)','interpreter','latex','fontsize',fs);

%% Plotting Zone Temperatures and HVAC Loads
figure(2)
% Zone Temperatures
subplot(2,1,1)
max_zt=max(b_zt);
min_zt=min(b_zt);
max_zt=max_zt(1,1:end-1);
min_zt=min_zt(1,1:end-1);
X=[scale2(1,1:end),fliplr(scale2(1,1:end))];                %#create continuous x value array for plotting
Y=[min_zt,fliplr(max_zt)];
avg_hv=mean(b_zt,1);
avg_hv=avg_hv(1,1:end-1);
fill(X,Y,[0.81 0.78 1],'EdgeColor',[0.81 0.78 1]);
hold on;
plot(scale2,avg_hv,'color',[0 0.11 1],'linewidth',lw);
set(gca,'XLim',[0 24],'YLim',[21 25],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[21:1:25],'fontname','Times New Roman','fontsize',fs);
ylabel('$T_{\mathrm{zone}}$ ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
l=legend('Zone Temperature Range','Average Zone Temperature');
set(l,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('BtG-GMPC: Building Zone Temperatures and HVAC Loads','interpreter','latex','fontsize',fs);
title('Scenario II: Building Zone Temperatures and HVAC Loads','interpreter','latex','fontsize',fs);
% title('Scenario I: Building Zone Temperatures and HVAC Loads','interpreter','latex','fontsize',fs);

% Building HVAC Loads
subplot(2,1,2)
max_hv=max(b_hvac)*(-1/1000);
min_hv=min(b_hvac)*(-1/1000);
max_hv=max_hv(1,1:end-1);
min_hv=min_hv(1,1:end-1);
X=[scale2(1,1:end),fliplr(scale2(1,1:end))];                %#create continuous x value array for plotting
Y=[min_hv,fliplr(max_hv)];
avg_hv=mean(b_hvac,1)*(-1/1000);
avg_hv=avg_hv(1,1:end-1);
fill(X,Y,[1 0.85 0.87],'EdgeColor',[1 0.85 0.87]);
hold on;
plot(scale2,avg_hv,'color',[0.81 0 0],'linewidth',lw);
set(gca,'XLim',[0 24],'YLim',[0 400],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[0:100:400],'fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$P_{\mathrm{HVAC}}$ (KW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
l=legend('HVAC Power Range','Average HVAC Load');
set(l,'interpreter','latex','fontname','Times New Roman','fontsize',fs);

end