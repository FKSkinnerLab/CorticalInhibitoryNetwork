# CorticalInhibitoryNetwork
Citation: Scott Rich, Homeira Moradi Chameh, Marjan Rafiee, Katie Ferguson, Frances K. Skinner and Taufik A. Valiante. "Inhibitory network bistability explains increased interneuronal activity prior to seizure onset." Frontiers in Neural Circuits, 13, 2020.

License: GNU GENERAL PUBLIC LICENSE. Contact: Scott Rich, sbrich@umich.edu.

Simulations:

Simulations are performed primary utilizing the .c code (InhibitoryNetwork_cortex_0712.c) with parameter inputs generated via .sh files (InhibitoryNetwork_cortex_submit_0812.sh, InhibitoryNetwork_cortex_submit_zoom_0725.sh, InhibitoryNetwork_cortex.sh). Following compiling the code into a .o file, an example run of the code will look like the following:

  ./InhibitoryNetwork_cortex_0712.o gsynmin gsynmax gsynstep Iappmin Iappmax Iappstep probii sdev count state
  
where the first three inputs define the parameter range of synaptic strengths, the following three inputs define the paramter range of the applied current values, probii defines the connection probability, sdev defines the standard deviation amongst the applied currents, count dictates the number used to name the output files, and state is chosen to be either 0 or 1 (0 the control case and 1 the 4-AP case). 

Miscellany in the .sh files (srun, #SBATCH, etc.) are references to the implementation of the code on Compute Canada resoruces and can be ignored if the code is being run on an individual computer.

Outputs of the code include the following:
  InhibitoryNetwork_count_TrackVariables.csv: if uncommented, outputs average current and voltage values at each time step.
  InhibitoryNetwork_count_SpikeTimes.csv: spike times for each neuron.
  InhibitoryNetwork_count_InputCurrents.csv: external current drive to each neuron.
  InhibitoryNetwork_count_ConnectivityMatricies.csv: if uncommented, outputs connectivity matrix for each simulation.
  InhibitoryNetwork_count_Variables.csv: key variables for each simulation run in the format "probii, gsyn, Iappavg, sdev, state".

Plotting:

Plotting is done utilizing the various .m files included in the repository, primarily making use of the SpikeTimes, InputCurrents, and Variables outputs from the .c code. These pieces of code are relatively well commented and should be easily understandable given the littany of documention for Matlab coding available via MathWorks.

  InhibitoryCortex_.m files:
  
  code used to plot the various heatmaps presented in the manuscript, implementing the "Synchrony Measure" and "Bistability Measure"

  conv_gaussian.m, convert_spiketimes.m, golomb_measure.m, golomb_synch.m:
  
  code used for the implementation of the "Synchrony Measure"

  InhibitoryCortex_pulse_2d_FullWithRep_0905.m:
  
  code used to generate "2d" plots of Synchrony Measure vs Input Current

  Remaining .m files:
  
  code containing the various miscellany necessary for the plotting functions discussed above.
