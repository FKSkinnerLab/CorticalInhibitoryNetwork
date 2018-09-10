clear
clc
clf
close all

for b=[2085]
    
    current=cd;
    cd('/Users/scottrich/OneDrive - UHN/1) Compute Canada Files');
%         cd('E:\OneDrive - UHN\1) Compute Canada Files');
    
    str1=sprintf('InhibitoryNetwork_%d_TrackVariables.csv', b);
    str2=sprintf('InhibitoryNetwork_%d_SpikeTimes.csv', b);
    str3=sprintf('InhibitoryNetwork_%d_InputCurrents.csv', b);
    str4=sprintf('InhibitoryNetwork_%d_ConnectivityMatricies.csv', b);
    str5=sprintf('InhibitoryNetwork_%d_Parameters.csv', b);
    
    % trackvariables=csvread(str1);
    spikes=csvread(str2);
    currents=csvread(str3);
    % connectivity=csvread(str4);
    variables=csvread(str5);
    
    cd(current);
    
    numcells=500;
    endtime=2000;
    pulsetime=1000;
    dt=.01;
    steps=endtime/dt+1;
    
    repnum=1;
    loopnum=1;
    
    r=1;
    
    %% Sort Cells by Input Current
    for p=(37*0+1):(37*1)
        
        [Y,I]=sort(currents((1+(p-1)*numcells):(p*numcells)), 'descend');
        cutspikes=spikes((1+(p-1)*numcells):(p*numcells), :);
        sortspikes=cutspikes(I,:);
        
%         a= endtime-50;
%         c= endtime;
        a=pulsetime-50;
        c=pulsetime+200;
        
        figure('units','normalized','position',[0 0 1 1])
        for i=1:numcells
            use1=sortspikes(i,:)<(c);
            use2=sortspikes(i,:)~=0;
            use3=sortspikes(i,:)>(a);
            use=use1.*use2.*use3;
            if all(use==0)~=1
                plot (sortspikes(i,use~=0), i, 'r.', 'MarkerSize', 10);
            end
            hold on
        end
        
        set(gca, 'FontSize', 18);
        xlabel('Time, ms', 'FontSize', 24);
        ylabel('Neuron Index (Current Sorted)', 'FontSize', 24);
        
        str1=sprintf('SortedRaster_state%d_probii%1.0f_std%1.0f_gsyn%1.0f_Iapp%1.0f.png', variables(1,5), variables(1,1)*100, variables(1,4), variables(p,2)*100, variables(p,3));
        %     saveas(gcf, str1)
        set(gcf,'PaperPositionMode','auto')
        print(str1, '-dpng', '-r0');
        
        close all
    end
end