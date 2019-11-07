function [nwindows,start,stop,t] = windows(ChordA,ChordW,nParticles,fsample)
% This function returns the windows start/stop, their computation depends upon nParticles
% ChordA2: air chords, based on the first tip.
% ChordW2: water chords, based on the first tip.
% nParticles: number of particles making each signal subsegment.
% fsample: sampling rate

nwindows = min(floor(length(ChordA)/nParticles),floor(length(ChordW)/nParticles));

for i=1:1:nwindows  %adaptive windows
    start(i) = sum(ChordA(1:nParticles*i))+sum(ChordW(1:nParticles*i));
    stop(i) = sum(ChordA(1:nParticles*i))+sum(ChordW(1:nParticles*i));  
end
  
start = circshift(start,1);
start(1)=1; %first time window
stop(length(stop))=sum(ChordW)+sum(ChordA); %+1; %adding the last segment
t = round((start+stop)./2)/fsample; %calculation of time window centres
 
end
