function [ChordW,ChordA,F] = chord(Signal,tmeasure)

 %bubble frequency
  lengthair = 1;
  counterair = 1;
  lengthwater = 1;
  counterwater = 1;
  
  %scanning Signal1
 for k = 1:1:size(Signal,2)-1
    if Signal(k) == 0         
        if Signal(k+1) == 0                
         lengthair = lengthair+1;
        elseif Signal(k+1) == 1             
         ChordA(counterair) = lengthair;
         counterair = counterair +1;
         lengthair = 1;                      
        end  
    elseif Signal(k) == 1 
        if Signal(k+1) == 1
        lengthwater = lengthwater+1; 
        elseif Signal(k+1) == 0 
         ChordW(counterwater) = lengthwater;
         counterwater = counterwater +1;
         lengthwater = 1;
        end    
    end     
 end
  
 F = (size(ChordA,2)/(tmeasure)); %1/s 
 
end