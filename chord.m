function [ChordW,ChordA,F,N] = chord(Signal,tmeasure)
% CHORD This function calculates chord times and bubble/droplet count rate
%
%   This function receives:
%     Signal: binarised signal (0:water, 1:air) after thres.m.
%     tmeasure: time sampled with the conductivity probe (e.g., 45 s).
%
%   This function returns:
%     ChordW: chord times for water particles.
%     ChordA: chord times for air particles.
%     F: air particle frequency (counts per second).
%     N: total counts of air particles.
%

%initializing parameters
ChordW=NaN;
ChordA=NaN;
lengthair=1;
counterair=1;
lengthwater=1;
counterwater=1;
  
%scanning Signal
 for k=1:1:size(Signal,2)-1
    if Signal(k)==1 % Tip is in the air...
        if Signal(k+1)==1 % ... and will keep on being in the air. 
         lengthair=lengthair+1;
        elseif Signal(k+1)==0 % ... and gets wet in the next measurement.
         ChordA(counterair)=lengthair;
         counterair=counterair +1;
         lengthair=1;                      
        end  
    elseif Signal(k)==0 % Tip is in the water...
        if Signal(k+1)==0 % ... and will keep on being in the water.
        lengthwater=lengthwater+1; 
        elseif Signal(k+1)==1 % and gets dry in the next measurement.
         ChordW(counterwater)=lengthwater;
         counterwater=counterwater +1;
         lengthwater=1;
        end    
    end     
 end
  
 F=(size(ChordA,2)/(tmeasure)); % air particle count rate (1/s)
 N=size(ChordA,2); % total count of air paticles.
 
end
