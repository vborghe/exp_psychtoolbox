%% === VB march 2013 === %%

%% ======= OVERVIEW OF THE EXPERIMENT ======= %%

% Within a given fMRI session, the subject undergoes 4 runs.
% During a run, 12 animals and 12 tools names are presented 6 times each:
% 3 times as auditory stimili, 3 time as visual stimuli.
% In addition to the 144 target stimuli, each run contains 14 odd events
% (cities names, ratio 1:10) and 36 rest periods (fixation point, ratio 1:4).

%% ======= GETTING READY ======= %%

clear all;                       % Clean Workspace
clc;                             % Clean command windos
AssertOpenGL;                    % Make sure the script is running on Psychtoolbox-3
rand('state',sum(100*clock));    % Reseed the random-number generator for each expt.
setup =0;                        % Choose computer [1=fMRI, 0=Laptop]

%% ======= PRELIMINARY STUFF ======= %%

debugmanip=false;               %% 
varscreen=0                     %% 

    % The very first call to KbCheck takes itself some time
    % after this it is in the cache and very fast
    % we thus call it here once for no other reason than to get it cached.
    % This is true for all major functions in Matlab,
    % so calling each of them once before entering the trial loop 
    % will make sure that the 1st trial goes smooth with timing.
    while KbCheck % wait until all keys are released
    end;
    
deviceIndex = [];               %% 

%% ======= INPUT PARAMETERS (e.g. keyboard) ======= %%

% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems (not absolutely necessary, but good practice):

KbName('UnifyKeyNames');                   % keyboard mapping

escapeKey = KbName('ESCAPE'); %  
quitkey = KbName('SPACE'); %

ButtonLeftKey = KbName('P');            % subject's left answer
ButtonRightKey = KbName('Y');           % subject's right answer

keysOfInterest=zeros(1,256); %% 
keysOfInterest(ButtonLeftKey)=1; %% 
keysOfInterest(ButtonRightKey)=1; %% 
keysOfInterest(escapeKey)=1; %% 
KbQueueCreate(deviceIndex, keysOfInterest); %% 
KbQueueStart(deviceIndex); %% 

ttlkey = KbName('S');                   % emulates trigger from fMRI

RestrictKeysForKbCheck([escapeKey, ttlkey,quitkey,ButtonLeftKey,ButtonRightKey ]) %% 

%% ======= EXPERIMENT PARAMETERS ======= %%

ntrial=130;                   % number of trial
                             % [obviously, any number you want up to the 
                             % length of your stimlist]

%% ======= FILE HANDLING (input and output) ======= %%

% Promt user data file name
        global dataFile;
        dataFile = 'name';
        promptUser=true;
        ID='';
        
% 1) Ask for subject name
    while promptUser
        prompt=inputdlg('Subject ID?','Output',1,{'name'});
    
         if isempty(prompt)
            disp('Cancel experiment ...');
            return;
         else
            ID=prompt{1};
         end
         
% 2) Ask for run number
    while promptUser
        prompt=inputdlg('Run number?','Run [1-4]');
        RUN=str2num(prompt{1});
        promptUser=false;
    end
        if ID
             Filename = [ID, '_ExamplePsych_run' num2str(RUN) '.mat'];
                 if ~ exist(Filename)
                     dataFile = Filename;
                    promptUser = false;
                    Senttrig = [];
                    save(dataFile,'Senttrig');  % create the dataFile if it doesn't exist.
                 else
                    replace=questdlg(['A data file currently exists for ', Filename, '. Do you want to replace it?']);
                        if strcmp( replace, 'Yes' )
                        dataFile = Filename;
                        promptUser = false;
                        SentEvents = [];
                        save(dataFile,'SentEvents');  % replace the dataFile if it does exist.
                        end
                 end
        end
    end
    
    
% Output directory
    if setup==0 % pc
       outdir='D:\Documents and Settings\mpiazza\Desktop\MATLAB_VB\wiki\ExamplePsychtoolbox/results';
    elseif setup==1 % fMRI
       outdir='/neurospin/unicog/protocols/IRMf/TOBEADDED';
    end;
    
    
% Input directory 
    if setup==0 % pc
       stimdir='D:\Documents and Settings\mpiazza\Desktop\MATLAB_VB\wiki\ExamplePsychtoolbox/stimuli/'; 
    elseif setup==1 % fMRI 
       stimdir='/neurospin/unicog/protocols/IRMf/TOBEADDED'; 
    end;
            
% Call function to prepare subject's random list 
                % [Here the alternative is to load a list pre-randomized. 
                % The choice will depend on your specific needs.]
[list]=ExamplePsychtoolbox_StimList(ID,RUN);
stimlist=list;                

%% ======= RUN EXPERIMENT ======= %%

% Embed core of code in try ... catch statement. If anything goes wrong
% inside the 'try' block (Matlab error), the 'catch' block is executed to
% clean up, save results, close the onscreen window etc. This will often 
% prevent you from getting stuck in the PTB full screen mode.

try 
    %% ================ Experiment Environment ================== %%
    
    % Get screenNumber of stimulation display. We choose the display with
    % the maximum index, which is usually the right one, e.g., the external
    % display on a Laptop:
    screenNumber = max(Screen('Screens'));
    framerate = Screen(screenNumber,'FrameRate');
    fprintf('screenNumber= %d and framerate=%d\n', screenNumber, framerate);
    Screen('Preference', 'SkipSyncTests', varscreen); % 1=skip! Use the value 1 with caution
    Screen('Preference', 'VisualDebuglevel', 3); % No white startup screen
    
    % Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % they are loaded and ready when we need them - without delays:
    KbCheck;
    GetSecs;
    
    Priority(2); % set high priority for max performance
    
    HideCursor; % hide the mouse cursor
    
    % Open a double buffered fullscreen window on the stimulation screen 'screenNumber'. 
    % 'w' is the handle used to direct all drawing commands to that window.
    % 'screenRect' is a rectangle defining the size of the window.
    % See "help PsychRects" for help on such rectangles and useful helper functions:
    [w,screenRect] = Screen('OpenWindow', screenNumber,0,[],32,2);
    
    Screen(w, 'WaitBlanking'); % make sure that waitblanking has been called at least once before entering loop
    dispW   = screenRect(3) - screenRect(1);
    dispH   = screenRect(4) - screenRect(2);
    x0      = dispW/2;
    y0      = dispH/2;
    white = WhiteIndex(w);
    black = BlackIndex(w);
    gray = (white+black)/2;
    fixgray = 0.8; % will fix the gray level, act as a multiplier on all images
    black   = BlackIndex(screenNumber);
    %    darkblue = [15 15 60];
    %    blue    =  ;
    
    %% ================ Main Corpus ================== %%
   
    prevtime = GetSecs;  %% to initalize
    
    % NOTE: most Screen functions must be called after opening an onscreen window.
    % They only take window handles 'w' as input:
        
   % Write instruction message for subject (centered, white color).  
   % The special character '\n' introduces a line-break:   
       Screen('TextSize', w, 18);
       Screen('TextFont', w, 'Geneva');
       Screen('FillRect', w, black );  
       beginningmessage = 'Pay attention. \n \n \n \n Wait for TTL';
       DrawFormattedText(w, beginningmessage, 'center', 'center', WhiteIndex(w));
       Screen('Flip', w);  

       waitTTL;
       TTLonset = GetSecs;
     
   % We need to re-define the keyboard after TTL which contains kbQueueRelease 
        KbQueueCreate(deviceIndex, keysOfInterest);
        KbQueueStart(deviceIndex);
        stop=false;
    
        onsetExpe=GetSecs; % time at the start fo the experiment 
         
 % call function for STIMULI PRESENTATION 
       [stimonset, response, rt]= ExamplePsychtoolbox_StimPres(stimdir,stimlist,ntrial,w,black,TTLonset,fixgray);     
            
  % Write ending message  
       Screen('TextSize', w, 18);
       Screen('TextFont', w, 'Geneva');
       Screen('FillRect', w, black );  
       endmessage = 'End of the run.';
       Screen('DrawText', w, endmessage, x0-100 , y0, white);
       Screen('Flip', w);         
            
   % Duration of the experiment: 
        offsetExpe=GetSecs; % time at the end of the experiment
        DurExpe=(offsetExpe-onsetExpe)/60; % compute duration of the run  
        
   % Wait for mouse click:
        GetClicks(w);     
            
catch  % Catch error: this is executed in case something goes wrong in the
       % 'try' part due to programming error etc...
       % if PTB crashes it will land here, allowing us to reset the screen to normal.
    
    disp(['CRITICAL ERROR: ' lasterr ])
    disp(['Exiting program ...'])
       
    % Do same cleanup as at the end of a regular session...
    ShowCursor;
    Screen('CloseAll');
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);

end

%% ======= END EXPERIMENT ======= %%

Priority(0); % priority back to normal
Screen('closeall'); % this line deallocates the space pointed to by the buffers, and returns the screen to normal.
ShowCursor; % un-hide the mouse cursor
FlushEvents('keyDown'); % removed typed characters from queue.
cd(outdir)     % go to the output directory
save(dataFile);  % save everything
