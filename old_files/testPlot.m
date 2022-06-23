clear all
close all

%% FROM SCERPA
% load('../Algorithm/simulation_output.mat','stack_mol')
% load('../Algorithm/simulation_output.mat','stack_output')
% load('../Algorithm/simulation_output.mat','stack_driver')

%% FROM FILE
stack.qllFile = '/mnt/44CEE091CEE07D14/scerpa/DemoFiles/threePhasesWire.qll';
QSSFile = '/mnt/44CEE091CEE07D14/PhD/tmp/threePhaseWire/SCERPA_OUTPUT_FILES/0002.qss';

addpath ../Algorithm/        
addpath ../Layout/        
stack.doubleMolDriverMode=1;
settings.plot_molnum=0;
[stack_driver,stack_mol,stack_output] = importQLL(stack);
[stack_mol,stack_driver] = importQSS(stack_mol,stack_driver,QSSFile);


settings.proceed = 1; %to be removed
threeDfig = Plot3DAC(stack_mol, stack_driver, stack_output, settings);
potFig = PlotPotential(stack_mol, stack_driver, stack_output, settings);
logicFig = PlotLogic(stack_mol, stack_driver, stack_output, settings);


