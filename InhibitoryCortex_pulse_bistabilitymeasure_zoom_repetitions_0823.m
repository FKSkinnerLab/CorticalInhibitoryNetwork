%% Put Compare Heatmaps Together
for probii=8:4:16
    for std=[3 6 12]
        str1=sprintf('Zoom_compare_state0_probii%1.0f_std%1.0f_REP.csv', probii, std);
        str2=sprintf('Zoom_compare_state1_probii%1.0f_std%1.0f_REP.csv', probii, std);
        
        heatmap1=csvread(str1);
        heatmap2=csvread(str2);
        
        heatmap1_adj=heatmap1(heatmap1>.3);
        heatmap2_adj=heatmap2(heatmap2>.3);
        total1=sum(heatmap1_adj);
        total2=sum(heatmap2_adj);
        
        figure('units','normalized','position',[0 0 1 1])
        colormap jet
                
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
        strtit=sprintf('Sync: Post-Pre, State=0, Total=%1.2f', total1);
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
        strtit=sprintf('Sync: Post-Pre, State=0, Total=%1.2f', total2);
        title(strtit, 'FontSize', 30);
        
        supAxis=[.0750 .10 .85 .85];
        str1= sprintf('Inhibitory Synaptic Weight (nS)');
        str3= sprintf('Connectivity Density: %1.2f; STD: %1.2f; Post-Pre', probii/100, std);
        [ax,h]=suplabel(str1, 'x', supAxis);
        set(h, 'FontSize', 26);
        [ax3,h3]=suplabel(str3, 't', supAxis);
        set(h3, 'FontSize', 20);
        
        
        
        str1=sprintf('Zoom_compare_bistabilitymeasure_probii%1.0f_std%1.0f_REP.png', probii, std);
        %     saveas(gcf, str1)
        set(gcf,'PaperPositionMode','auto')
        print(str1, '-dpng', '-r0');
        
        
    end
end
