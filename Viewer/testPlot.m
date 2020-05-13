clear all

%% FROM SCERPA
% load('../Algorithm/simulation_output.mat','stack_mol')
% load('../Algorithm/simulation_output.mat','stack_output')
% load('../Algorithm/simulation_output.mat','stack_driver')

%% FROM FILE
QLLFile = 'D:\Dropbox\CondivisaGiuliana\topoIntegration\layout.qll';
QSSFile = 'D:\scerpa\Algorithm\OUTPUT_FILES\0002.qss';

addpath ../Algorithm/        
settings.doubleMolDriverMode=0;
settings.plot_molnum=0;
[stack_mol,stack_driver,driver_values,stack_output] = importQLL(QLLFile,1,settings);
[stack_mol,stack_driver] = importQSS(stack_mol,stack_driver,QSSFile);


settings.proceed = 1; %to be removed
Plot3DAC(stack_mol, stack_driver, stack_output, settings)
PlotPotential(stack_mol, stack_driver, stack_output, settings)



