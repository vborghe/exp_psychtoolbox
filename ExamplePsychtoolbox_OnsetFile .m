function ExamplePsychtoolbox_OnsetFile(ID,RUN)

% This function allows you to extract onest time and name of
% conditions/events from the experiment SemDist. 

%% Directory
    setup=0
    if setup==0 % pc
           inputdir='D:\Documents and Settings\mpiazza\Desktop\MATLAB_VB\wiki\ExamplePsychtoolbox/results';
           outputdir='D:\Documents and Settings\mpiazza\Desktop\MATLAB_VB\wiki\ExamplePsychtoolbox/onsetfile';     
    elseif setup==1 % fMRI 
           inputdir='/neurospin/unicog/protocols/IRMf/TOBEADDED';
           outputdir='/neurospin/unicog/protocols/IRMf/TOBEADDED'; 
    end;
      cd(inputdir)
       
%% Extract list of stimuli and list of onset time
    load([ID, '_ExamplePsych_run' num2str(RUN) '.mat']);
    names=stimlist;
    onsets=stimonset;  

%% Create onsets file
    rest=(names>34);                    % identify which trials where rest
    odd=(names>24 & names<35);          % indentify which trials where odds
    names(odd)=25
    names(rest)=[];                     % subtract rest trials
    onsets(rest)=[];                    % subtract rest trials
    durations=zeros(size(names));
    onsetsfile=[names;onsets;durations]'
    
%% Save onsets file 
cd(outputdir)
save([num2str(ID) '_OnsetsFile_run' num2str(RUN) ],'onsetsfile');
end
