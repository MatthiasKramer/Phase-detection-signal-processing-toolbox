%% AWCC including bias correction for particle-probe interaction 
% Version 1.3 (April 2021)
% developed by M. Kramer, B. Hohermuth, D. Valero and S. Felder
% works with MATLAB 2017a 
% contact: 
% m.kramer@adfa.edu.au
% d.valero@un-ihe.org
% hohermuth@vaw.baug.ethz.ch

% When using this code, please cite/refer to the following references:
%--------------------------------------------------------------------------%
% B. Hohermuth, M. Kramer, S. Felder and D. Valero (2021)
% Velocity bias in intrusive gas-liquid flow measurements
% Nature Communications
%--------------------------------------------------------------------------%
%
%--------------------------------------------------------------------------%
% M. Kramer, B. Hohermuth, D. Valero and S. Felder (2020)
% Best practices for pseudo-instantaneous velocity measurements in highly 
% aerated flows with dual-tip phase-detection probes 
% International Journal of Multiphase Flow 126, 103228
%--------------------------------------------------------------------------%
%
%--------------------------------------------------------------------------%
% M. Kramer, D. Valero, H. Chanson and D. B. Bung (2019)
% Towards reliable turbulence estimations with phase-detection probes:
% an adaptive window cross-correlation technique
% Experiments in Fluids, 2019, 60:2
%--------------------------------------------------------------------------%

%% Sampling and processing parameters
clearvars
close all

% Sampling parameters and phase-detection probe geometry -- please, update to your acquisition settings!
nmeasurements=25; % number of measurement points
fsample=20000; % sample rate in (Hz)
duration=45; % sampling duration in (s)
deltaX=4.71/1000; % longitudinal distance between probe tips (m)
dProbe=0.6/1000; % diameter of outer electrode (m) 
gamma=45; % angle probe-wise direction and gravity

% AWCC parameters
nParticles=10; % number of particles

% Fluid properties
rho_c=998; % density of water (kg/m^3)
nu_c=1*10^-6; % kinematic viscosity of water (m^2/s)
rho_d=1.12; % density of air (kg/m^3)
sigma=0.073; % surface tension (N/m)

% Parameters for particle-probe interaction bias correction
b=1; %contact force parameter/surface tension multiplier
cVM=0.5; %virtual mass coefficient (-)
Cp=1; %pressure coefficient


% Preallocation
C1=zeros(1,nmeasurements); % void fraction tip1
C2=zeros(1,nmeasurements); % void fraction tip2
F1=zeros(1,nmeasurements); % particle count rate tip1
F2=zeros(1,nmeasurements); % particle count rate tip2
U=zeros(1,nmeasurements); % interfacial mean velocity
y=zeros(1,nmeasurements); % elevation

%% Loop over measurements
for j=1:1:nmeasurements
% Open and read file-------------------------------------------------------%
    [S1r,S2r,y(j)]=read(j); % read raw signals
        
% Void fraction, particle count rate and chord times-----------------------%
    [mode1air(j),mode1water(j),threshold1(j),C1(j),S1f]=thres(S1r,100); % binarisation of tip 1 signal.
    [mode2air(j),mode2water(j),threshold2(j),C2(j),S2f]=thres(S2r,100); % binarisation of tip 2 signal.
    [ChordW1,ChordA1,F1(j)] = chord(S1f,duration); % air chord times, tip 1.
    [~,~,F2(j)] = chord(S2f,duration);  % air chord times, tip 2.

% Velocity and turbulence intensity estimations----------------------------%  
    [nwindows(j),start,stop,t{j}] = windows(ChordA1,ChordW1,nParticles,fsample);
        for i=1:nwindows(j) % loop over windows  
            S1=S1r(start(i):stop(i)); S2=S2r(start(i):stop(i)); % raw signals trailing tip
            w{j}(i)=stop(i)-start(i);  % weights for 1/window duration weighting
            umeas(i)=velocity(w{j}(i),deltaX,fsample,S1,S2); % measured velocities  
            Cinst=mean(S1f(start(i):stop(i))); % instantaneous void fraction
            [~,~,Finst]=chord(S1f(start(i):stop(i)),w{j}(i)/fsample); % instantaneous particle count rate
            ucorr(i)=correction(Cinst,Finst,umeas(i),deltaX,b,rho_c,rho_d,sigma,cVM,gamma,dProbe,nu_c,Cp); % correction loop   
        end % end loop over windows
  
% ROC filtering until no more data are rejected -- comment out if your data is unsteady
    while sum(isnan(ucorr))<sum(isnan(roc(ucorr)))
        [ucorr]=roc(ucorr);    
    end
   
    spikesloop=(sum(isnan(ucorr))/length(ucorr))*100; %number of discarded data.
                                                      % nan values can be produced in: i) roc, or ii) correction, or iii) velocity.
    fprintf('Discarded data: %2.1f %%\n', spikesloop); 
  
    uinstmeas{j}=umeas; uinstcorr{j}=ucorr; 
    spikes(j)=spikesloop; 

% calculation of time-averaged variables-----------------------------------% 
    % window duration weighting 
    w{j}(isnan(uinstcorr{j}))=NaN; 
    Umeas(j)=nansum(w{j}.*uinstmeas{j})/(nansum(w{j})); % Eq. (13) in Kramer et al. (2020)
    Ucorr(j)=nansum(w{j}.*uinstcorr{j})/(nansum(w{j})); % Eq. (13) in Kramer et al. (2020)
    urmsmeas(j)=sqrt(nansum(((uinstmeas{j}-Umeas(j)).^2).*w{j})/(nansum(w{j}))); % Eq. (14) in Kramer et al. (2020)
    urmscorr(j)=sqrt(nansum(((uinstcorr{j}-Ucorr(j)).^2).*w{j})/(nansum(w{j}))); % Eq. (14) in Kramer et al. (2020) 
     
    % clearing some variables
    clear S1 S2 S1r S2r S1f S2f start stop spikesloop ucorr umeas ChordW1 ChordA1 ChordW2 ChordA2
end % end loop measurements
datayield=(100-spikes)/100;

%% PLOT
alph=0.8;
SIZE=10;

fig=figure(1);
set(gcf,'Position', [300 400 350 500])
subplot(3,1,1)
scatter(Umeas,y,'d','MarkerFaceColor','blue','MarkerEdgeColor','blue','linewidth',0.7); hold on
scatter(Ucorr,y,'MarkerFaceColor','red','MarkerEdgeColor','none','linewidth',0.7); hold on
alpha(alph)
box on
grid on;
xlabel('$\overline{u}$ (m/s)','Interpreter', 'latex','FontSize',SIZE)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',SIZE)
legend('$\overline{u}_{\mathrm{meas}}$ (m/s)','$\overline{u}_{\mathrm{corr}}$ (m/s)','Interpreter', 'latex','FontSize',SIZE)
xlim([0 4]);

subplot(3,1,2)
scatter(urmsmeas,y,'MarkerFaceColor','blue','MarkerEdgeColor','none','linewidth',0.7); hold on
scatter(urmscorr,y,'MarkerFaceColor','red','MarkerEdgeColor','none','linewidth',0.7); hold on
alpha(alph)
grid on;
xlabel({'$u_{rms}$ (m/s)'},'Interpreter', 'latex','FontSize',SIZE)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',SIZE)
legend('$u_{rms,\mathrm{meas}}$ (m/s)','$u_{rms,\mathrm{corr}}$ (m/s)','Interpreter', 'latex','FontSize',SIZE)
box on
xlim([0 1.5]);

subplot(3,1,3)
scatter(datayield,y,'MarkerFaceColor','k','MarkerEdgeColor','none','linewidth',0.7); hold on
alpha(alph)
grid on;
xlabel({'datayield (-)'},'Interpreter', 'latex','FontSize',SIZE)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',SIZE)
box on
xlim([0 1]);

