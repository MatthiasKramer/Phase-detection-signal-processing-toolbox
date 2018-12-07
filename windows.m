function [nwindows,start,stop,t] = windows(ChordA2,ChordW2,nParticles,fsample)
% This function returns the windows start/stop, their computation depends upon nParticles
% ChordA2: air chords, based on the first tip.
% ChordW2: water chords, based on the first tip.
% nParticles: number of particles making each signal subsegment.
% fsample: sampling rate

nwindows = min(floor(length(ChordA2)/nParticles),floor(length(ChordW2)/nParticles));

for i=1:1:nwindows  %adaptive windows
    start(i) = sum(ChordA2(1:nParticles*i))+sum(ChordW2(1:nParticles*i));
    stop(i) = sum(ChordA2(1:nParticles*i))+sum(ChordW2(1:nParticles*i));  
end
  
start = circshift(start,1);
start(1)=1; %first time window
stop(length(stop))=sum(ChordW2)+sum(ChordA2); %+1; %adding the last segment
t = round((start+stop)./2)/fsample; %calculation of time window centres
 
end
