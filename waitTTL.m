function Sig=waitTTL(deviceIndex) 

if nargin < 1
    deviceIndex = [];
end

% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems:
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
TTLKey = KbName('S');
keysOfInterest=zeros(1,256);
keysOfInterest(TTLKey)=1;  %Wait for the "S" key with KbQueueWait. 
keysOfInterest(escapeKey)=1;


%disp('wait TTL...(or press Esc to escape)')
KbQueueCreate(deviceIndex, keysOfInterest);
KbQueueStart(deviceIndex);

while 1
    % Check the queue for key presses.
    [ pressed, firstPress]=KbQueueCheck(deviceIndex);
    if pressed
        if firstPress(TTLKey)
            %display(firstPress(FIND(firstPress)));
            %display(KbName(firstPress));
            %display('TTL')
            disp(GetSecs);
            KbQueueFlush;
            KbQueueRelease(deviceIndex);
            Sig = 1;
            break;
        end;
        if firstPress(escapeKey)
            KbQueueRelease(deviceIndex);
            Sig = -1;
            break
        end
    end
end;
return;
