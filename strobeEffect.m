function y=strobeEffect(song)

%% Declare initial parameters
song=song(1:length(song),1);    % use mono, not stereo (first column only)
size=.06; %seconds
iterations=floor((length(song)/(44200))/size); % number of high/lows in song

%% Every other chunk 'size' seconds long is 1.5 times as loud
% while the other chunks 'size' seconds long is three times more quiet
for i=1:iterations
    x=44200*size;
    for p=(((i-1)*x)+1):(i*x)
        if mod(i,2)==1
            song(p)=song(p)*1.5;
        else
            song(p)=song(p)/2;
        end
    end
end
    
%% Play sound
%sound(song,42200);

%% Return modified array, y
y=song;