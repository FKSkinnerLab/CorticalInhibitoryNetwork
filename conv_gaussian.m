%this function takes a time series sampled at a rate 'srate' (specified in
%Hz) and convolves it with a Gaussian with a standard deviation
%'gauss_width' (specified in ms)

function newsig = conv_gaussian(signal,srate,gauss_width)
    %require that the Gaussian run from -3 to +3 standard deviations, and
    %sample the Gaussian according to the specified sampling rate. The
    %number of points in the Gaussian is given below
    N_gauss = round(6*(gauss_width/1000)*srate);   % want a standard deviation of 2ms typically
    %want the number of points in the Gaussian to be odd, so that it is
    %centrally peaked, rather than flat at the top
    if(mod(N_gauss,2)==0)
        N_gauss = N_gauss - 1;
    end
    %
    %if(N_gauss<15)
    %    fprintf('Warning: sampling rate may be too low for the specified Gaussian width.')
    %end
    
    x = linspace(-3,3,N_gauss)';
    g = exp(-x.^2); %note that this does not integrate to 1; instead, the peak is always 1
    newsig = conv(signal,g,'same');
end