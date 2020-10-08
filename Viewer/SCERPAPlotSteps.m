function SCERPAPlotSteps(plotSettings)

%set default settings
plotSettings.proceed=1; %be sure plotSettings exists, even if user didn't set anything
plotSettings = importSettings(plotSettings);

%% FROM SCERPA
load('../OUTPUT_FILES/simulation_output.mat','stack_mol')
load('../OUTPUT_FILES/simulation_output.mat','stack_output')
load('../OUTPUT_FILES/simulation_output.mat','stack_driver')

%delete old simulation files
FigureDirectory = dir('../OUTPUT_FILES/viewer');
FigureDirectory([FigureDirectory.isdir]) = [];
oldPics = fullfile('../OUTPUT_FILES/viewer', {FigureDirectory.name});
try
    delete( oldPics{:} )
catch
    disp('No previous simulation found')
end

%% IMPORT ALL QSS
qssfiles = ls('../OUTPUT_FILES/*.qss');
nfiles = length(qssfiles(:,1));

if plotSettings.plotList==0
    stepToPrint = 1:plotSettings.plotSpan:nfiles;
else
    stepToPrint = plotSettings.plotList;
    
end

% Plot additional information data

if plotSettings.plot_waveform == 1
    waveformFig = PlotWaveform('../OUTPUT_FILES/Additional_Information.txt', plotSettings);
    if plotSettings.fig_saver == 1
        savefig(waveformFig,'../OUTPUT_FILES/viewer/waveformFig.fig')
    end
    saveas(waveformFig,'../OUTPUT_FILES/viewer/waveformFig.jpg')
end

% Plot steps
number_of_plots = length(stepToPrint);
plot_index = 0;

for ff=stepToPrint
    
    %import file
    filename = sprintf(qssfiles(ff,:));
    QSSFile = sprintf('../OUTPUT_FILES/%s',filename);
    [stack_mol,stack_driver] = importQSS(stack_mol,stack_driver,QSSFile);
    
    %user output
    plot_index = plot_index+1;
    fprintf("Plotting %s [%d/%d]... ",filename,plot_index,number_of_plots)
    
%     %settings
%     plotSettings.plot_molnum=0;

    %print
    if plotSettings.plot_3dfig == 1
        threeDfig = Plot3DAC(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(threeDfig,sprintf('../OUTPUT_FILES/viewer/threeFig%s.fig',filename))
        end
        saveas(threeDfig,sprintf('../OUTPUT_FILES/viewer/threeFig%s.jpg',filename))
    end
    
    if plotSettings.plot_potential == 1
        potFig = PlotPotential(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(potFig,sprintf('../OUTPUT_FILES/viewer/potFig%s.fig',filename))
        end
        saveas(potFig,sprintf('../OUTPUT_FILES/viewer/potFig%s.jpg',filename))
    end
  
    if plotSettings.plot_logic == 1
        logicFig = PlotLogic(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(logicFig,sprintf('../OUTPUT_FILES/viewer/logicFig%s.fig',filename))
        end
        saveas(logicFig,sprintf('../OUTPUT_FILES/viewer/logicFig%s.jpg',filename))
    end
    
    if plotSettings.plot_1DCharge== 1
        wireChargeFig = Plot1DCharge(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(wireChargeFig,sprintf('../OUTPUT_FILES/viewer/1DChargeFig%s.fig',filename))
        end
        saveas(wireChargeFig,sprintf('../OUTPUT_FILES/viewer/1DChargeFig%s.jpg',filename))
    end
    
    fprintf("DONE. \n")
    
end

