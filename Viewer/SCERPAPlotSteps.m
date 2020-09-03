function SCERPAPlotSteps(plotSettings)

%set default settings
plotSettings.proceed=1; %be sure plotSettings exists, even if user didn't set anything
plotSettings = importSettings(plotSettings);

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
qssfiles = ls('../Algorithm/OUTPUT_FILES/*.qss');
nfiles = length(qssfiles(:,1));

if plotSettings.plotList==0
    stepToPrint = 1:plotSettings.plotSpan:nfiles;
else
    stepToPrint = plotSettings.plotList;
end

% Plot steps
for ff=stepToPrint
    
    %import file
    filename = sprintf(qssfiles(ff,:));
    QSSFile = sprintf('../Algorithm/OUTPUT_FILES/%s',filename);
    [stack_mol,stack_driver] = importQSS(stack_mol,stack_driver,QSSFile);
    
%     %settings
%     plotSettings.plot_molnum=0;

    %print
    if plotSettings.plot_3dfig == 1
        threeDfig = Plot3DAC(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(threeDfig,sprintf('EXPORT/threeFig%s.fig',filename))
        end
        saveas(threeDfig,sprintf('EXPORT/threeFig%s.jpg',filename))
    end
    
    if plotSettings.plot_potential == 1
        potFig = PlotPotential(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(potFig,sprintf('EXPORT/potFig%s.fig',filename))
        end
        saveas(potFig,sprintf('EXPORT/potFig%s.jpg',filename))
    end
  
    if plotSettings.plot_logic == 1
        logicFig = PlotLogic(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(logicFig,sprintf('EXPORT/logicFig%s.fig',filename))
        end
        saveas(logicFig,sprintf('EXPORT/logicFig%s.jpg',filename))
    end
    
    if plotSettings.plot_1DCharge== 1
        wireChargeFig = Plot1DCharge(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(wireChargeFig,sprintf('EXPORT/1DChargeFig%s.fig',filename))
        end
        saveas(wireChargeFig,sprintf('EXPORT/1DChargeFig%s.jpg',filename))
    end
    
    close all
    
end

