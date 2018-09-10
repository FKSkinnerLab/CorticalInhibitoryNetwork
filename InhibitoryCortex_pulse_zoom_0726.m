function InhibitoryCortex_pulse_zoom_0726(brange)

%% Parameters
numcells=500;
endtime=2000;
pulsetime=1000;
dt=.01;
steps=endtime/dt+1;

numI=50;

csvname=cell(length(brange),2);
csvname2=cell(length(brange),2);

for b=brange
    %% Input data from csv files
    current=cd;
    cd('/Users/scottrich/OneDrive - UHN/1) Compute Canada Files');
%             cd('E:\OneDrive - UHN\1) Compute Canada Files');
    
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
    
    numgsyn=length(variables(:,1))/numI;
    
    %% Initialize Variables
    loopnum=numgsyn*numI;
    synchrony=NaN(1, loopnum);
    popfreq=NaN(1,loopnum);
    
    %% Post Pulse
    if length(spikes)/numcells==loopnum
        endnum=loopnum;
    else
        endnum=floor(length(spikes)/numcells);
    end
    for i=1:endnum
        myspikes=spikes(1+(i-1)*numcells:(i)*numcells, :);
        use=myspikes>(endtime-500);
        usespikes=zeros(numcells, ceil(length(spikes(1,:))/3));
        for j=1:numcells
            temp=myspikes(j,use(j,:));
            usespikes(j,1:length(temp))=temp;
        end
        
        %% Calculate MFF (as approximation for the network frequency)
        freq=zeros(1,numcells);
        for j=1:numcells
            freq(j)=sum(usespikes(j,:)>0)/.5;
        end
        popfreq(i)=sum(freq)/numcells;
        
        %% Calculate Synchrony Measure
        myspikes=spikes((1+(i-1)*numcells):(i*numcells),:);
        indices=find(myspikes<(endtime-500));
        myspikes(indices)=0;
        count=1;
        totalspikes=sum(sum(myspikes~=0));
        myspikes_formatted=zeros(totalspikes,2);
        for k=1:numcells
            for j=1:length(myspikes(1,:))
                if myspikes(k,j)~=0
                    myspikes_formatted(count,2)=k;
                    myspikes_formatted(count,1)=myspikes(k,j)-(endtime-500);
                    count=count+1;
                end
            end
        end
        synchrony(i)=golomb_measure(numcells,myspikes_formatted,2);
        if isfinite(synchrony(i))==0
            synchrony(i)=0;
        end
        str=sprintf('i = %1.0d', i);
        disp(str)
        progressname=sprintf('progress%d.mat', b);
        save(progressname, 'synchrony', 'b', 'i');
    end
    %% Save Output
    csvname{b-brange(1)+1,1}=sprintf('Synchrony_postpulse_state%d_probii%1.0f_std%1.0f_gsynmin%1.0f_gsynmax%1.0f_num%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), variables(1,2)*10, variables(end,2)*10,b);
    csvname{b-brange(1)+1,2}=sprintf('PopulationFreq_postpulse_state%d_probii%1.0f_std%1.0f_gsynmin%1.0f_gsynmax%1.0f_num%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), variables(1,2)*10, variables(end,2)*10,b);
    csvwrite(csvname{b-brange(1)+1,1},synchrony);
    csvwrite(csvname{b-brange(1)+1,2},popfreq);
    
    str=sprintf('b = %1.0d', b);
    disp(str)
    delete(progressname);
    
    %% Pre Pulse
    if length(spikes)/numcells==loopnum
        endnum=loopnum;
    else
        endnum=floor(length(spikes)/numcells);
    end
    for i=1:endnum
        myspikes=spikes(1+(i-1)*numcells:(i)*numcells, :);
        use=myspikes>(pulsetime-500);
        use2=myspikes<pulsetime;
        myuse=logical(use.*use2);
        usespikes=zeros(numcells, ceil(length(spikes(1,:))/3));
        for j=1:numcells
            temp=myspikes(j,myuse(j,:));
            usespikes(j,1:length(temp))=temp;
        end
        
        %% Calculate MFF (as approximation for the network frequency)
        freq=zeros(1,numcells);
        for j=1:numcells
            freq(j)=sum(usespikes(j,:)>0)/.5;
        end
        popfreq(i)=sum(freq)/numcells;
        
        %% Calculate Synchrony Measure
        myspikes=spikes((1+(i-1)*numcells):(i*numcells),:);
        indices1=find(myspikes<(pulsetime-500));
        indices2=find(myspikes>pulsetime);
        myspikes(indices1)=0;
        myspikes(indices2)=0;
        count=1;
        totalspikes=sum(sum(myspikes~=0));
        myspikes_formatted=zeros(totalspikes,2);
        for k=1:numcells
            for j=1:length(myspikes(1,:))
                if myspikes(k,j)~=0
                    myspikes_formatted(count,2)=k;
                    myspikes_formatted(count,1)=myspikes(k,j)-(pulsetime-500);
                    count=count+1;
                end
            end
        end
        synchrony(i)=golomb_measure(numcells,myspikes_formatted,2);
        if isfinite(synchrony(i))==0
            synchrony(i)=0;
        end
        str=sprintf('i = %1.0d', i);
        disp(str)
        progressname=sprintf('progress%d.mat', b);
        save(progressname, 'synchrony', 'b', 'i');
    end
    %% Save Output
    csvname2{b-brange(1)+1,1}=sprintf('Synchrony_prepulse_state%d_probii%1.0f_std%1.0f_gsynmin%1.0f_gsynmax%1.0f_num%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), variables(1,2)*10, variables(end,2)*10,b);
    csvname2{b-brange(1)+1,2}=sprintf('PopulationFreq_prepulse_state%d_probii%1.0f_std%1.0f_gsynmin%1.0f_gsynmax%1.0f_num%d.csv', variables(1,5), variables(1,1)*100, variables(1,4), variables(1,2)*10, variables(end,2)*10,b);
    csvwrite(csvname2{b-brange(1)+1,1},synchrony);
    csvwrite(csvname2{b-brange(1)+1,2},popfreq);
    
    str=sprintf('b = %1.0d', b);
    disp(str)
    delete(progressname);
end

filename=sprintf('progress_postpulse_%dto%d.mat', brange(1), brange(end));
save(filename, 'csvname');

filename2=sprintf('progress_prepulse_%dto%d.mat', brange(1), brange(end));
save(filename2, 'csvname2');