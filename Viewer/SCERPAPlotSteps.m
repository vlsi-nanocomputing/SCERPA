function SCERPAPlotSteps(plotSettings)

%set default settings
plotSettings.proceed=1; %be sure plotSettings exists, even if user didn't set anything
plotSettings = importSettings(plotSettings);

%% FROM SCERPA
load(strcat(plotSettings.out_path,'/simulation_output.mat'),'stack_mol')
load(strcat(plotSettings.out_path,'/simulation_output.mat'),'stack_output')
load(strcat(plotSettings.out_path,'/simulation_output.mat'),'stack_driver')

%delete old simulation files
figure_path = strcat(plotSettings.out_path,'/figures');
if ~exist(figure_path,'dir')
    mkdir (figure_path)
end
FigureDirectory = dir(figure_path);
FigureDirectory([FigureDirectory.isdir]) = [];
oldPics = fullfile(figure_path, {FigureDirectory.name});
try
    delete( oldPics{:} )
catch
    disp('No previous simulation found')
end

%% IMPORT ALL QSS
qssfiles = dir(strcat(plotSettings.out_path,'/*.qss'));
nfiles = length(qssfiles(:,1));

if plotSettings.plotList==0
    stepToPrint = 1:plotSettings.plotSpan:nfiles;
else
    stepToPrint = plotSettings.plotList;
    
end

% Plot additional information data

if plotSettings.plot_waveform == 1
    waveformFig = PlotWaveform(strcat(plotSettings.out_path,'/Additional_Information.txt'), plotSettings);
    if plotSettings.fig_saver == 1
        savefig(waveformFig,strcat(figure_path,'/waveformFig.fig'))
    end
    saveas(waveformFig,strcat(figure_path,'/waveformFig.jpg'))
end

% Plot steps
number_of_plots = length(stepToPrint);
plot_index = 0;

for ff=stepToPrint
    
    %import file
    filename = qssfiles(ff).name;
    %QSSFile = sprintf('../OUTPUT_FILES/%s',filename);
    QSSFile = fullfile(plotSettings.out_path,filename);
   
    [stack_mol,stack_driver] = importQSS(stack_mol,stack_driver,QSSFile);
    
    %user output
    plot_index = plot_index+1;
    fprintf("Plotting %s [%d/%d]... ",filename,plot_index,number_of_plots)
    
%     %settings
%     plotSettings.plot_molnum=0;
    
    %remove .qss extension for images names
    filename = cell2mat(regexp(qssfiles(ff).name,'\d*','Match'));
    %print
    if plotSettings.plot_3dfig == 1
        threeDfig = Plot3DAC(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(threeDfig,sprintf('%s/figures/threeFig%s.fig',plotSettings.out_path,filename))
        end
        saveas(threeDfig,sprintf('%s/figures/threeFig%s.jpg',plotSettings.out_path,filename))
    end
    
    if plotSettings.plot_potential == 1
        potFig = PlotPotential(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(potFig,sprintf('%s/figures/potFig%s.fig',plotSettings.out_path,filename))
        end
        saveas(potFig,sprintf('%s/figures/potFig%s.jpg',plotSettings.out_path,filename))
    end
  
    if plotSettings.plot_logic == 1
        logicFig = PlotLogic(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(logicFig,sprintf('%s/figures/logicFig%s.fig',plotSettings.out_path,filename))
        end
        saveas(logicFig,sprintf('%s/figures/logicFig%s.jpg',plotSettings.out_path,filename))
    end
    
    if plotSettings.plot_1DCharge== 1
        wireChargeFig = Plot1DCharge(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(wireChargeFig,sprintf('%s/figures/1DChargeFig%s.fig',plotSettings.out_path,filename))
        end
        saveas(wireChargeFig,sprintf('%s/figures/1DChargeFig%s.jpg',plotSettings.out_path,filename))
    end
    
    fprintf("DONE. \n")
    
end

