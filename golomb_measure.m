function S = golomb_measure(NUM, raster, gauss_width)

spike_times = cell(NUM,1);

for k = 1:length(raster(:,1))
    spike_times{raster(k,2)} = [spike_times{raster(k,2)} raster(k,1)];
end

srate=1000; %sampling rate (in Hz) at which to reconstruct the voltage signal from spike_times
duration=.5; %duration of recording (in seconds)


time = 1000/srate:1000/srate:duration*1000; %in ms
timeseries = zeros(srate*duration,NUM);

%first, take spike_times for each electrode and convert them to a time
%series of 1's and 0's, sampled at 1000 Hz
for i_elec = 1:NUM
    [time, timeseries(:,i_elec)] = convert_spiketimes(spike_times{i_elec},duration,srate);
end

conv_sig = 0*timeseries;
if gauss_width <= 0
    gauss_width = 2;
end
%next, convolve each timeseries of 1's and 0's with a gaussian of width
%'gauss_width' (in milliseconds)
for i_n = 1:NUM
    conv_sig(:,i_n) = conv_gaussian(timeseries(:,i_n),srate,gauss_width);
end

%% Here one can print out the gaussian on the raster plot

% for j = 1:NUM
%   plot(time,conv_sig(:,j) + (j))
%   hold on
% end

%%

num_traces = size(conv_sig,2);
% C = zeros(num_traces,num_traces);
% 
% max_lag=300;
% 
% for ii = 1:num_traces
%     for jj = ii+1:num_traces
% 
%         tic
%         [temp_xcorr2,delay_vals]=xcorrnorm(conv_sig(:,ii),conv_sig(:,jj),max_lag);
%         toc
%         ii
%         jj
%         C(ii,jj) = max(temp_xcorr2);
%     end
% end
% 
% C_mean = 0;
% for ii = 1:num_traces
%     for jj = ii+1:num_traces
%         C_mean = C_mean + C(ii,jj);
%     end
% end
% 
% C_mean = 2*C_mean/(num_traces*(num_traces-1))

%tic
[G,G_rescaled] = golomb_synch(conv_sig);
%toc

S = G_rescaled;
