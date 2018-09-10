%this function takes a vector 'spike_times' (which lists spike times in
%milliseconds), then converts the list of spike times into a time series of
%ones and zeros, with a one indicating a spike at a certain time. The user
%specifies the sampling rate (in Hz) and the duration of the resulting
%signal (in seconds)

function [time,signal] = convert_spiketimes(spike_times,duration,srate)
    time = 1000*(1/srate:1/srate:duration); %time stamps (in ms, not seconds) corresonding to each entry in signal
    signal = zeros(duration*srate,1); %number of points in final signal will be the number of seconds multiplied by samples per second
    Npoints = length(signal);
    %use the vector 'spike_times' to insert ones in 'signal' where appropriate
    for i_s = 1:length(spike_times)
        %1000*duration is the duration of the signal in milliseconds;
        %multiply the fraction of the way through the signal the spike
        %occurs by the number of points in the discrete signal, and round
        %to obtain the index of the spike
        signal( max(round( spike_times(i_s)/(duration*1000) * Npoints ),1)) = 1;
    end
end