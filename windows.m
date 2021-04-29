function [nwindows,start,stop,t] = windows(ChordA,ChordW,nParticles,fsample)
% WINDOWS This function returns the windows start/stop, their computation depends upon selection of nParticles
% This function inputs:
%   ChordA2: air chords, based on the first tip.
%   ChordW2: water chords, based on the first tip.
%   nParticles: number of particles making each signal subsegment.
%   fsample: sampling rate
%
% This function returns:
%   nwindows: number of windows (total no particles / nParticles).
%   start: starting position of the window (index)
%   stop: end position of the window (index)
%   t: central time of each window.
%

nwindows = min(floor(length(ChordA)/nParticles),floor(length(ChordW)/nParticles));

for i=1:1:nwindows  % adaptive windows
    start(i) = sum(ChordA(1:nParticles*i))+sum(ChordW(1:nParticles*i));
    stop(i) = sum(ChordA(1:nParticles*i))+sum(ChordW(1:nParticles*i));  
end
  
start = circshift(start,1);
start(1)=1; % first time window
stop(length(stop))=sum(ChordW)+sum(ChordA); % +1; % adding the last segment
t = round((start+stop)./2)/fsample; % calculation of time window centres
 
end
