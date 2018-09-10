clear
clc
close all


%% Parameters
numcells=500;
endtime=2000;
pulsetime=1000;
dt=.01;
steps=endtime/dt+1;

state=0;
probii=8;
std=3;

for bseed=2201:3:2254
    %% Input data from csv files
    current=cd;
    cd('/Users/scottrich/OneDrive - UHN/1) Compute Canada Files');
    %             cd('E:\OneDrive - UHN\1) Compute Canada Files');
    
    str1=sprintf('InhibitoryNetwork_%d_TrackVariables.csv', bseed);
    str2=sprintf('InhibitoryNetwork_%d_SpikeTimes.csv', bseed);
    str3=sprintf('InhibitoryNetwork_%d_InputCurrents.csv', bseed);
    str4=sprintf('InhibitoryNetwork_%d_ConnectivityMatricies.csv', bseed);
    str5=sprintf('InhibitoryNetwork_%d_Parameters.csv', bseed);
    
    % trackvariables=csvread(str1);
    %     spikes=csvread(str2);
    %     currents=csvread(str3);
    % connectivity=csvread(str4);
    variables=csvread(str5);
    
    cd(current);
    
    %% Get parameter values
    state=variables(1,5);
    std=variables(1,4);
    probii=variables(1,1)*100;
    
    %% Generate File Names
    branges=cell(1,5);
    branges{1}=sprintf('num%1.0dto%1.0d', bseed, bseed+2);
    brepstart=bseed+54;
    for i=2:5
        branges{i}=sprintf('num%1.0dto%1.0d', brepstart+(i-2)*54, brepstart+2+(i-2)*54);
    end
    
    prepulsenames=cell(1,5);
    postpulsenames=cell(1,5);
    
    for i=1:5
        prepulsenames{i}=sprintf('Synchrony_prepulse_zoom_state%1.0f_probii%1.0d_std%1.0d_%s.csv', state, probii, std, branges{i});
        postpulsenames{i}=sprintf('Synchrony_postpulse_zoom_state%1.0f_probii%1.0d_std%1.0d_%s.csv', state, probii, std, branges{i});
    end
    
    numgsyn=12;
    numI=51;
    loopnum=numgsyn*numI;
    
    %% Average Reps
    Synchrony_full_pre=zeros(numI+1, numgsyn+1);
    Synchrony_full_post=zeros(numI+1, numgsyn+1);
    popfreq_full=zeros(numI+1, numgsyn+1);
    
    for i=1:5
        temp1=csvread(prepulsenames{i});
        temp2=csvread(postpulsenames{i});
        Synchrony_full_pre=Synchrony_full_pre+temp1;
        Synchrony_full_post=Synchrony_full_post+temp2;
    end
    
    Synchrony_full_pre=Synchrony_full_pre./5;
    Synchrony_full_post=Synchrony_full_post./5;
    
    str1=sprintf('Zoom_prepulse_state%1.0f_probii%1.0f_std%1.0f_REP.csv', state, probii, std);
    csvwrite(str1, Synchrony_full_pre);
    
    str1=sprintf('Zoom_postpulse_state%1.0f_probii%1.0f_std%1.0f_REP.csv', state, probii, std);
    csvwrite(str1, Synchrony_full_post);
    
    
    
    %% Plot Rep Parameter Regime POST PULSE
    figure('units','normalized','position',[0 0 1 1])
    colormap jet
    
    subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    pcolor(Synchrony_full_post)
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
    
    % subaxis(1,2,2, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingRight', 0.01, 'PaddingLeft', 0.05);
    % pcolor(popfreq_full)
    % caxis([0 200])
    % colorbar
    %
    % set(gca,'TickDir','out')
    % set(gca,'box','off')
    % set(gca, 'XTick', 1.5:2:20.5);
    % set(gca, 'XTickLabel', xlabels);
    % set(gca, 'YTick', []);
    % set(gca, 'YTickLabel', ylabels);
    % xtickangle(45)
    % ytickangle(45)
    % set(gca, 'FontSize', 20);
    % % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
    % % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
    % % ylabel('External Applied Current (pA)', 'FontSize', 26)
    % title('Mean Firing Frequency (Hz)', 'FontSize', 30);
    
    supAxis=[.0750 .10 .85 .85];
    str1= sprintf('Inhibitory Synaptic Weight (nS)');
    str3= sprintf('Connectivity Density: %1.2f; STD: %1.2f; State: %1.0f; Post Pulse', probii/100, std, state);
    [ax,h]=suplabel(str1, 'x', supAxis);
    set(h, 'FontSize', 26);
    [ax3,h3]=suplabel(str3, 't', supAxis);
    set(h3, 'FontSize', 20);
    
    
    
    str1=sprintf('Zoom_postpulse_state%1.0f_probii%1.0f_std%1.0f_REP.png', state, probii, std);
    %     saveas(gcf, str1)
    set(gcf,'PaperPositionMode','auto')
    print(str1, '-dpng', '-r0');
    
    %% Plot Rep Parameter Regime PRE PULSE
    figure('units','normalized','position',[0 0 1 1])
    colormap jet
    
    subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    pcolor(Synchrony_full_pre)
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
    
    % subaxis(1,2,2, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingRight', 0.01, 'PaddingLeft', 0.05);
    % pcolor(popfreq_full)
    % caxis([0 200])
    % colorbar
    %
    % set(gca,'TickDir','out')
    % set(gca,'box','off')
    % set(gca, 'XTick', 1.5:2:20.5);
    % set(gca, 'XTickLabel', xlabels);
    % set(gca, 'YTick', []);
    % set(gca, 'YTickLabel', ylabels);
    % xtickangle(45)
    % ytickangle(45)
    % set(gca, 'FontSize', 20);
    % % ylabel({'Inter-connectivity Density'; 'Compared to E-E Density'}, 'FontSize', 26)
    % % xlabel('Inhibitory Synaptic Weight (nS)', 'FontSize', 26)
    % % ylabel('External Applied Current (pA)', 'FontSize', 26)
    % title('Mean Firing Frequency (Hz)', 'FontSize', 30);
    
    supAxis=[.0750 .10 .85 .85];
    str1= sprintf('Inhibitory Synaptic Weight (nS)');
    str3= sprintf('Connectivity Density: %1.2f; STD: %1.2f; State: %1.0f; Pre Pulse', probii/100, std, state);
    [ax,h]=suplabel(str1, 'x', supAxis);
    set(h, 'FontSize', 26);
    [ax3,h3]=suplabel(str3, 't', supAxis);
    set(h3, 'FontSize', 20);
    
    
    
    str1=sprintf('Zoom_prepulse_state%1.0f_probii%1.0f_std%1.0f_REP.png', state, probii, std);
    %     saveas(gcf, str1)
    set(gcf,'PaperPositionMode','auto')
    print(str1, '-dpng', '-r0');
    
    %% Plot Comparison Heatmap
    figure('units','normalized','position',[0 0 1 1])
    colormap jet
    
    compare=Synchrony_full_post-Synchrony_full_pre;
    
    subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
    pcolor(compare)
    caxis([-.1 .9])
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
    str3= sprintf('Connectivity Density: %1.2f; STD: %1.2f; State: %1.0f; Post-Pre', probii/100, std, state);
    [ax,h]=suplabel(str1, 'x', supAxis);
    set(h, 'FontSize', 26);
    [ax3,h3]=suplabel(str3, 't', supAxis);
    set(h3, 'FontSize', 20);
    
    
    
    str1=sprintf('Zoom_compare_state%1.0f_probii%1.0f_std%1.0f_REP.png', state, probii, std);
    %     saveas(gcf, str1)
    set(gcf,'PaperPositionMode','auto')
    print(str1, '-dpng', '-r0');
    
    str2=sprintf('Zoom_compare_state%1.0f_probii%1.0f_std%1.0f_REP.csv', state, probii, std);
    csvwrite(str2,compare);
    
    close all
end

%% Put Compare Heatmaps Together
for probii=8:4:16
    for std=[3 6 12]
        str1=sprintf('Zoom_compare_state0_probii%1.0f_std%1.0f_REP.csv', probii, std);
        str2=sprintf('Zoom_compare_state1_probii%1.0f_std%1.0f_REP.csv', probii, std);
        
        heatmap1=csvread(str1);
        heatmap2=csvread(str2);
        
        figure('units','normalized','position',[0 0 1 1])
        colormap jet
        
        compare=Synchrony_full_post-Synchrony_full_pre;
        
        subaxis(1,2,1, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingLeft', 0.07, 'PaddingRight', 0.01);
        pcolor(heatmap1)
        caxis([-.1 .9])
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
        total=sum(sum(heatmap1));
        strtit=sprintf('Sync: Post-Pre, State=0, Total=%1.2f', total);
        title(strtit, 'FontSize', 30);
        
        subaxis(1,2,2, 'Spacing', 0.01, 'Padding', 0.05, 'Margin', 0.05, 'PaddingBottom', 0.12, 'PaddingTop', 0.075, 'PaddingRight', 0.01, 'PaddingLeft', 0.05);
        pcolor(heatmap2)
        caxis([-.1 .9])
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
        total=sum(sum(heatmap2));
        strtit=sprintf('Sync: Post-Pre, State=0, Total=%1.2f', total);
        title(strtit, 'FontSize', 30);
        
        supAxis=[.0750 .10 .85 .85];
        str1= sprintf('Inhibitory Synaptic Weight (nS)');
        str3= sprintf('Connectivity Density: %1.2f; STD: %1.2f; Post-Pre', probii/100, std);
        [ax,h]=suplabel(str1, 'x', supAxis);
        set(h, 'FontSize', 26);
        [ax3,h3]=suplabel(str3, 't', supAxis);
        set(h3, 'FontSize', 20);
        
        
        
        str1=sprintf('Zoom_compare_sidebyside_probii%1.0f_std%1.0f_REP.png', probii, std);
        %     saveas(gcf, str1)
        set(gcf,'PaperPositionMode','auto')
        print(str1, '-dpng', '-r0');
        
        
    end
end
