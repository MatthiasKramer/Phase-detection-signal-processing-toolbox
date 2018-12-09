function [Vx,Rxymax,SPR] = velocity(thresh,nlags,deltaX,fsample,SPRthres,Rxymaxthres,S1,S2)
%Robust velocity estimation including filtering criteria SPRthres and Rxymaxthres

%checking if signals are all above or below threshold
if max(S1)>thresh && min(S1)<thresh && max(S2)>thresh && min(S2)<thresh       
    
    %signal cross-correlation
    [CrossCorrel,lags] = xcorr(S2-mean(S2),S1-mean(S1),nlags,'coeff');
    tau = lags/fsample; % time domain
    
    %find peaks of the cross-correlation function
    [pks,~,~,p] = findpeaks(CrossCorrel);
    
    %find peak locations
    [~,I] = max(pks); 
    Peaks = pks(p>0.3*p(I)); 
  
    if length(Peaks)==1
        SPR=0; %SPR is zero if only one peak was detected   
    else    
        %otherwise second highest peak divided by the highest peak
        SPR = max(Peaks(Peaks<max(Peaks)))/max(Peaks);
    end
    
    Rxymax = max(CrossCorrel); %maximum cross-correlation coefficient 
    lagsRxymax = find(CrossCorrel==Rxymax); %lags     
    
    %filtering based on SPRthres and Rxymaxthres
    if SPR<SPRthres &  Rxymax>Rxymaxthres  &  length(lagsRxymax)==1          
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
