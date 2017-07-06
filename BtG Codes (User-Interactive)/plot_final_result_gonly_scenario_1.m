function plot_final_result_gonly_scenario_1(time,N,Ng,Nb,hg,hb,T_p,z,g_s,b_s,base)
% Author: Ankur Pipri
% Date: 19th April 2017
% If you wish to use full or any part of this material in your research,
% you are requested to cite the following papers:
% 1. A.F. Taha, N. Gatsis, B. Dong, A. Pipri, Z. Li,"Buildings-to-Grid
% Integration Framework", IEEE Transanctions on Smart Grid March 2017, submitted
% 2. Z.Li; A.Pipri; B.Dong; N.Gatsis; A.F.Taha; N.Yu,"Modelling, Simulation and Control of Smart and Connected Communities"

%This function plots the final result and graphs etc.

global test Result sys_b limit_n;
%% Defining different scales for plotting figures
time=time/3600;
scale1=linspace(0,time,size(Result.G_States(:,1:end-1),2));
scale2=linspace(0,time,size(Result.B_HVAC(:,1:end-1),2));
fs=24;
lw=3;

%% Getting total generation and total load curve
%Total generation
r=1;
for i=1:1:size(Result.G_usp,2)
    usp(:,r:r+(T_p/hg)-1)=repmat(Result.G_usp(:,i),1,(T_p/hg));
    r=r+(T_p/hg);
end
Result.G_gen=usp(:,1:size(Result.G_ump,2)-1)+Result.G_ump(:,2:end);

%% Frequency and Bus angles plots
% Bus Angles
for i=1:N
    if (test.bus(i,2)==3)
        test.ref_bus=i;
    end
end
Result.G_angles=Result.G_States(1:N,:);
for n=1:N
    plot_angles_1(n,:)=Result.G_angles(n,:)-Result.G_angles(test.ref_bus,:);
end

% Bus Frequencies
Result.G_frequencies=Result.G_States(N+1:2*N,:);
figure(1)
% Frequencies
subplot(2,1,1)
for n=1:N
stairs(scale1,60+(inv(2*pi))*(Result.G_frequencies(n,1:end-1)),'LineWidth',lw);
hold on;
end
set(gca,'XLim',[0 24],'YLim',[59.986 60.002],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[59.986:0.004:60.002],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[59.990:0.004:60.002],'fontname','Times New Roman','fontsize',fs);
% lg=legend('$f_1$','$f_2$','$f_3$','$f_4$','$f_5$','$f_6$','$f_7$','$f_8$','$f_9$','$f_{10}$','$f_{11}$','$f_{12}$','$f_{13}$','$f_{14}$');
% set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$\omega$ (Hz)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Scenario I: Bus Frequencies and Actual Power Generation','interpreter','latex','fontsize',fs);

% Generation
subplot(2,1,2)
max_g=max(Result.G_gen*base);
min_g=min(Result.G_gen*base);
X=[scale1(1,1:end),fliplr(scale1(1,1:end))];                %#create continuous x value array for plotting
Y=[min_g,fliplr(max_g)];
avg_g=mean(Result.G_gen*base,1);
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
max_zt=max(sys_b.Tz(:,1:end-2));
min_zt=min(sys_b.Tz(:,1:end-2));
max_zt=max_zt(1,1:end-1);
min_zt=min_zt(1,1:end-1);
X=[scale2(1,1:end),fliplr(scale2(1,1:end))];                %#create continuous x value array for plotting
Y=[min_zt,fliplr(max_zt)];
avg_hv=mean(sys_b.Tz(:,1:end-2),1);
avg_hv=avg_hv(1,1:end-1);
fill(X,Y,[0.81 0.78 1],'EdgeColor',[0.81 0.78 1]);
hold on;
plot(scale2,avg_hv,'color',[0 0.11 1],'linewidth',lw);
set(gca,'XLim',[0 24],'YLim',[21 25],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[21:1:25],'fontname','Times New Roman','fontsize',fs);
ylabel('$T_{\mathrm{zone}}$ ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
l=legend('Zone Temperature Range','Average Zone Temperature');
set(l,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Scenario I: Building Zone Temperatures and HVAC Loads','interpreter','latex','fontsize',fs);

% Building HVAC Loads
subplot(2,1,2)
max_hv=max(Result.B_HVAC)*(-1/1000);
min_hv=min(Result.B_HVAC)*(-1/1000);
max_hv=max_hv(1,1:end-1);
min_hv=min_hv(1,1:end-1);
X=[scale2(1,1:end),fliplr(scale2(1,1:end))];                %#create continuous x value array for plotting
Y=[min_hv,fliplr(max_hv)];
avg_hv=mean(Result.B_HVAC,1)*(-1/1000);
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

