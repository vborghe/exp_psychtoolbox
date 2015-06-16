# exp_psychtoolbox                                                           

Running experiments with Matlab Psychtoolbox

## Acknowledgements:
Virginie Van Wassenhove, Marco Buiatti, and Karla Monzalvo for providing very useful examples.

## To see more example from Psychtoolbox itself:
* type help psychtoolbox
* select PsychDemos

## Here:
* ExamplePsychtoolbox_Main (script to run the experiment)
* ExamplePsychtoolbox_Stimlist (function that will be called by Main to generate the appropriate list of stimuli for a given subject and a given run)
* ExamplePsychtoolbox_StimPre (function that will be called by Main to present the stimuli during the run)
* ExamplePsychtoolbox_OnsetFile (function usefull to extract from the whole output file the infos needed in the onsetfile - SPM8 first level model)
* waitTTL (function that waits for the trigger signal from the fMRI before starting the presentation of the stimuli)
