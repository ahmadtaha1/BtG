% Author: Ankur Pipri
% Date: 19th April 2017
function plot_final_result_bonly(time,N,Ng,Nb,hg,hb,T_p,z,g_s,b_s,base)
%This function plots the final result and graphs etc.

global test Result sys_g;
%% Defining different scales for plotting figures
time=time/3600;
scale2=linspace(0,time,size(Result.B_States(:,1:end-1),2));
fs=20;
lw=2;

%% Building Wall and Zone Temperatures
% Separating Wall and Zone Temperatures
for k=1:1:size(Result.B_States,2)
    i=1;
    for j=1:1:Nb
        Result.B_Wtemp(j,k)=Result.B_States(i,k);
        Result.B_Ztemp(j,k)=Result.B_States(i+1,k);
        %Xb_zt(j,k)=Xb_t(i+1,k);
        i=i+2;
    end
end

% Plotting Wall Temperatures
figure(1)
for n=1:Nb
    stairs(scale2,Result.B_Wtemp(n,1:end-1),'LineWidth',lw);
    hold on;
end    
%set(gca,'XLim',[0 24],'YLim',[20 40],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[20:5:40],'fontname','Times New Roman','fontsize',fs);
set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
ylabel('Temperature ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
title('Building States (Wall Temperatures)','interpreter','latex','fontsize',fs);

% Plotting Zone Temperatures
figure(7)
subplot(2,1,1)
max_zt=max(Result.B_Ztemp);
min_zt=min(Result.B_Ztemp);
max_zt=max_zt(1,1:end-1);
min_zt=min_zt(1,1:end-1);
X=[scale2(1,1:end),fliplr(scale2(1,1:end))];                %#create continuous x value array for plotting
Y=[min_zt,fliplr(max_zt)];
avg_hv=mean(Result.B_Ztemp,1);
avg_hv=avg_hv(1,1:end-1);
fill(X,Y,[0.81 0.78 1],'EdgeColor',[0.81 0.78 1]);
hold on;
plot(scale2,avg_hv,'color',[0 0.11 1],'linewidth',lw);
% for n=1:Nb
%     stairs(scale2,Result.B_Ztemp(n,1:end-1),'LineWidth',lw);
%     hold on;
% end    
set(gca,'XLim',[0 24],'YLim',[21.5 25],'XGrid','on','YGrid','on','XTick',[0:2:24],'YTick',[21.5:0.5:40],'fontname','Times New Roman','fontsize',fs);
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
X=[scale2(1,1:end),fliplr(scale2(1,1:end))];                %#create continuous x value array for plotting
Y=[min_hv,fliplr(max_hv)];
avg_hv=mean(Result.B_HVAC,1)*(-1/1000);
avg_hv=avg_hv(1,1:end-1);
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

% % Plotting Zone Temperatures
% figure(2)
% for n=1:Nb
%     stairs(scale2,Result.B_Ztemp(n,1:end-1),'LineWidth',lw);
%     hold on;
% end    
% %set(gca,'XLim',[0 24],'YLim',[20 40],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[20:5:40],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Temperature ($^0$C)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Building States (Zone Temperatures)','interpreter','latex','fontsize',fs);
% 
% %% Building HVAC Loads
% figure(3)
% for n=1:Nb
% stairs(scale2,(-1/1000)*Result.B_HVAC(n,1:end-1),'LineWidth',lw);
% hold on;
% end
% %set(gca,'XLim',[0 24],'YLim',[0 400],'XGrid','on','YGrid','on','XTick',[0:4:24],'YTick',[0:100:400],'fontname','Times New Roman','fontsize',fs);
% set(gca,'XGrid','on','YGrid','on','fontname','Times New Roman','fontsize',fs);
% xlabel('Time (hrs)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% ylabel('Power (KW)','interpreter','latex','fontname','Times New Roman','fontsize',fs);
% title('Buildings HVAC Load ($u_b$)','interpreter','latex','fontsize',fs);

end

