function [Vx,Rxymax,SPR] = velocity(nlags,deltaX,fsample,S1,S2)
%Robust velocity estimation including filtering criteria SPRthres and Rxymaxthres

    
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
    if  Rxymax> ((SPR^2+1)*0.4) % length(lagsRxymax)==1         
        Vx = (deltaX/1000)/tau(lagsRxymax); % pseudo-instantaneous velocity (m/s)
    else
        Rxymax = NaN;
        Vx = NaN;   
        SPR = NaN;
    end    
    
end
