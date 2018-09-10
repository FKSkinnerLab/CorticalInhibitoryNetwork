# CorticalInhibitoryNetwork
Code for Scott Rich's submission to eNeuro on bistability in cortical inhibitory networks 

InhibitoryNetwork_cortex_0712.c:
code used to run the inhibitory networks studied in this work.

InhibitoryNetwork_cortex_submit_0812.sh, InhibitoryNetwork_cortex_submit_zoom_0725.sh, InhibitoryNetwork_cortex.sh:
code used to submit jobs to the ComputeCanada/SciNet HPC resources, including information on input parameters to the .c file

InhibitoryCortex_*_.m files:
code used to plot the various heatmaps presented in the manuscript, implementing the "Synchrony Measure" and "Bistability Measure"

conv_gaussian.m, convert_spiketimes.m, golomb_measure.m, golomb_synch.m:
code used for the implementation of the "Synchrony Measure"

InhibitoryCortex_pulse_2d_FullWithRep_0905.m:
code used to generate "2d" plots of Synchrony Measure vs Input Current

Remaining .m files:
code containing the various miscellany necessary for the plotting functions discussed above.
