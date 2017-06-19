% Author: Ankur Pipri
% Date: 19th April 2017
function plot_final_result_gonly(time,N,Ng,Nb,hg,hb,T_p,z,g_s,b_s,base)
%This function plots the final result and graphs etc.

global test Result sys_b limit_n;
%% Defining different scales for plotting figures
time=time/3600;
scale1=linspace(0,time,size(Result.G_States(:,1:end-1),2));
scale2=linspace(0,time,size(sys_b.Tz(:,1:end-2),2));
scale3=linspace(0,time,size(Result.G_usp,2)+1);
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
% % Total Load
% r=1;
% for i=1:1:size(Result.B_HVAC,2)-1
%     ub(:,r:r+(T_p/z)-1)=repmat(Result.B_HVAC(:,i+1),1,(T_p/z));
%     r=r+(T_p/z);
% end
% Result.G_load=sys_g.bl(:,1:size(ub,2))+sys_g.Pi*(-1/(10^6*base))*ub+sys_g.Pi*sys_g.umisc(:,1:size(ub,2));
% % 
% figure (10)
% scale4=linspace(0,time,size(Result.G_gen,2));
% plot(scale4,sum(Result.G_gen)*base,'red','LineWidth',lw);
% hold on;
% plot(scale4,sum(sys_g.bl(:,1:size(Result.G_gen,2)))*base,'magenta','LineWidth',lw);
% hold on;
% plot(scale4,sum(sys_g.umisc(:,1:size(Result.G_gen,2)))*base,'green','LineWidth',lw);
% hold on;
% plot(scale4,sum(ub(:,1:size(Result.G_gen,2)))*(-1/10^6),'cyan','LineWidth',lw);
% hold on;
% plot(scale4,sum(Result.G_load(:,1:size(Result.G_gen,2)))*base,'black','LineWidth',lw);
% hold on;
% %set(gca,'XLim',[0 24],'YLim',[-20 20],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[-20:5:20],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% lg=legend('Resultant Generation','Grid Base Load','Building Base Load','Building HVAC Loads','Total Grid Load');
% set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Total Grid Generation vs Load','interpreter','latex','fontsize',fs);

%% Frequency and Bus angles plots
% Bus Angles
Result.G_angles=Result.G_States(1:N,:);
for n=1:N
    plot_angles_1(n,:)=Result.G_angles(n,:)-Result.G_angles(test.ref_bus,:);
end
figure(2)
for n=2:N
    stairs(scale1,(180/pi)*plot_angles_1(n,1:end-1),'LineWidth',lw);
    hold on;
end
%set(gca,'XLim',[0 24],'YLim',[-20 20],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[-20:5:20],'fontname','Times New Roman','fontsize',fs);
set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% lg=legend('$\delta_1$','$\delta_2$','$\delta_3$','$\delta_4$','$\delta_5$','$\delta_6$','$\delta_7$','$\delta_8$','$\delta_9$');
% set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('Bus Angle (deg)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Bus Angles','interpreter','latex','fontsize',fs);

% Bus Frequencies
Result.G_frequencies=Result.G_States(N+1:2*N,:);
figure(3)
subplot(2,1,1)
% max_f=max(60+(inv(2*pi))*Result.G_frequencies);
% min_f=min(60+(inv(2*pi))*Result.G_frequencies);
% max_f=max_f(1,1:end-1);
% min_f=min_f(1,1:end-1);
% X=[scale1(1,1:end),fliplr(scale1(1,1:end))];                %#create continuous x value array for plotting
% Y=[min_f,fliplr(max_f)];
% avg_f=mean(60+(inv(2*pi))*Result.G_frequencies,1);
% avg_f=avg_f(1,1:end-1);
% fill(X,Y,[0.98 0.87 1],'EdgeColor',[0.98 0.87 1]);
% hold on;
% plot(scale1,avg_f,'color',[0.91 0.28 1],'linewidth',lw);
for n=1:N
stairs(scale1,60+(inv(2*pi))*(Result.G_frequencies(n,1:end-1)),'LineWidth',lw);
hold on;
end
set(gca,'XLim',[0 24],'YLim',[59.992 60.005],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[59.992:0.005:60.005],'fontname','Times New Roman','fontsize',fs);
%set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
lg=legend('$f_1$','$f_2$','$f_3$','$f_4$','$f_5$','$f_6$','$f_7$','$f_8$','$f_9$','$f_{10}$','$f_{11}$','$f_{12}$','$f_{13}$','$f_{14}$');
set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$\omega$ (Hz)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Bus Frequencies','interpreter','latex','fontsize',fs);

subplot(2,1,2)
max_g=max(Result.G_gen*base);
min_g=min(Result.G_gen*base);
X=[scale1(1,1:end),fliplr(scale1(1,1:end))];                %#create continuous x value array for plotting
Y=[min_g,fliplr(max_g)];
avg_g=mean(Result.G_gen*base,1);
fill(X,Y,[0.78 0.96 0.82],'EdgeColor',[0.78 0.96 0.82]);
hold on;
plot(scale1,avg_g,'color',[0.35 0.84 0.61],'linewidth',lw);
%plot(scale4,(Result.G_gen')*base,'LineWidth',lw);
set(gca,'XLim',[0 24],'YLim',[0 400],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[0:50:400],'fontname','Times New Roman','fontsize',fs);
%set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
l=legend('Power Generation Range','Average Generation');
set(l,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$\bar{u_g} + \Delta u_g$ (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Actual Power Generation from Generators (u_sp+u_var)','interpreter','latex','fontsize',fs);

%% Power Generation Plots
% OPF generation setpoints
plot_usp=Result.G_usp;
plot_usp(:,end+1)=plot_usp(:,end);
figure(4)
for n=1:Ng
stairs(scale3,base*plot_usp(n,:),'LineWidth',lw);
hold on;
end
%set(gca,'XLim',[0 24],'YLim',[0 0.50],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[0:0.25:0.50],'fontname','Times New Roman','fontsize',fs);
set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% lg=legend('$\bar u_{g1}$','$\bar u_{g2}$','$\bar u_{g3}$');
% set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Mechanical Power Setpoints ($\bar u_g$)','interpreter','latex','fontsize',fs);

% Generation adjustments
figure(5)
for n=1:Ng
stairs(scale1,base*Result.G_ump(n,1:end-1),'LineWidth',lw);
hold on;
end
%set(gca,'XLim',[0 24],'YLim',[0 0.50],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[0:0.25:0.50],'fontname','Times New Roman','fontsize',fs);
set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% lg=legend('$\bar u_{g1}$','$\bar u_{g2}$','$\bar u_{g3}$');
% set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Mechanical Power Adjustments ($\Delta u_g$)','interpreter','latex','fontsize',fs);

%% Building Wall and Zone Temperatures
% Separating Wall and Zone Temperatures
% for k=1:1:size(Result.B_States,2)
%     i=1;
%     for j=1:1:Nb
%         Result.B_Wtemp(j,k)=Result.B_States(i,k);
%         Result.B_Ztemp(j,k)=Result.B_States(i+1,k);
%         %Xb_zt(j,k)=Xb_t(i+1,k);
%         i=i+2;
%     end
% end
% 
% % Plotting Wall Temperatures
% figure(6)
% for n=1:Nb
%     stairs(scale2,Result.B_Wtemp(n,1:end-1),'LineWidth',lw);
%     hold on;
% end    
% %set(gca,'XLim',[0 24],'YLim',[20 40],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[20:5:40],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Temperature ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Building States (Wall Temperatures)','interpreter','latex','fontsize',fs);

% Plotting Zone Temperatures
figure(7)
subplot(2,1,1)
max_zt=max(sys_b.Tz);
min_zt=min(sys_b.Tz);
max_zt=max_zt(1,1:end-2);
min_zt=min_zt(1,1:end-2);
X=[scale2(1,1:end),fliplr(scale2(1,1:end))];                %#create continuous x value array for plotting
Y=[min_zt,fliplr(max_zt)];
avg_zt=mean(sys_b.Tz,1);
avg_zt=avg_zt(1,1:end-2);
fill(X,Y,[0.81 0.78 1],'EdgeColor',[0.81 0.78 1]);
hold on;
plot(scale2,avg_zt,'color',[0 0.11 1],'linewidth',lw);
% for n=1:Nb
%     stairs(scale2,Result.B_Ztemp(n,1:end-1),'LineWidth',lw);
%     hold on;
% end    
set(gca,'XLim',[0 24],'YLim',[21 30],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[21:1:30],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$T_{\mathrm{zone}}$ ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
l=legend('Zone Temperature Range','Average Zone Temperature');
set(l,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Building Zone Temperatures','interpreter','latex','fontsize',fs);

%% Building HVAC Loads
subplot(2,1,2)
max_hv=max(Result.B_HVAC)*(-1/1000);
min_hv=min(Result.B_HVAC)*(-1/1000);
max_hv=max_hv(1,1:end-1);
min_hv=min_hv(1,1:end-1);
X=[scale2(1,1:end-1),fliplr(scale2(1,1:end-1))];                %#create continuous x value array for plotting
Y=[min_hv,fliplr(max_hv)];
avg_hv=mean(Result.B_HVAC,1)*(-1/1000);
%avg_hv=avg_hv(1,1:end-1);
fill(X,Y,[1 0.85 0.87],'EdgeColor',[1 0.85 0.87]);
hold on;
plot(scale2,avg_hv,'color',[0.81 0 0],'linewidth',lw);
% for n=1:Nb
% stairs(scale2,(-1/1000)*Result.B_HVAC(n,1:end-1),'LineWidth',lw);
% hold on;
% end
set(gca,'XLim',[0 24],'YLim',[0 400],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[0:100:400],'fontname','Times New Roman','fontsize',fs);
%set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('$P_{\mathrm{HVAC}}$ (KW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
l=legend('HVAC Power Range','Average HVAC Load');
set(l,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Buildings HVAC Load','interpreter','latex','fontsize',fs);

end

% global test Result sys_g limit_n;
% %% Defining different scales for plotting figures
% time=time/3600;
% scale1=linspace(0,time,size(Result.G_States(:,1:end-1),2));
% scale2=linspace(0,time,size(Result.B_HVAC(:,1:end-1),2));
% scale3=linspace(0,time,size(Result.G_usp,2)+1);
% fs=20;
% lw=2;
% 
% %% Getting total generation and total load curve
% %Total generation
% r=1;
% for i=1:1:size(Result.G_usp,2)
%     usp(:,r:r+(T_p/hg)-1)=repmat(Result.G_usp(:,i),1,(T_p/hg));
%     r=r+(T_p/hg);
% end
% Result.G_gen=usp(:,1:size(Result.G_ump,2)-1)+Result.G_ump(:,2:end);
% %Result.G_gen=usp(:,1:size(Result.G_ump,2))+Result.G_ump;
% % Total Load
% r=1;
% for i=1:1:size(Result.B_HVAC,2)-1
%     ub(:,r:r+(T_p/z)-1)=repmat(Result.B_HVAC(:,i+1),1,(T_p/z));
%     r=r+(T_p/z);
% end
% Result.G_load=sys_g.bl(:,1:size(ub,2))+sys_g.Pi*(-1/(10^6*base))*ub+sys_g.Pi*sys_g.umisc(:,1:size(ub,2));
% % 
% % figure (10)
% scale4=linspace(0,time,size(Result.G_gen,2));
% % plot(scale4,sum(Result.G_gen)*base,'red','LineWidth',lw);
% % hold on;
% % plot(scale4,sum(sys_g.bl(:,1:size(Result.G_gen,2)))*base,'magenta','LineWidth',lw);
% % hold on;
% % plot(scale4,sum(sys_g.umisc(:,1:size(Result.G_gen,2)))*base,'green','LineWidth',lw);
% % hold on;
% % plot(scale4,sum(ub(:,1:size(Result.G_gen,2)))*(-1/10^6),'cyan','LineWidth',lw);
% % hold on;
% % plot(scale4,sum(Result.G_load(:,1:size(Result.G_gen,2)))*base,'black','LineWidth',lw);
% % hold on;
% % %set(gca,'XLim',[0 24],'YLim',[-20 20],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[-20:5:20],'fontname','Times New Roman','fontsize',fs);
% % set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % lg=legend('Resultant Generation','Grid Base Load','Building Base Load','Building HVAC Loads','Total Grid Load');
% % set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % title('Total Grid Generation vs Load','interpreter','latex','fontsize',fs);
% 
% figure (9)
% plot(scale4,(Result.G_gen')*base,'LineWidth',lw);
% %set(gca,'XLim',[0 24],'YLim',[-20 20],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[-20:5:20],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% %lg=legend('Resultant Generation','Grid Base Load','Building Base Load','Building HVAC Loads','Total Grid Load');
% %set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Actual Power Generation from Generators (u_sp+u_var)','interpreter','latex','fontsize',fs);
% 
% %% Frequency and Bus angles plots
% % Bus Angles
% Result.G_angles=Result.G_States(1:N,:);
% for n=1:N
%     plot_angles_1(n,:)=Result.G_angles(n,:)-Result.G_angles(test.ref_bus,:);
% end
% %plot_angles=mod(plot_angles_1+pi,2*pi)-pi;    % To keep angles between -pi to pi
% figure(2)
% for n=2:N
%     stairs(scale1,(180/pi)*plot_angles_1(n,1:end-1),'LineWidth',lw);
%     hold on;
% end
% %set(gca,'XLim',[0 24],'YLim',[-20 20],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[-20:5:20],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % lg=legend('$\delta_1$','$\delta_2$','$\delta_3$','$\delta_4$','$\delta_5$','$\delta_6$','$\delta_7$','$\delta_8$','$\delta_9$');
% % set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Bus Angle (deg)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Bus Angles','interpreter','latex','fontsize',fs);
% 
% % Bus Frequencies
% Result.G_frequencies=Result.G_States(N+1:2*N,:);
% figure(3)
% for n=1:N
% stairs(scale1,60+(inv(2*pi))*(Result.G_frequencies(n,1:end-1)),'LineWidth',lw);
% hold on;
% end
% %set(gca,'XLim',[0 24],'YLim',[59.99 60.01],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[59.99:0.005:60.01],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % lg=legend('$f_1$','$f_2$','$f_3$','$f_4$','$f_5$','$f_6$','$f_7$','$f_8$','$f_9$');
% % set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Frequency (Hz)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Bus Frequencies','interpreter','latex','fontsize',fs);
% 
% %% Power Generation Plots
% % OPF generation setpoints
% plot_usp=Result.G_usp;
% plot_usp(:,end+1)=plot_usp(:,end);
% figure(4)
% for n=1:Ng
% stairs(scale3,base*plot_usp(n,:),'LineWidth',lw);
% hold on;
% end
% %set(gca,'XLim',[0 24],'YLim',[0 0.50],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[0:0.25:0.50],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % lg=legend('$\bar u_{g1}$','$\bar u_{g2}$','$\bar u_{g3}$');
% % set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Mechanical Power Setpoints ($\bar u_g$)','interpreter','latex','fontsize',fs);
% 
% % Generation adjustments
% figure(5)
% for n=1:Ng
% stairs(scale1,base*Result.G_ump(n,1:end-1),'LineWidth',lw);
% hold on;
% end
% %set(gca,'XLim',[0 24],'YLim',[0 0.50],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[0:0.25:0.50],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % lg=legend('$\bar u_{g1}$','$\bar u_{g2}$','$\bar u_{g3}$');
% % set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Mechanical Power Adjustments ($\Delta u_g$)','interpreter','latex','fontsize',fs);
% 
% % %% Building Wall and Zone Temperatures
% % % Separating Wall and Zone Temperatures
% % for k=1:1:size(Result.B_States,2)
% %     i=1;
% %     for j=1:1:Nb
% %         Result.B_Wtemp(j,k)=Result.B_States(i,k);
% %         Result.B_Ztemp(j,k)=Result.B_States(i+1,k);
% %         %Xb_zt(j,k)=Xb_t(i+1,k);
% %         i=i+2;
% %     end
% % end
% % 
% % % Plotting Wall Temperatures
% % figure(6)
% % for n=1:Nb
% %     stairs(scale2,Result.B_Wtemp(n,1:end-1),'LineWidth',lw);
% %     hold on;
% % end    
% % %set(gca,'XLim',[0 24],'YLim',[20 40],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[20:5:40],'fontname','Times New Roman','fontsize',fs);
% % set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % ylabel('Temperature ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % title('Building States (Wall Temperatures)','interpreter','latex','fontsize',fs);
% % 
% % % Plotting Zone Temperatures
% % figure(7)
% % for n=1:Nb
% %     stairs(scale2,Result.B_Ztemp(n,1:end-1),'LineWidth',lw);
% %     hold on;
% % end    
% % %set(gca,'XLim',[0 24],'YLim',[20 40],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[20:5:40],'fontname','Times New Roman','fontsize',fs);
% % set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % ylabel('Temperature ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % title('Building States (Zone Temperatures)','interpreter','latex','fontsize',fs);
% 
% %% Building HVAC Loads
% figure(8)
% for n=1:Nb
% stairs(scale2,(-1/1000)*Result.B_HVAC(n,1:end-1),'LineWidth',lw);
% hold on;
% end
% %set(gca,'XLim',[0 24],'YLim',[0 400],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[0:100:400],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Power (KW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Buildings HVAC Load ($u_b$)','interpreter','latex','fontsize',fs);
% 
% % figure (10)
% % plot(scale4,(Result.G_gen')*base,'LineWidth',lw);
% % hold on;
% % plot(scale4,repmat(base*limit_n.ug_sps_high,1,length(scale4)),'LineWidth',lw);
% % hold on;
% % plot(scale4,repmat(base*limit_n.ug_sps_low,1,length(scale4)),'LineWidth',lw);
% % %set(gca,'XLim',[0 24],'YLim',[-20 20],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[-20:5:20],'fontname','Times New Roman','fontsize',fs);
% % set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% % %lg=legend('Resultant Generation','Grid Base Load','Building Base Load','Building HVAC Loads','Total Grid Load');
% % %set(lg,'interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % ylabel('Power (MW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% % title('Actual Power Generation from Generators (u_sp+u_var)','interpreter','latex','fontsize',fs);

%end

