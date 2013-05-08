%phasevocoderf.m
%This function takes a wave audio signal and can timestretch or
%pitchstretch it by the phase vocoder method. A short time fourier
%transform is performed, any desired changes are made, and new wave output
%is reconstructed by the overlap add method. The output Y is the new edited wave.
%A hopratio of greater than one timestretches a signal, less than one time
%compresses a signal. To pitchstretch a signal, multiply the new sampling rate
%by the hopratio.
     %y is an input name of a wave audio sample
     %framesize is the number of samples per frame (even number) for fft
     %ihop is the space (number of samples) between fft frames (overlap) when
          %marching through signal during short time fourier transform.
     %ohop is the is the space (number of samples) between frames (overlap) when
          %reconstructing the signal by the overlap add method.
     %applywindow tells whether or not to apply hamming window to fft frames

function [Y, hopratio]=phasevocoderf(y, framesize, ihop, ohop, applywindow, handles)
%% Initialize original audio wave file & set parameters
y=y(:,1);                                                  %take only 1 column (mono)
nsamples=length(y);                                        %total number of samples in signal
hopratio=ohop/ihop;
overlap=framesize/ihop;
nframes=overlap*(floor((nsamples-framesize)/framesize));   %total number of frames in signal to take fft of (integer)
if applywindow==1
    win=.5*(1-cos(2*pi*(0:framesize-1)'/(framesize)));     %initialize hamming window (smooth out fft frame edges)
else
    win=1;                                                 %do not apply window
end


%% Apply short time fourier transform (Analysis)
store=zeros(framesize, nframes);           %initialize stft output
cnum=1;                                    %initialize current column of output                               %current frame
outofsignal=false;
wait=waitbar(0,'STFT...');
while ~outofsignal
    for it=1:ihop:nsamples
        yp=y(it:it+(framesize-1));         %acquire current frame from signal
        yp=yp.*win;                        %apply hamming window
        fy=fft(fftshift(yp));              %take fft of current frame
        store(:,cnum)=fy;                  %store fft output for current frame in output array
        cnum=cnum+1;                       %increment current column
      
        if cnum >= nframes+1
            break
        else
        end
    end
    outofsignal=true;
end
waitbar(1/3,wait,'Calculating Phase...')
%% Calculate phase and apply inverse fft to each frame (back to wav)
store2=zeros(framesize, nframes);             %initialize wave output array

for nf=1:nframes
    fc=store(:,nf);                           %acquire current column
    mag=abs(fc);                              %take absolute value/magnitude of current column
    phangle=angle(fc);                        %calculate theta values of current column
    fc=(mag.*exp(1i*hopratio*phangle));       %Main computation.
    store2(:,nf)=fftshift(real(ifft(fc)));    %apply inverse fft to current column and store in new array
   % waitbar((nf/nframes),'Calculate Phase')
end
waitbar(2/3,wait,'Synthesize Wave...')
%% Overlap and add frames back together (Synthesis)
outofcolumns=false;
outputsize=ceil(((nsamples-framesize)*hopratio));         %size of new stretched/compressed wave vector
output=zeros(outputsize, 1);                              %initialize output wave
cnum=1;                                                   %current frame

%synthesize new wave using overlap add method with new hop

while ~outofcolumns
    for ns=1:ohop:outputsize
        if ns==1
            output(ns:ns+(framesize-1))=store2(1, cnum);
        else
            add=vertcat(output(ns:(ns+(framesize-1)-ohop))+store2((1:framesize-ohop),cnum), ...
                store2((((framesize-ohop)+1):end), cnum));
            output(ns:ns+(framesize-1))=add;
        end
        cnum=cnum+1;
        if cnum >= nframes
            break
        else
        end
        %waitbar((ns/outputsize),'Synthesizing...')
    end
    outofcolumns=true;
end
Y=output;
waitbar(1,wait,'Done!')
close(wait)
end