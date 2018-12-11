%% ADAPTIVE WINDOW CROSS-CORRELATION TECHNIQUE
%Version 1.0 (January 2019)
%Novel technique for processing dual-tip phase-detection probe signals in air-water flows.
%developed by M. Kramer and D. Valero
%works with MATLAB 2017a 
%contact: 
% matthias_kramer@hotmail.com
% valero@fh-aachen.de

%When using this code, please cite the following reference:
%---------------------------------------------------------------------%
%M. Kramer, D. Valero, H. Chanson and D. B. Bung (2019)
%Towards reliable turbulence estimations with phase-detection probes:
%an adaptive window cross-correlation technique
%Experiments in Fluids, 2019, 60:2
%---------------------------------------------------------------------%

clear all
close all
tic;

%% Sampling and processing parameters
nChannels = 2; %number of channels 
fsample = 20000; %sample rate in (Hz)
duration = 90; %sampling duration in (s)
deltaX = 4.71; %longitudinal distance between probe tips (mm)
nbins = 100; %number of bins (probability mass functions) 

nParticles = 5; %Np as defined in Kramer et al. (2019)
Rxymaxthres = 0.5; %threshold cross-correlation coefficient
SPRthres = 0.6; %threshold SPR, as defined in Kramer et al. (2019)
 
%SPRthres between 0.5 and 0.8, as indicated by
%---------------------------------------------------------------------%
%R. D. Keane and R. J. Adrian (1990)
%Optimization of particle image velocimeters. I. Double pulsed systems
%Measurement Science and Technology 1, pp. 1202-1215
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
%R. Hain and C. J. Kaehler (2007)
%Fundamentals of multiframe particle image velocimetry (PIV)
%Experiments in Fluids 42, pp. 575-587
%---------------------------------------------------------------------%

%Rxymaxthres between 0.5 and 0.7, as indicated in
%---------------------------------------------------------------------%
%J. Matos, K. H. Frizell, S. Andre and K. W. Frizell (2002)
%Discussion of "Two-Phase Flow Characteristics of Stepped Spillways" 
%by Robert M. Boes and Willi H. Hager
%Journal of Hydraulic Engineering 129(9), pp. 661-670.
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
%S. Andre, J.-L. Boillat and A. J. Schleiss (2003)
%On the performance of velocity measurement techniques
%in air-water flows
%Proceedings of the EWRI/IAHR joint conference on hydraulic 
%measurements & experimental methods ASCE, Estes Park, USA
%---------------------------------------------------------------------%

%% Data reading and sorting (data-format sensitive)
files = dir('*.dat');  
nmeasurements = size(files,1);

for j=1:1:nmeasurements
 [fileID,errmsg] = fopen(files(j).name);
 A = fread(fileID,'int16','l')*5/32767;

 S1r{1,j} = A(5:nChannels:size(A)); %o: original signal
 S2r{1,j} = A(6:nChannels:size(A));
 
 txt = textscan(files(j).name,'%f %f %f','Delimiter','_');
 S1r{2,j} = txt{2}+(txt{3}/100);
 S2r{2,j} = txt{2}+(txt{3}/100);  
end

%Sorting
[y, idx] = sort([S1r{2,:}], 'ascend');
S1r =  S1r(:,idx);
S2r =  S2r(:,idx);

%---------------------------------------------------------------------%
%% Preallocation
C1 = zeros(1,nmeasurements); %void fraction tip1
C2 = zeros(1,nmeasurements); %void fraction tip2
F1 = zeros(1,nmeasurements); %bubble count rate tip1
F2 = zeros(1,nmeasurements); %bubble count rate tip2
Tu = zeros(1,nmeasurements); %turbulence intensity
U = zeros(1,nmeasurements); %interfacial velocity
%---------------------------------------------------------------------%
%% Void fraction, bubble/droplet count rate and chord times
for j=1:1:nmeasurements %Loop over measurements
 %Thresholding and calculation of void fractions
 [mode1air(j),mode1water(j),threshold1(j),C1(j),S1f{j}] = thres(S1r{1,j},nbins);
 [mode2air(j),mode2water(j),threshold2(j),C2(j),S2f{j}] = thres(S2r{1,j},nbins);  
 
 %Chord time calculations
 [ChordW1{j},ChordA1{j},F1(j)] = chord(S1f{j},duration);
 [ChordW2{j},ChordA2{j},F2(j)] = chord(S2f{j},duration);  
end 
%---------------------------------------------------------------------%
%% Velocity and turbulence intensity estimations  
for j=1:1:nmeasurements %loop over measurements    
   
 %number of windows
 [nwindows(j),start,stop,t{j}] = windows(ChordA2{j},ChordW2{j},nParticles,fsample);
  
 %loop instantaneous velocities
  for i=1:nwindows(j) %loop over subsegments       
   nlags(i) = stop(i)-start(i); %lags correspond to time windows   
   S1=S1f{j}(start(i):stop(i)); %signals
   S2=S2f{j}(start(i):stop(i)); %signals      
   [uinstloop(i),Rxymaxloop(i),SPRloop(i)] = velocity(0.5,nlags(i), ...
                                         deltaX,fsample,SPRthres,Rxymaxthres,S1,S2); %pseudo-instantaneous velocities      
  end %end loop subsegments 
 
 %data filtering 
 [uinstloop] = roc(uinstloop); % ROC filtering, R12 and SPR filtering implemented in previous loop.
 spikesloop = (sum(isnan(uinstloop))/length(uinstloop))*100;
 fprintf('Discarded data: %2.1f %%\n', spikesloop) 

 uinst{j} = uinstloop;
 spikes(j) = spikesloop;
 Rxymaxinst{j} = Rxymaxloop;
 SPRinst{j} = SPRloop;

 %calculation of time-averaged variables
 U(j) = nanmean(uinst{j});
 Rxymax(j) = nanmean(Rxymaxloop);
 SPR(j) = nanmean(SPRloop);

 %calculation of velocity fluctuations
  for i=1:nwindows(j) %loop over subsegments 
   ustr{j}(i) = (uinst{j}(i) - U(j))^2;   
  end %end loop subsegments 
  
 urms(j)= sqrt(nansum(ustr{j}) /(length(ustr{j}) - sum(isnan(ustr{j}))));
 Tu(j) = urms(j)/abs(U(j));  
 
 %clearing some variables
 clear start stop spikesloop uinstloop Rxymaxloop SPRloop S1 S2 nlags
 
end %end loop measurements
datayield = (100-spikes)/100;
  
%% Export results 
warning('off','MATLAB:xlswrite:AddSheet')
%writing results of time-averaged data
RESULTS1(:,1) = y;
RESULTS1(:,2) = C1;
RESULTS1(:,3) = F1;
RESULTS1(:,4) = U;
RESULTS1(:,5) = Rxymax;
RESULTS1(:,6) = Tu; 
RESULTS1(:,7) = SPR; 
RESULTS1(:,8) = datayield; 

RESULTS2(:,1) = y;
RESULTS2(:,2) = C2;
RESULTS2(:,3) = F2;

%xlswrite 
col_header11={'y','C','F','V','Rxymax','Tu','SPR','data yield'}; 
col_header12={'(mm)','(-)','(1/s)','(m/s)','(-)','(-)','(-)','(-)'}; 
xlswrite('RESULTS',col_header11,'Leading','A1'); 
xlswrite('RESULTS',col_header12,'Leading','A2'); 
xlswrite('RESULTS',RESULTS1,'Leading','A3');

col_header21={'y','C','F'}; 
col_header22={'(mm)','(-)','(1/s)'}; 
xlswrite('RESULTS',col_header21,'Trailing','A1'); 
xlswrite('RESULTS',col_header22,'Trailing','A2'); 
xlswrite('RESULTS',RESULTS2,'Trailing','A3');


%% PLOT 
%Void fraction - turbulence intensity = interfacial velocity 
%quality parameters - bubble count rate 

Uplot = U./max(U);
gray = [0.6 0.6 0.6];


figure(1)
set(gcf,'Position', [400 400 400 400])
subplot(2,2,1)
scatter(C1,y,'s','MarkerEdgeColor',gray,'linewidth',0.7); hold on
scatter(Uplot,y,'k','linewidth',0.7); hold on
scatter(Tu,y,'*r','linewidth',0.7); hold on
grid;
xlabel('$C$, $U/U_\mathrm{max}$, $Tu$','Interpreter', 'latex','FontSize',10)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',10)
h = legend({'$C$','$U$','$Tu_x$'},'Interpreter', 'latex','FontSize',8,'Location','north');
rect = [0.185, 0.84, .15, .15];
set(h,'Position',rect);
xlim([0 1]);
box on

subplot(2,2,2)
plot(nwindows/10000,y,'Color','r','linewidth',1.5); hold on
scatter(datayield,y,'xk','linewidth',0.7); hold on
scatter(Rxymax,y,'*k','linewidth',0.7); hold on
scatter(SPR,y,'sk','linewidth',0.7); hold on
grid;
h = legend({'$N_{\mathcal{W}}$','$\overline{\mathrm{SPR}}$','data yield','$\overline{R_{12,\mathrm{max}}}$'},'Interpreter', 'latex','FontSize',8,'Location','north');
rect = [0.66, 0.84, .15, .15];
set(h,'Position',rect);
xlabel({'$N_{\mathcal{W}}\times$10$^{-5}$, $\overline{R_{12,\mathrm{max}}}$, $\overline{\mathrm{SPR}}$'},'Interpreter', 'latex','FontSize',9)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',10)
box on
subplot(2,2,3)
scatter(F1,y,'b','linewidth',0.7); hold on
grid;
xlabel('$F$ (1/s)','Interpreter', 'latex','FontSize',10)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',10)
box on

subplot(2,2,4)
scatter(C1,F1,'b','linewidth',0.7); hold on
grid;
xlabel('C','Interpreter', 'latex','FontSize',10)
ylabel('$F$ (1/s)','Interpreter', 'latex','FontSize',10)
xlim([0 1])
box on

%% PLOT - pseudo instantaneous velocities, PMF
selectmeasurement = 10; %plotted measurement


figure(2)
set(gcf,'Position', [400 150 400 150])
subplot(1,2,1)
plot(t{selectmeasurement},uinst{selectmeasurement},'k','linewidth',0.7); hold on
grid on
xlabel('$t$ (s)', 'Interpreter', 'latex','FontSize',10)
ylabel('$u$ (m/s)', 'Interpreter', 'latex','FontSize',10)
ylim([0 8]);
xlim([0 duration])

nbins=100;
subplot(1,2,2)
[counts,bins] = hist(uinst{selectmeasurement},nbins);
counts = counts/length(uinst{selectmeasurement});
h = barh(bins,counts);
set(h,'FaceColor','k','EdgeColor','k')
ylabel('$u$ (m/s)', 'Interpreter', 'latex','FontSize',10)
xlabel('PMF', 'Interpreter', 'latex','FontSize',10)
grid on
ylim([0 8]);
xlim([0 0.08]);

toc;
