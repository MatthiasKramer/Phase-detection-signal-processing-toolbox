%% BATCH RUN AWCC
%Version 1.2 (June 2019)
%Novel technique for processing dual-tip phase-detection probe signals in air-water flows.
%developed by M. Kramer, B. Hohermuth,D. Valero and S. Felder
%works with MATLAB 2017a 
%contact: 
%m.kramer@adfa.edu.au
%davahue@gmail.com

%when using this code, please cite the following reference:
%--------------------------------------------------------------------------%
%M. Kramer, B. Hohermuth, D. Valero and S. Felder (2019)
%Best practices for pseudo-instantaneous velocity measurements in highly 
%aerated flows with dual-tip phase-detection probes 
%International Journal of Multiphase Flow
%--------------------------------------------------------------------------%
%
%--------------------------------------------------------------------------%
%M. Kramer, D. Valero, H. Chanson and D. B. Bung (2019)
%Towards reliable turbulence estimations with phase-detection probes:
%an adaptive window cross-correlation technique
%Experiments in Fluids, 2019, 60:2
%--------------------------------------------------------------------------%

clear all
close all
tic;

fsample=20000; %sample rate in (Hz)
duration=45; %sampling duration in (s)
deltaX=4.71; %longitudinal distance between probe tips (mm)
Np=(5:1:15);

for i=1:1:length(Np)
[y{i},C1{i},C2{i},F1{i},F2{i},U{i},Rxymax{i},Tu{i},SPR{i},datayield{i},uinst{i},t{i},SPRinst{i},Rxymaxinst{i}]=awcc(fsample,duration,deltaX,Np(i));
end
%Tu defined as u'rms/max(U)!

%save('data.mat','y','C1','C2','F1','F2','U','Rxymax','Tu','SPR','datayield','uinst','t','SPRinst','Rxymaxinst');
%load('data.mat');

%% PLOT
cm=viridis(length(Np)); alph=0.25; SIZE=10; edges=-5:0.5:15;

fig=figure(1);
set(gcf,'Position', [300 400 350 500])
for i=1:1:length(Np)
subplot(3,1,1)
scatter(U{i},y{i},'MarkerFaceColor',cm(i,:),'MarkerEdgeColor','none','linewidth',0.7); hold on
alpha(alph)
box on
grid on;
xlabel('$U$ (m/s)','Interpreter', 'latex','FontSize',SIZE)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',SIZE)
set(gca, 'CLim', [min(Np), max(Np)]); 
c = colorbar();
colormap(fig,cm)
c.FontSize = 10;
c.Label.String = '$N_p$';
c.Label.Interpreter = 'LaTex';
c.Label.FontSize = SIZE;
xlim([0 12]);


subplot(3,1,2)
scatter(Tu{i},y{i},'MarkerFaceColor',cm(i,:),'MarkerEdgeColor','none','linewidth',0.7); hold on
alpha(alph)
grid on;
xlabel({'$u_{rms}/U_{\mathrm{max}}$ (-)'},'Interpreter', 'latex','FontSize',SIZE)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',SIZE)
box on
set(gca, 'CLim', [min(Np), max(Np)]); 
c = colorbar();
c.FontSize = 10;
c.Label.String = '$N_p$';
c.Label.Interpreter = 'LaTex';
c.Label.FontSize = SIZE;
xlim([0 0.3]);

subplot(3,1,3)
scatter(datayield{i},y{i},'MarkerFaceColor',cm(i,:),'MarkerEdgeColor','none','linewidth',0.7); hold on
alpha(alph)
grid on;
xlabel({'datayield (-)'},'Interpreter', 'latex','FontSize',SIZE)
ylabel('$y$ (mm)','Interpreter', 'latex','FontSize',SIZE)
box on
set(gca, 'CLim', [min(Np), max(Np)]); 
c = colorbar();
c.FontSize = 10;
c.Label.String = '$N_p$';
c.Label.Interpreter = 'LaTex';
c.Label.FontSize = SIZE;
xlim([0 1]);
end

fig=figure(2);
set(gcf,'Position', [700 400 350 500])
for i=1:1:length(Np)    
subplot(3,1,1)
h1=histogram(uinst{i}{1}(~isnan(uinst{i}{1})),edges,'FaceColor',cm(i,:),'EdgeColor','none','linewidth',0.7,'Normalization','probability'); hold on
alpha(alph)
box on
grid on;
xlabel('$u$ (m/s)','Interpreter', 'latex','FontSize',SIZE)
ylabel('PMF','Interpreter', 'latex','FontSize',SIZE)
set(gca, 'CLim', [min(Np), max(Np)]); 
c = colorbar();
colormap(fig,cm)
c.FontSize = 10;
c.Label.String = '$N_p$';
c.Label.Interpreter = 'LaTex';
c.Label.FontSize = SIZE;
ylim([0 0.5]);
xlim([-3 13]);

subplot(3,1,2)
h2=histogram(uinst{i}{2}(~isnan(uinst{i}{2})),edges,'FaceColor',cm(i,:),'EdgeColor','none','linewidth',0.7,'Normalization','probability'); hold on
alpha(alph)
box on
grid on;
xlabel('$u$ (m/s)','Interpreter', 'latex','FontSize',SIZE)
ylabel('PMF','Interpreter', 'latex','FontSize',SIZE)
set(gca, 'CLim', [min(Np), max(Np)]); 
c = colorbar();
colormap(fig,cm)
c.FontSize = 10;
c.Label.String = '$N_p$';
c.Label.Interpreter = 'LaTex';
c.Label.FontSize = SIZE;
ylim([0 0.5]);
xlim([-3 13]);

subplot(3,1,3)
h3=histogram(uinst{i}{3}(~isnan(uinst{i}{3})),edges,'FaceColor',cm(i,:),'EdgeColor','none','linewidth',0.7,'Normalization','probability'); hold on
alpha(alph)
box on
grid on;
xlabel('$u$ (m/s)','Interpreter', 'latex','FontSize',SIZE)
ylabel('PMF','Interpreter', 'latex','FontSize',SIZE)
set(gca, 'CLim', [min(Np), max(Np)]); 
c = colorbar();
colormap(fig,cm)
c.FontSize = 10;
c.Label.String = '$N_p$';
c.Label.Interpreter = 'LaTex';
c.Label.FontSize = SIZE;
xlim([-3 13]);
ylim([0 0.5]);
end
