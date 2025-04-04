
### BA Atlas for interactive plotting of intracranial electrode contacts (sEEG / ECoG) 

# April 04, 2025
# Elias Rau

Hi!
I was looking for a nice way to create customizable plots of sEEG electrodes in standardized (MNI) space, highlighting distinct regions of interest.
My small tool is based on the MNI brain model template and BA atlas segmentation from Lacadie et al., (2008) that is also implemented in an interactive online tool of the BioImage Suite (https://bioimagesuiteweb.github.io/webapp/)
You may either plot the whole brain, distinct BA regions, highlight regions in wholebrain plots and add MNI coordinates for sEEG electrode positions. 



References:
    C.M. Lacadie, R. K. Fulbright, J. Arora, R.T.Constable, and X. Papademetris. Brodmann Areas defined in MNI space using a new Tracing Tool in BioImage Suite. Human Brain Mapping, 2008.

Requirements:
    cbrewer2 - https://de.mathworks.com/matlabcentral/fileexchange/58350-cbrewer2

