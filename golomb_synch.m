%this function calculates the "Golomb synchrony" of multiple signals
%(Golomb and Rinzel, 1993 & 1994). sig_mat is a matrix of signals in which
%each COLUMN is a different signal.

function [G,G_rescaled] = golomb_synch(sig_mat)
    N = size(sig_mat,2); %number of neurons (or signals) is equal to number of columns in sig_mat
    mean_sig = mean(sig_mat,2); %calculate the mean signal
    variances = var(sig_mat); %this is a row vector, where each entry is the variance of one of the columns in sig_mat
    G = sqrt(var(mean_sig)/mean(variances)); %calculate the actual synchrony measure
    
    %the Golomb measure only goes to zero for asynchronous signals in the limit as the number of
    %neurons goes to infinity; with N neurons, the lowest possible value is
    %1/sqrt(N), so we rescale G according to N so that it goes from 0 to 1
    G_rescaled = (G-1/sqrt(N)) / (1-1/sqrt(N));
    %with this transformation, G_rescaled can go slightly negative due to
    %randomness in the signals, so we should just set G_rescaled to 0 if it
    %goes negative
    if(G_rescaled < 0)
        G_rescaled = 0;
    end
end