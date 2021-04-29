function [Vx] = velocity(nlags,deltaX,fsample,S1,S2)
% VELOCITY This function implements the cross-correlation based velocity estimation
% for two short signals (S1 and S2) which contain a certain number of lags (nlags).
%
%   Robust velocity estimation is accomplished through filtering criteria:
%   - SPRthres: second-peak ratio of the cross-correlation function.
%   - Rxymaxthres: the maximum value of the cross-correlation function needs to be large enough
%           to be judged of confidence.
%
%   Both cross-correlation quality estimators are brought together as per Eq. 15 of:
%--------------------------------------------------------------------------%
% M. Kramer, B. Hohermuth, D. Valero and S. Felder (2020)
% Best practices for pseudo-instantaneous velocity measurements in highly 
% aerated flows with dual-tip phase-detection probes 
% International Journal of Multiphase Flow 126, 103228
%--------------------------------------------------------------------------%

    
    % signal cross-correlation
    [CrossCorrel,lags] = xcorr(S2-mean(S2),S1-mean(S1),nlags,'coeff');
    tau = lags/fsample; % time domain
    
    % find peaks of the cross-correlation function
    [pks,~,~,p] = findpeaks(CrossCorrel);
    
    % find peak locations
    [~,I] = max(pks); 
    Peaks = pks(p>0.3*p(I)); 
  
    if length(Peaks)==1
        SPR=0; % SPR is zero if only one peak was detected   
    else    
        % otherwise second highest peak divided by the highest peak
        SPR = max(Peaks(Peaks<max(Peaks)))/max(Peaks);
    end
    
    Rxymax = max(CrossCorrel); % maximum cross-correlation coefficient 
    lagsRxymax = find(CrossCorrel==Rxymax); % lags     
    
    % filtering based on SPRthres and Rxymaxthres
    if  Rxymax> ((SPR^2+1)*0.4) % length(lagsRxymax)==1         
        Vx = (deltaX)/tau(lagsRxymax); % pseudo-instantaneous velocity (m/s)
    else
        Rxymax = NaN;
        Vx = NaN;   
        SPR = NaN;
    end    
    
end
