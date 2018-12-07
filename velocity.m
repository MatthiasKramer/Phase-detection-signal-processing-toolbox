function [Vx,Rxymax,SPR] = velocity(thresh,nlags,deltaX,fsample,SPRthres,Rxymaxthres,S1,S2)

 %checking if signals are all above or below threshold
if max(S1)>thresh && min(S1)<thresh && max(S2)>thresh && min(S2)<thresh       
    
    [CrossCorrel,lags] = xcorr(S2-mean(S2),S1-mean(S1),nlags,'coeff');
    tau = lags/fsample;
    [pks,~,~,p] = findpeaks(CrossCorrel);
    [~,I] = max(pks);
    Peaks = pks(p>0.3*p(I)); 
  
    if length(Peaks)==1
        SPR=0;    
    else    
        SPR = max(Peaks(Peaks<max(Peaks)))/max(Peaks);
    end
    
    Rxymax = max(CrossCorrel); 
    lagsRxymax = find(CrossCorrel==Rxymax); %lags     
    if SPR<SPRthres &  Rxymax>Rxymaxthres  &  length(lagsRxymax)==1 % R12max and SPR filtering         
        Vx = (deltaX/1000)/tau(lagsRxymax); % pseudo-instantaneous velocity (m/s)
    else
        Rxymax = NaN;
        Vx = NaN;   
        SPR = NaN;
    end
    
 else
     Rxymax = NaN;
     Vx = NaN;  
     SPR = NaN;
 end    
    
end
