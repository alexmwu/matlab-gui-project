function plotMusic(song,songPlot,samplingFrequency,handles,currentSample)
% plotMusic.m
% Plots waveform versus current time of song
% Alex Wu

if nargin<5
    lastSample=get(song,'CurrentSample');
else
    lastSample=currentSample;
end
if strcmp(song.Running,'on')
    songPlot=(songPlot(:,1).');
    lengthSongPlot=length(songPlot);
    samplingPeriod=1/samplingFrequency;
    timeSong=0:samplingPeriod:(lengthSongPlot-1)*samplingPeriod;
    jump=samplingFrequency;
    for currentSample=lastSample:lengthSongPlot
        drawnow
        fixedSample=song.CurrentSample;
        if currentSample<=jump+1
            plot(handles.musicAxes,timeSong(1:fixedSample+jump),songPlot(1:fixedSample+jump))
        elseif currentSample>=(lengthSongPlot-jump)
            plot(handles.musicAxes,timeSong(lengthSongPlot-jump:lengthSongPlot),songPlot(lengthSongPlot-jump:lengthSongPlot));
        else
            plot(handles.musicAxes,timeSong(fixedSample-jump:fixedSample+jump),songPlot(fixedSample-jump:fixedSample+jump))
        end
        line([(samplingPeriod*fixedSample) (samplingPeriod*fixedSample)], [min(songPlot) max(songPlot)], 'Color','Red')
        axis(handles.musicAxes,[(samplingPeriod*fixedSample)-(jump/samplingFrequency) (samplingPeriod*fixedSample)+(jump/samplingFrequency) min(songPlot) max(songPlot)])
    end
    
else
end
end