function [modeair,modewater,threshold,C,Signalout] = thres(Signal,nbins)
%   THRES This function implements a single threshold-technique for void fraction estimation 
%   and subsequent velocimetry calculations.
%
%   This function receives:
%     Signal: raw signal in the form of a vector, and
%     nbins: number of bins, which is considered when obtaining the mode of air and water
%         recordings.
%
%   This function returns:
%     modeair: the voltage mode for air (low voltage values in conductivity 
%        probes),
%     modewater: the mode for water (high voltage values in conductivity probes),
%        threshold: the threshold obtained (half value of the previous modes),
%     C: the air concentration (percetange of low voltage values), and
%     Signalout: the binarised concentration signal.
%---------------------------------------------------------------------%

[N,centers]  = hist(Signal,nbins);

%first threshold between max and min values of raw volage signals
thres = (max(centers))/2;

%detecting modes of the bimodal air-water voltage distribution
modeair = mean(centers(N==max(N(centers<thres))));
modewater = mean(centers(N==max(N(centers>thres))));

%threshold set as 50% of the voltage span between the two modes
threshold = (modeair+modewater)/2;    
%threshold = 0.9*modewater;  
%for a sensitivity analysis related to the effect of the threshold
%selection, see
%---------------------------------------------------------------------%
%S. Felder and H. Chanson (2015)
%Phase-detecion probe measurements in high-velocity free-surface flows 
%including a discussion of key sampling paramters
%Experimental and Thermal Fluid Science 61, pp. 66-78.
%---------------------------------------------------------------------%

%binarization of the signal (Signalout = binarized signal)
Signalout(Signal>threshold)=0; % Water
Signalout(Signal<threshold)=1; % Air

%calculation of the void fraction
C=sum(Signal<threshold)/length(Signal); 
% C could be faster as: C = sum(Signalout)/len(Signalout);

end
