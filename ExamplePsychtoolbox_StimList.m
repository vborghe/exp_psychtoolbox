function [list]=ExamplePsychtoolbox_StimList(ID,RUN)

%% Directories

setup = 0  % Choose computer [1=fMRI, 0=Laptop]

    if setup==0 % pc
       outdir='D:\Documents and Settings\mpiazza\Desktop\MATLAB_VB\wiki\ExamplePsychtoolbox/list';
    elseif setup==1 % fMRI [TO BE ADDED]
       outdir='/neurospin/unicog/protocols/IRMf/TOBEADDED';
    end;

%% Parameters %%

numbtrial=130;
list=zeros(1,numbtrial);       % Stimulus List initialisation

%% Generate stimulus sequence
  
     % Indexing stimuli
     animals=(1:12);     % 12 target animals
     tools=(13:24);  % 12 target tools
     odd=(25:34);    % 10 odds
     rest=(35:58);  % 24 rest
     
     % Collect index for the all list (and randomize it)
     list=[animals tools animals tools animals tools animals tools odd rest];
     list=Shuffle(list);
     

%% save list  [NOT NEEDED]
 save([outdir '\' num2str(ID) '_Example_run' num2str(RUN) ],'list');
end
