clear
clc
close all

numsims=27;
numfull=3;
branges=cell(1, numsims/numfull);
bstart=2444;
bstartcsv=bstart;
for i=1:numsims/numfull
    branges{i}=bstart+(i-1)*numfull:(bstart+numfull-1)+(i-1)*numfull;
end
close all

for i=1:numsims/numfull
    brange=branges{i};
    
    %% File names
    load('progress_postpulse_2444to2470.mat');
    load('progress_prepulse_2444to2470.mat');
    
    %% Parameters
    numcells=500;
    endtime=2000;
    pulsetime=1000;
    dt=.01;
    steps=endtime/dt+1;
    
    % brange=106:105;
    
    numgsyn=12;
    numI=51;
    loopnum=numgsyn*numI;
    
    %% Construct Full Parameter Regime From Smaller Runs
    Synchrony_full=zeros(numI+1, numgsyn+1);
    popfreq_full=zeros(numI+1, numgsyn+1);
    
    count=1;
    for b=brange
        temp=csvread(csvname{1+b-bstartcsv,1});
        for k=1:(length(temp)/numI)
            Synchrony_full(1:numI, count)=temp((1+(k-1)*numI):(k*numI));
            count=count+1;
        end
    end
    
    count=1;
    for b=brange
        temp2=csvread(csvname{1+b-bstartcsv,2});
        for k=1:(length(temp2)/numI)
            popfreq_full(1:numI, count)=temp2((1+(k-1)*numI):(k*numI));
            count=count+1;
        end
    end
    
    %% Input data from csv files
    b=brange(1);
    
    current=cd;
    cd('/Users/scottrich/OneDrive - UHN/1) Compute Canada Files');
%             cd('E:\OneDrive - UHN\1) Compute Canada Files');
    
    str1=sprintf('InhibitoryNetwork_%d_TrackVariables.csv', b);
    str2=sprintf('InhibitoryNetwork_%d_SpikeTimes.csv', b);
    str3=sprintf('InhibitoryNetwork_%d_InputCurrents.csv', b);
    str4=sprintf('InhibitoryNetwork_%d_ConnectivityMatricies.csv', b);
    str5=sprintf('InhibitoryNetwork_%d_Parameters.csv', b);
    
    % trackvariables=csvread(str1);
    % spikes=csvread(str2);
    % currents=csvread(str3);
    % connectivity=csvread(str4);
    variables=csvread(str5);
    
    cd(current);
    
    
    csvname4=sprintf('Synchrony_postpulse_zoom_state%d_probii%1.0f_std%1.0f_num%dto%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    csvname3=sprintf('PopulationFreq_postpulse_zoom_state%d_probii%1.0f_std%1.0f_num%dto%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    csvwrite(csvname4,Synchrony_full);
    csvwrite(csvname3,popfreq_full);
    
    %% Plot Full Parameter Regime
    figure('units','normalized','position',[0 0 1 1])
    colormap jet
    
    subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    pcolor(Synchrony_full)
    caxis([0 1])
    colorbar
    
    xlabels=0.25:.5:3;
    ylabels=150:20:400;
    
    set(gca,'TickDir','out')
    set(gca,'box','off')
    set(gca, 'XTick', 1.5:2:12.5);
    set(gca, 'XTickLabel', xlabels);
    set(gca, 'YTick', 1.5:4:51.5);
    set(gca, 'YTickLabel', ylabels);
    xtickangle(45)
    ytickangle(45)
    set(gca, 'FontSize', 20);
    % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
    % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
    ylabel('External Applied Current (pA)', 'FontSize', 26)
    title('Synchrony Measure', 'FontSize', 30);
    
    subaxis(1,2,2, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingRight', 0.01, 'PaddingLeft', 0.05);
    pcolor(popfreq_full)
    caxis([0 200])
    colorbar
    
    set(gca,'TickDir','out')
    set(gca,'box','off')
    set(gca, 'XTick', 1.5:2:20.5);
    set(gca, 'XTickLabel', xlabels);
    set(gca, 'YTick', []);
    set(gca, 'YTickLabel', ylabels);
    xtickangle(45)
    ytickangle(45)
    set(gca, 'FontSize', 20);
    % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
    % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
    % ylabel('External Applied Current (pA)', 'FontSize', 26)
    title('Mean Firing Frequency (Hz)', 'FontSize', 30);
    
    supAxis=[.0750 .10 .85 .85];
    str1= sprintf('Inhibitory Synaptic Weight (nS)');
    str3= sprintf('Connectivity Density: %1.2f; State: %1.0f; Post-Pulse', variables(1,1), variables(1,5));
    [ax,h]=suplabel(str1, 'x', supAxis);
    set(h, 'FontSize', 26);
    [ax3,h3]=suplabel(str3, 't', supAxis);
    set(h3, 'FontSize', 20);
    
    
    
    str1=sprintf('Zoom_postpulse_state%d_probii%1.0f_std%1.0f_num%dto%d.png', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    %     saveas(gcf, str1)
    set(gcf,'PaperPositionMode','auto')
    print(str1, '-dpng', '-r0');
    
    %% Construct Full Parameter Regime From Smaller Runs PRE PULSE
    Synchrony_full=zeros(numI+1, numgsyn+1);
    popfreq_full=zeros(numI+1, numgsyn+1);
    
    count=1;
    for b=brange
        temp=csvread(csvname2{1+b-bstartcsv,1});
        for k=1:(length(temp)/numI)
            Synchrony_full(1:numI, count)=temp((1+(k-1)*numI):(k*numI));
            count=count+1;
        end
    end
    
    count=1;
    for b=brange
        temp2=csvread(csvname2{1+b-bstartcsv,2});
        for k=1:(length(temp2)/numI)
            popfreq_full(1:numI, count)=temp2((1+(k-1)*numI):(k*numI));
            count=count+1;
        end
    end
    
    %% Input data from csv files
    b=brange(1);
    
    current=cd;
    cd('/Users/scottrich/OneDrive - UHN/1) Compute Canada Files');
%             cd('E:\OneDrive - UHN\1) Compute Canada Files');
    
    str1=sprintf('InhibitoryNetwork_%d_TrackVariables.csv', b);
    str2=sprintf('InhibitoryNetwork_%d_SpikeTimes.csv', b);
    str3=sprintf('InhibitoryNetwork_%d_InputCurrents.csv', b);
    str4=sprintf('InhibitoryNetwork_%d_ConnectivityMatricies.csv', b);
    str5=sprintf('InhibitoryNetwork_%d_Parameters.csv', b);
    
    % trackvariables=csvread(str1);
    % spikes=csvread(str2);
    % currents=csvread(str3);
    % connectivity=csvread(str4);
    variables=csvread(str5);
    
    cd(current);
    
    
    csvname4=sprintf('Synchrony_prepulse_zoom_state%d_probii%1.0f_std%1.0f_num%dto%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    csvname3=sprintf('PopulationFreq_prepulse_zoom_state%d_probii%1.0f_std%1.0f_num%dto%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    csvwrite(csvname4,Synchrony_full);
    csvwrite(csvname3,popfreq_full);
    
    %% Plot Full Parameter Regime
    figure('units','normalized','position',[0 0 1 1])
    colormap jet
    
    subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    pcolor(Synchrony_full)
    caxis([0 1])
    colorbar
    
    xlabels=0.25:.5:3;
    ylabels=150:20:400;
    
    set(gca,'TickDir','out')
    set(gca,'box','off')
    set(gca, 'XTick', 1.5:2:12.5);
    set(gca, 'XTickLabel', xlabels);
    set(gca, 'YTick', 1.5:4:51.5);
    set(gca, 'YTickLabel', ylabels);
    xtickangle(45)
    ytickangle(45)
    set(gca, 'FontSize', 20);
    % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
    % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
    ylabel('External Applied Current (pA)', 'FontSize', 26)
    title('Synchrony Measure', 'FontSize', 30);
    
    subaxis(1,2,2, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingRight', 0.01, 'PaddingLeft', 0.05);
    pcolor(popfreq_full)
    caxis([0 200])
    colorbar
    
    set(gca,'TickDir','out')
    set(gca,'box','off')
    set(gca, 'XTick', 1.5:2:20.5);
    set(gca, 'XTickLabel', xlabels);
    set(gca, 'YTick', []);
    set(gca, 'YTickLabel', ylabels);
    xtickangle(45)
    ytickangle(45)
    set(gca, 'FontSize', 20);
    % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
    % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
    % ylabel('External Applied Current (pA)', 'FontSize', 26)
    title('Mean Firing Frequency (Hz)', 'FontSize', 30);
    
    supAxis=[.0750 .10 .85 .85];
    str1= sprintf('Inhibitory Synaptic Weight (nS)');
    str3= sprintf('Connectivity Density: %1.2f; State: %1.0f; Pre-Pulse', variables(1,1), variables(1,5));
    [ax,h]=suplabel(str1, 'x', supAxis);
    set(h, 'FontSize', 26);
    [ax3,h3]=suplabel(str3, 't', supAxis);
    set(h3, 'FontSize', 20);
    
    
    
    str1=sprintf('Zoom_prepulse_state%d_probii%1.0f_std%1.0f_num%dto%d.png', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    %     saveas(gcf, str1)
    set(gcf,'PaperPositionMode','auto')
    print(str1, '-dpng', '-r0');
    
    %% Plot Comparison Heatmap
    figure('units','normalized','position',[0 0 1 1])
    colormap jet
    
    csvname1=sprintf('Synchrony_postpulse_zoom_state%d_probii%1.0f_std%1.0f_num%dto%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    csvname2=sprintf('Synchrony_prepulse_zoom_state%d_probii%1.0f_std%1.0f_num%dto%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    compare=csvread(csvname1)-csvread(csvname2);
    
    subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    pcolor(compare)
    caxis([-.5 1])
    colorbar
    
    xlabels=0.25:.5:3;
    ylabels=150:20:400;
    
    set(gca,'TickDir','out')
    set(gca,'box','off')
    set(gca, 'XTick', 1.5:2:12.5);
    set(gca, 'XTickLabel', xlabels);
    set(gca, 'YTick', 1.5:4:51.5);
    set(gca, 'YTickLabel', ylabels);
    xtickangle(45)
    ytickangle(45)
    set(gca, 'FontSize', 20);
    % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
    % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
    ylabel('External Applied Current (pA)', 'FontSize', 26)
    title('Synchrony Measure: Post-Pre', 'FontSize', 30);
    
%     subaxis(1,2,2, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingRight', 0.01, 'PaddingLeft', 0.05);
%     pcolor(popfreq_full)
%     caxis([0 200])
%     colorbar
%     
%     set(gca,'TickDir','out')
%     set(gca,'box','off')
%     set(gca, 'XTick', 1.5:2:20.5);
%     set(gca, 'XTickLabel', xlabels);
%     set(gca, 'YTick', []);
%     set(gca, 'YTickLabel', ylabels);
%     xtickangle(45)
%     ytickangle(45)
%     set(gca, 'FontSize', 20);
%     % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
%     % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
%     % ylabel('External Applied Current (pA)', 'FontSize', 26)
%     title('Mean Firing Frequency (Hz)', 'FontSize', 30);
    
    supAxis=[.0750 .10 .85 .85];
    str1= sprintf('Inhibitory Synaptic Weight (nS)');
    str3= sprintf('Connectivity Density: %1.2f; State: %1.0f; Pre-Pulse', variables(1,1), variables(1,5));
    [ax,h]=suplabel(str1, 'x', supAxis);
    set(h, 'FontSize', 26);
    [ax3,h3]=suplabel(str3, 't', supAxis);
    set(h3, 'FontSize', 20);
    
    
    
    str1=sprintf('Zoom_compare_state%d_probii%1.0f_std%1.0f_num%dto%d.png', variables(1,5), variables(1,1)*100, variables(1,4), brange(1),brange(end));
    %     saveas(gcf, str1)
    set(gcf,'PaperPositionMode','auto')
    print(str1, '-dpng', '-r0');
    
end