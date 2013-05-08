%% findBPM(song, x)
% The following function finds the Beats Per Minute of a song
% by entering the name of a .wav file as variable (in quotes)
% as well as the number of seconds into the song with the strongest beat, x
% (make sure .wav file is in correct path)
%     Author: Christian Clark
function findBPM(userSong,x)

%% Declare initial parameters
song=wavread(userSong);
isTrue=false;
secs=x;                % time into song with strongest beat
start=(secs*44200)+1;  % time intervals where max volume is found
int1=start+44199;
int2=start+88399;

%% Create double column matrix
% Left column has signals of wav file
% Right column has corresponding time that the signal is played (in
% seconds)
x=linspace(0,length(song)/44200,length(song)); 
matrix=[song(1:length(song),1),x'];
matrixVal=song(1:length(song),1);      % left column
matrixSec=matrix(1:length(song),2);    % right column

%% Find max volume values (max value in left column)
% at the two chosen intervals (user chosen)
maxVal1=max(matrixVal(start:int1));
maxVal2=max(matrixVal((int1+1):int2));

%% Find which values in the left (time) column corresponds with the max
% values in the right (signal) column
for i=start:int1
    if matrixVal(i)==maxVal1
        Value1=i;
    end
end

for i=(int1+1):int2
    if matrixVal(i)==maxVal2
        Value2=i;
    end
end

%% Find initial Beats Per Minute (BPM)
% Find difference in time between max signals in interval
TimeBetween=matrixSec(Value2)-matrixSec(Value1);
% Calculate BPM by dividing 60 by seconds between max volumes
BPMi=(60/TimeBetween);
disp(['BPM initial = ',num2str(BPMi)]);

%% Change BPM if BPM value is a ridiculous, nonrational value 
% (Perhaps more than two beats occurred in the time interval)

BPM=BPMi;    % initial condition for loop
while isTrue==false
    if BPMi<80             % if BPM is too low
        BPM=BPMi+BPM;
        if BPM<80          % make sure BPM isn't still too low 
            isTrue=false;
        else
            isTrue=true;   % otherwise, continue loop
        end
    elseif BPMi>190        % if BPM is too high
        BPM=BPMi/2;
        isTrue=true;
    else                   % if BPM is a rational value
        BPM=BPMi;
        isTrue=true;
    end
end

%% Round final value of BPM
BPM=round(BPM);

%% Display BPM value
disp(['BPM = ',num2str(BPM)]);






