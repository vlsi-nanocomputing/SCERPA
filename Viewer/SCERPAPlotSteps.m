%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%       Self-Consistent Electrostatic Potential Algorithm (SCERPA)         %
%                                                                          %
%       VLSI Nanocomputing Research Group                                  %
%       Dept. of Electronics and Telecommunications                        %
%       Politecnico di Torino, Turin, Italy                                %
%       (https://www.vlsilab.polito.it/)                                   %
%                                                                          %
%       People [people you may contact for info]                           %
%         Yuri Ardesi (yuri.ardesi@polito.it)                              %
%         Giuliana Beretta (giuliana.beretta@polito.it)                    %
%                                                                          %
%       Supervision: Gianluca Piccinini, Mariagrazia Graziano              %
%                                                                          %
%       Relevant pubblications doi: 10.1109/TCAD.2019.2960360              %
%                                   10.1109/TVLSI.2020.3045198             %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SCERPAPlotSteps(plotSettings)

if ~exist('plotSettings','var')
    plotSettings=0;
end

%set default settings
%plotSettings.proceed=1; %be sure plotSettings exists, even if user didn't set anything
plotSettings = importSettings(plotSettings);

%% FROM SCERPA
load(fullfile(plotSettings.out_path,'simulation_output.mat'),'stack_mol')
load(fullfile(plotSettings.out_path,'simulation_output.mat'),'stack_output')
load(fullfile(plotSettings.out_path,'simulation_output.mat'),'stack_driver')

%delete old simulation files
figure_path = fullfile(plotSettings.out_path,'figures');
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

if plotSettings.HQimage 
    warning('High quality images, simulation will last longer.')
end

% Plot additional information data

if plotSettings.plot_waveform == 1
    waveformFig = PlotWaveform(fullfile(plotSettings.out_path,'Additional_Information.txt'), stack_driver,stack_mol,plotSettings);
    if plotSettings.fig_saver == 1
        savefig(waveformFig,fullfile(figure_path,'waveformFig.fig'))
    end
    saveas(waveformFig,fullfile(figure_path,'waveformFig.jpg'))
    %print('-r150','-dtiff','histogram.tiff');
end

% Plot steps
number_of_plots = length(stepToPrint);
plot_index = 0;

for ff=stepToPrint
    
    %import file
    filename = qssfiles(ff).name;
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
            savefig(threeDfig,fullfile(plotSettings.out_path,'figures',['threeFig' filename '.fig']))
        end
        saveas(threeDfig,fullfile(plotSettings.out_path,'figures',['threeFig' filename '.jpg']))
    end
    
    if plotSettings.plot_potential == 1
        potFig = PlotPotential(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(potFig,fullfile(plotSettings.out_path,'figures',['potFig' filename '.fig']))
        end
        saveas(potFig,fullfile(plotSettings.out_path,'figures',['potFig' filename '.jpg']))
    end
  
    if plotSettings.plot_logic == 1
        logicFig = PlotLogic(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(logicFig,fullfile(plotSettings.out_path,'figures',['logicFig' filename '.fig']))
        end
        saveas(logicFig,fullfile(plotSettings.out_path,'figures',['logicFig' filename '.jpg']))
    end
    
    if plotSettings.plot_1DCharge== 1
        wireChargeFig = Plot1DCharge(stack_mol, stack_driver, stack_output, plotSettings);
        if plotSettings.fig_saver == 1
            savefig(wireChargeFig,fullfile(plotSettings.out_path,'figures',['1DChargeFig' filename '.fig']))
        end
        saveas(wireChargeFig,fullfile(plotSettings.out_path,'figures',['1DChargeFig' filename '.jpg']))
    end
    
    fprintf("DONE. \n")
    
end

