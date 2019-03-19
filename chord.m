function [ChordW,ChordA,F] = chord(Signal,tmeasure)
% Calculation of chord lengths and bubble/droplet count rate

 %initializing parameters
  lengthair = 1;
  counterair = 1;
  lengthwater = 1;
  counterwater = 1;
  
  %scanning Signal
 for k = 1:1:size(Signal,2)-1
    if Signal(k) == 0 % Tip is in the air...
        if Signal(k+1) == 0 % ... and will keep on being in the air. 
         lengthair = lengthair+1;
        elseif Signal(k+1) == 1 % ... and gets wet in the next measurement.
         ChordA(counterair) = lengthair;
         counterair = counterair +1;
         lengthair = 1;                      
        end  
    elseif Signal(k) == 1 % Tip is in the water...
        if Signal(k+1) == 1 % ... and will keep on being in the water.
        lengthwater = lengthwater+1; 
        elseif Signal(k+1) == 0 % and gets dry in the next measurement.
         ChordW(counterwater) = lengthwater;
         counterwater = counterwater +1;
         lengthwater = 1;
        end    
    end     
 end
  
 F = (size(ChordA,2)/(tmeasure)); % Bubble/droplet frequency (1/s)
 
end
