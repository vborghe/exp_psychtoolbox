function [stimonset, response, rt]= ExamplePsychtoolbox_StimPres(stimdir,stimlist,ntrial,w,black,TTLonset,fixgray)    

%% =================================================== Keyboard & Response

deviceIndex = [];
KbName('UnifyKeyNames'); % keyboard mapping
escapeKey = KbName('ESCAPE'); %  What's the difference?
quitkey = KbName('SPACE'); % What's the difference?
ButtonLeftKey = KbName('P'); % subject's left answer
ButtonRightKey = KbName('Y'); % subject's right answer
keysOfInterest=zeros(1,256); %% 
keysOfInterest(ButtonLeftKey)=1; %% 
keysOfInterest(ButtonRightKey)=1; %% 
keysOfInterest(escapeKey)=1; %% 
KbQueueCreate(deviceIndex, keysOfInterest); %% 
KbQueueStart(deviceIndex); %%   
stop=false;      
pressed=false;

%% ===================================================  Stimuli Parameters
    % Stimuli duration
        stimdur = 0.800;   % stimuli
    % Inter Stimuli Interval [mean 1.700]
        ISI=1.700;
        listISI=Shuffle([repmat([ISI ISI+0.100 ISI-0.100],1,43) ISI ]);

%% =================================================== Stimuli presentation  

    % start collecting onsets and response
            stimonset = zeros(1,ntrial); 
            response = zeros(1,ntrial);
            rt=zeros(1,ntrial);

    % start counting the trials
            trial = 1;
            
    % start counting accuracy
            accuracy = zeros(1,ntrial);

while trial <= ntrial;

    % === Target Stimuli === %
    if stimlist(trial)<25; % recognize a target visual stimulus
            Stim = [stimdir 'visualwords' '.m'];
            data=textread((Stim),'%s ');
            imdata=char(data(stimlist(trial)));
            Screen('FillRect',w,black);
            Screen('TextSize', w, 20);
            Screen('TextFont', w, 'Geneva');
            DrawFormattedText(w, imdata, 'center', 'center', WhiteIndex(w));
            [VBLTimestamp start]=Screen('Flip', w);
                    stimonset(trial)=start-TTLonset;
                    while (GetSecs - start)<=stimdur
                    end
        % === Fixation cross during ISI === %
        fixcross = '+';
        Screen('TextSize', w, 20);
        Screen('TextFont', w, 'Geneva');
        Screen('FillRect',w, black);
        DrawFormattedText(w, fixcross, 'center', 'center', WhiteIndex(w));
        [VBLTimestamp start]= Screen('Flip', w);
            while (GetSecs - start)<=listISI(trial)
            end
    end % ends recognize target visual stimuli

    % === Rest === %
    if stimlist(trial)>34 && stimlist(trial)<59; % recognize a rest trial
        fixcross = '+';
        Screen('FillRect',w,black);
        Screen('TextSize', w, 20);
        Screen('TextFont', w, 'Geneva');
        DrawFormattedText(w, fixcross, 'center', 'center', WhiteIndex(w));
        [VBLTimestamp start]=Screen('Flip', w);
        stimonset(trial)=start-TTLonset;
            while (GetSecs - start)<=stimdur
            end
        % === Fixation cross during ISI === %
        fixcross = '+';
        Screen('TextSize', w, 20);
        Screen('TextFont', w, 'Geneva');
        Screen('FillRect',w, black);
        DrawFormattedText(w, fixcross, 'center', 'center', WhiteIndex(w));
        [VBLTimestamp start]= Screen('Flip', w);
            while (GetSecs - start)<=listISI(trial)
            end
    end   % ends recognize rest trial

%%    
    % === Odd Events === %
    if stimlist(trial)>=25 && stimlist(trial)<=34  % recognize an odd event: images
        image=[stimdir,num2str(stimlist(trial))];
        imdata=imread(image,'jpg');
        Screen('FillRect',w,black);
        imag=Screen('MakeTexture',w,imdata*fixgray);
        Screen('DrawTexture',w,imag,[],[],0,1,0);
        [VBLTimestamp start]=Screen('Flip', w);
        stimonset(trial)=start-TTLonset;
        KbQueueFlush;
            while (GetSecs - start)<=stimdur
                    if pressed==false 
                          [pressed, firstPress]=KbQueueCheck(deviceIndex);
                    end;
                     % ===================================================  Collect Response
                        % Check if any button has been pressed
                        if pressed
                            % If the response button has been pressed
                                if firstPress(ButtonLeftKey)||firstPress(ButtonRightKey)
                                    % Reaction Time
                                    topRT=GetSecs-TTLonset;
                                    rt(trial)=topRT-stimonset(trial);
                                        % Which answer has been given
                                        if firstPress(ButtonLeftKey)
                                            response(trial) = 'L'; % left
                                        else
                                            response(trial) = 'R'; % right
                                        end;
                                end
                            pressed = false;
                        end   
            end
            % === Fixation cross during ISI === %
            fixcross = '+';
            Screen('TextSize', w, 20);
            Screen('TextFont', w, 'Geneva');
            Screen('FillRect',w, black);
            DrawFormattedText(w, fixcross, 'center', 'center', WhiteIndex(w));
            [VBLTimestamp start]= Screen('Flip', w);
                while (GetSecs - start)<=listISI(trial)
                end
    end % ends recognize an odd event: images

%%
        trial = trial +1; % update trial number count
        
end; % ends while trial

end % ends function
