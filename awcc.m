function [y,C1,C2,F1,F2,U,Rxymax,Tu,SPR,datayield,uinst,t,SPRinst,Rxymaxinst]=awcc(fsample,duration,deltaX,nParticles) 
%% Sampling and processing parameters
nChannels=2; %number of channels 
nbins=100; %number of bins (probability mass functions) 

%% Data reading and sorting (data-format sensitive)
files = dir('*.dat');  
nmeasurements = size(files,1);
 
%% Preallocation
C1=zeros(1,nmeasurements); %void fraction tip1
C2=zeros(1,nmeasurements); %void fraction tip2
F1=zeros(1,nmeasurements); %bubble count rate tip1
F2=zeros(1,nmeasurements); %bubble count rate tip2
Tu=zeros(1,nmeasurements); %turbulence intensity
U=zeros(1,nmeasurements); %interfacial velocity

for j=1:1:nmeasurements
 %Open and read file-------------------------------------------------------%
 [fileID,~]=fopen(files(j).name);
 A=fread(fileID,'int16','l')*5/32767;

 S1r=A(5:nChannels:size(A)); %r: raw signal
 S2r=A(6:nChannels:size(A));
 
 txt = textscan(files(j).name,'%f %f %f','Delimiter','_');
 y(j) = txt{2}+(txt{3}/100);
  
 %Void fraction, particle count rate and chord times-----------------------%
 [mode1air(j),mode1water(j),threshold1(j),C1(j),S1f]=thres(S1r,nbins);
 [mode2air(j),mode2water(j),threshold2(j),C2(j),S2f]=thres(S2r,nbins);  
 [ChordW1,ChordA1,F1(j)] = chord(S1f,duration);
 [~,~,F2(j)] = chord(S2f,duration);  

 %Velocity and turbulence intensity estimations----------------------------%  
 [nwindows(j),start,stop,t{j}] = windows(ChordA1,ChordW1,nParticles,fsample);
   for i=1:nwindows(j) %loop over windows      
    nlags(i)=stop(i)-start(i); %lags correspond to time windows           
    S1=S1r(start(i):stop(i)); %raw signals leading tip
    S2=S2r(start(i):stop(i)); %raw signals trailing tip
    [uinstloop(i),Rxymaxloop(i),SPRloop(i)]=velocity(nlags(i),deltaX,fsample,S1,S2); %pseudo-instantaneous velocities    
   end %end loop over windows
  
    %ROC filtering 
    while sum(isnan(uinstloop))<sum(isnan(roc(uinstloop)))
     [uinstloop]=roc(uinstloop);    
    end
  spikesloop=(sum(isnan(uinstloop))/length(uinstloop))*100;
  fprintf('Discarded data: %2.1f %%\n', spikesloop); 
  uinst{j}=uinstloop; spikes(j)=spikesloop; Rxymaxinst{j}=Rxymaxloop; SPRinst{j}=SPRloop;

 %calculation of time-averaged variables-----------------------------------% 
  U(j)=nanmedian(uinst{j}); urms(j)=nanstd(uinst{j});  
  Rxymax(j)=nanmedian(Rxymaxloop); SPR(j)=nanmedian(SPRloop); 
    
 %clearing some variables
 clear A S1 S2 S1r S2r S1f S2f start stop spikesloop uinstloop Rxymaxloop SPRloop ChordW1 ChordA1 ChordW2 ChordA2
end %end loop measurements
Tu=urms./max(U);
datayield=(100-spikes)/100;

end