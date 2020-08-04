clear all

%% FROM SCERPA
load('../Algorithm/simulation_output.mat','stack_mol')
load('../Algorithm/simulation_output.mat','stack_output')
load('../Algorithm/simulation_output.mat','stack_driver')

%delete old simulation files
FigureDirectory = dir('EXPORT');
FigureDirectory([FigureDirectory.isdir]) = [];
oldPics = fullfile('EXPORT', {FigureDirectory.name});
try
    delete( oldPics{:} )
catch
    disp('No previous simulation found')
end

%% IMPORT ALL QSS
span=5;
qssfiles = ls('../Algorithm/OUTPUT_FILES/*.qss');
nfiles = length(qssfiles(:,1));

% Plot all QSS
for ff=1:span:nfiles
    
    %import file
    filename = sprintf(qssfiles(ff,:));
    QSSFile = sprintf('../Algorithm/OUTPUT_FILES/%s',filename);
    [stack_mol,stack_driver] = importQSS(stack_mol,stack_driver,QSSFile);
    
    %settings
    settings.plot_molnum=0;

    %print
    threeDfig = Plot3DAC(stack_mol, stack_driver, stack_output, settings);
    saveas(threeDfig,sprintf('EXPORT/threeFig%s.jpg',filename))
    
    potFig = PlotPotential(stack_mol, stack_driver, stack_output, settings);
    saveas(potFig,sprintf('EXPORT/potFig%s.jpg',filename))
    
    logicFig = PlotLogic(stack_mol, stack_driver, stack_output, settings);
    saveas(logicFig,sprintf('EXPORT/logicFig%s.jpg',filename))
    
    close all
    
end

