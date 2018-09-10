clear
clc
close all


%% Parameters
numcells=500;
endtime=2000;
pulsetime=1000;
dt=.01;
steps=endtime/dt+1;

probii=[8 12 16];
std=6;
% probii=12;
% std=[3 6 12];

gsynrange=0.25:.25:5;

%% Input data from csv files
filenames=cell(2,3);
for i=1:2
    for j=1:3
        if i==1
            filenames{i,j}=sprintf('Full_prepulse_state0_probii%1.0d_std%1.0d_REP.csv', probii(j), std);
        elseif i==2
            filenames{i,j}=sprintf('Full_prepulse_state1_probii%1.0d_std%1.0d_REP.csv', probii(j), std);
        end
    end
end

%% Choose gsyn to plot
gsynrange=.25:.25:5;
Irange=100:25:1000;
for gsynchoose=1:10
    
    %% Pull Synchrony Traces
    Sync0=zeros(3, 37);
    Sync1=zeros(3, 37);
    
    for j=1:3
        temp1=csvread(filenames{1,j});
        temp2=csvread(filenames{2,j});
        Sync0(j,:)=temp1(1:37,gsynchoose);
        Sync1(j,:)=temp2(1:37,gsynchoose);
    end
    
    maximum=max(max([Sync0, Sync1]));
    
    %% Calculate Slopes
    slope0=zeros(3,3);
    slope1=zeros(3,3);
    for j=1:3
        check1=Sync0(j,:);
        check2=Sync1(j,:);
        
        I11=find(check1>maximum/2, 1);
        I12=find(check2>maximum/2, 1);
        
%         I21=find(check1(1:I11)<.15, 1, 'last');
%         I22=find(check2(1:I12)<.15, 1, 'last');
        I21=I11-1;
        I22=I12-1;
        
        if (I11>0)
            slope0(j,1)=(check1(I11)-check1(I21))/(Irange(I11)-Irange(I21));
            slope0(j,2)=Irange(ceil((I21+I11)/2));
            slope0(j,3)=check1(ceil((I21+I11)/2));
        else
            slope0(j,1)=0;
            slope0(j,2)=500+(j-1)*100;
            slope0(j,3)=.025;
        end
        
        if (I12>0)
            slope1(j,1)=(check2(I12)-check2(I22))/(Irange(I12)-Irange(I22));
            slope1(j,2)=Irange(ceil((I22+I12)/2));
            slope1(j,3)=check2(ceil((I22+I12)/2));
        else
            slope1(j,1)=0;
            slope1(j,2)=500+(j-1)*100;
            slope1(j,3)=.025;
        end
    end
    
    if abs(slope0(1,3)-slope0(2,3))<(maximum/50)
        slope0(2,3)=slope0(2,3)+(maximum/10);
    end
    if abs(slope0(2,3)-slope0(3,3))<(maximum/50)
        slope0(3,3)=slope0(3,3)+(maximum/10);
    end   
    if abs(slope0(3,3)-slope0(1,3))<(maximum/50)
        slope0(1,3)=slope0(1,3)-(maximum/10);
    end
        
    if abs(slope1(1,3)-slope1(2,3))<(maximum/50)
        slope1(2,3)=slope1(2,3)+(maximum/10);
    end
    if abs(slope1(2,3)-slope1(3,3))<(maximum/50)
        slope1(3,3)=slope1(3,3)+(maximum/10);
    end   
    if abs(slope1(3,3)-slope1(1,3))<(maximum/50)
        slope1(1,3)=slope1(1,3)-(maximum/10);
    end
    
    %% Plot 2D Synchrony Trajectories    
    figure('units','normalized','position',[0 0 1 1])
    
    subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    plot(Irange, Sync0(1,:), 'b-', 'LineWidth', 2);
    hold on
    plot(Irange, Sync0(2,:), 'g-', 'LineWidth', 2);
    hold on
    plot(Irange, Sync0(3,:), 'r-', 'LineWidth', 2);
    hold on
%     str=sprintf('Slope=%1.4f', slope0(1,1));
%     text(slope0(1,2), slope0(1,3), str, 'HorizontalAlignment', 'right', 'Color', 'b', 'FontSize', 20);
%     hold on
%     str=sprintf('Slope=%1.4f', slope0(2,1));
%     text(slope0(2,2), slope0(2,3), str, 'HorizontalAlignment', 'right', 'Color', 'g', 'FontSize', 20);
%     hold on
%     str=sprintf('Slope=%1.4f', slope0(3,1));
%     text(slope0(3,2), slope0(3,3), str, 'HorizontalAlignment', 'right', 'Color', 'r', 'FontSize', 20);
    
    legend('Connection Probability=0.08', 'Connection Probability=0.12', 'Connection Probability=0.16', 'Location', 'SouthEast')
%     legend('Standard Deviation=3 pA', 'Standard Deviation=6 pA', 'Standard Deviation=12 pA', 'Location', 'SouthEast')
    axis([100 1000 0 maximum+.05])
    
    set(gca, 'FontSize', 20);
    % xlabel({'Average External'; 'Applied Current (pA)'}, 'FontSize', 26)
    ylabel('Synchrony Measure', 'FontSize', 26)
    title('Control', 'FontSize', 30);
    
    subaxis(1,2,2, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    plot(Irange, Sync1(1,:), 'b-', 'LineWidth', 2);
    hold on
    plot(Irange, Sync1(2,:), 'g-', 'LineWidth', 2);
    hold on
    plot(Irange, Sync1(3,:), 'r-', 'LineWidth', 2);
    hold on
%     str=sprintf('Slope=%1.4f', slope1(1,1));
%     text(slope1(1,2), slope1(1,3), str, 'HorizontalAlignment', 'right', 'Color', 'b', 'FontSize', 20);
%     hold on
%     str=sprintf('Slope=%1.4f', slope1(2,1));
%     text(slope1(2,2), slope1(2,3), str, 'HorizontalAlignment', 'right', 'Color', 'g', 'FontSize', 20);
%     hold on
%     str=sprintf('Slope=%1.4f', slope1(3,1));
%     text(slope1(3,2), slope1(3,3), str, 'HorizontalAlignment', 'right', 'Color', 'r', 'FontSize', 20);
    legend('Connection Probability=0.08', 'Connection Probability=0.12', 'Connection Probability=0.16', 'Location', 'SouthEast')
%     legend('Standard Deviation=3 pA', 'Standard Deviation=6 pA', 'Standard Deviation=12 pA', 'Location', 'SouthEast')
    axis([100 1000 0 maximum+.05])
    
    set(gca, 'FontSize', 20);
    % xlabel({'Average External'; 'Applied Current (pA)'}, 'FontSize', 26)
    ylabel('Synchrony Measure', 'FontSize', 26)
    title('4-AP', 'FontSize', 30);
    
    
    supAxis=[.0750 .15 .85 .8];
    str1= sprintf('Average External Applied Current (pA)');
    str3= sprintf('gsyn=%1.2f', gsynrange(gsynchoose));
    [ax,h]=suplabel(str1, 'x', supAxis);
    set(h, 'FontSize', 26);
    [ax3,h3]=suplabel(str3, 't', supAxis);
    set(h3, 'FontSize', 20);
    
    
    
    str1=sprintf('2d_std%1.0f_gsyn%1.0fREP_final1_2.png', std, gsynrange(gsynchoose)*100);
    str2=sprintf('2d_std%1.0f_gsyn%1.0fREP_final1_2.fig', std, gsynrange(gsynchoose)*100);
%     str1=sprintf('2d_probii%1.0f_gsyn%1.0fREP_final1_2.png', probii, gsynrange(gsynchoose)*100);
%     str2=sprintf('2d_probii%1.0f_gsyn%1.0fREP_final1_2.fig', probii, gsynrange(gsynchoose)*100);
    saveas(gcf, str2)
    set(gcf,'PaperPositionMode','auto')
    print(str1, '-dpng', '-r0');
    
end
