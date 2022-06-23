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
function out_fig = PlotWaveform(file,driverStack,molStack,settings)

%import file
disp('Loading simulation table')
data = readtable(file);

%%%% further configuration parameters
% plotListDriver = [10 2 18 ];
% plotListOutputs = [2 3];
% V_th=0.1;
% out_rules = [35 95];

%analyse tabular data
availableRows = data.Properties.VariableNames;

%driver management
driver_index = (cellfun('isempty',regexp(availableRows,'driver_[0-9]*[b]')))==0;
in_rows = find(driver_index==1);

%output management
out_index = (cellfun('isempty',regexp(availableRows,'out_[0-z]*')))==0;
out_rows = find(out_index==1);

%output management
ck_index = (cellfun('isempty',regexp(availableRows,'CK_[0-z]*')))==0;
ck_rows = find(ck_index==1);

%figure creation
if settings.HQimage
    dpi = 150;            % Resolution
    sz = [0 0 2880 1800]; % Image size in pixels
    out_fig = figure('visible','off','PaperUnits','inches','PaperPosition', sz/dpi,'PaperPositionMode','manual','position',[0 0  1920 1080]);
    ha = gca;
    uistack(ha,'bottom');
    ha2=axes('OuterPosition',[0,0, 1,1],'Position',[0,0, 0.14,0.14]);
    hIm = imshow(fullfile('..','Documentation','scerpa_logo.png'));
    set(ha2,'handlevisibility','off','visible','off')
else
    out_fig = figure('visible','off');
    ha = gca;
    uistack(ha,'bottom');
    ha2=axes('OuterPosition',[0,0, 1,1],'Position',[0,0, 0.14,0.14]);
    [LogoImage, mapImage] = imread(fullfile('..','Documentation','scerpa_logo.png'));
    image(LogoImage)
    colormap (mapImage)
    set(ha2,'handlevisibility','off','visible','off')
end
    
%check availability of data
if isempty(in_rows) || isempty(out_rows) || isempty(ck_rows)
    warning('Input or Output or Clock data are missing the SCERPA output file, waveform plot cannot be generated. Check "dumpDriver", "dumpOutput" and "dumpClock" settings are set to "1" in the SCERPA input');

else
    %size
    Ndrivers = length(in_rows(1,:));
    Noutputs = length(out_rows(1,:));
    N_phase = length(unique([molStack.stack.phase]));
    
    N_subplot = Ndrivers + Noutputs + N_phase;
    plot_row = 1;
    

    %plot clock
    disp('Plotting clocks waveform')
    
    for cc = 1:N_phase
        % find a molecule belonging to phase cc
        molIndex = find([molStack.stack.phase] == cc);

        % obtain the qll identifier
        molIdentifierList = {molStack.stack.identifier_qll};
        molID = char(molIdentifierList(molIndex(1)));
        ck_fieldName = strcat('CK_',molID);

        % read the clock value from AdditionalInformation.txt
        ck_column_index = (cellfun('isempty',regexp(availableRows,ck_fieldName)))==0;
        ck_column = find(ck_column_index==1);

        % plot the clock waveform
        subplot(N_subplot,1,plot_row), hold on
        plot_data = getfield(data,char(availableRows(ck_column))); % plot the clock voltage
        plot(data.Time,plot_data,'-g','LineWidth',1.5, 'MarkerSize',10)
        ylabel(sprintf('CK_%d',cc),'Interpreter', 'none');
        yticks([min(plot_data) max(plot_data)]), ylim([(min(plot_data)-0.1) (max(plot_data)+0.1)]);
        xticklabels(''),  xlabel('')
        ax = set(get(gca,'ylabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right'); ax.BoxStyle = 'full'; box on; grid on;
     
        %next row
        plot_row = plot_row+1;
    end


    %plot drivers
    disp('Plotting inputs waveform')
    
    driverIdentifierList = {driverStack.stack.identifier};

    for dd = 1:Ndrivers
        % obtain the driver label identifier
        tmp = regexp(char(availableRows(in_rows(dd))),'driver_([0-9]*b)','tokens');
        cellDriverName = tmp{1,1};
        drLabel = char(driverIdentifierList(strcmp(cellDriverName, {driverStack.stack.identifier_qll})));
    
        subplot(N_subplot,1,plot_row), hold on
        %plot_data = getfield(data,char(availableRows(in_rows(dd))));
        plot_data = min(1,max(-1, getfield(data,char(availableRows(in_rows(dd)))))); % plot the difference between dot2.charge and dot1.charge [polarization]
        plot(data.Time,plot_data,'-r','LineWidth',1.5, 'MarkerSize',10)
        ylabel(drLabel,'Interpreter', 'none');
        yticklabels({'L','H'}), yticks([-1 1]), ylim([-1.1 1.1]);
        xticklabels(''),  xlabel('')
        ax = set(get(gca,'ylabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right'); ax.BoxStyle = 'full'; box on; grid on;

        %next row
        plot_row = plot_row+1;

    end

    %plot outputs
    disp('Plotting outputs waveform')

    for oo = 1:Noutputs
        
        subplot(N_subplot,1,plot_row), hold on
        %plot_data = getfield(data,char(availableRows(out_rows(oo))));
        plot_data = 1-1/0.1*min(0.1,max(-0.1,-getfield(data,char(availableRows(out_rows(oo))))));
        plot(data.Time,plot_data,'-b','LineWidth',1.5, 'MarkerSize',10)
        ylabel(sprintf('%s',char(availableRows(out_rows(oo)))),'Interpreter', 'none');
        yticklabels({'L','H'}), yticks([0 2]), ylim([-0.1 2.1]);
        ax = set(get(gca,'ylabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right'); ax.BoxStyle = 'full'; box on; grid on;

        %plot timesteps on the last plot
        if oo==Noutputs
            xlabel('Step')
        else
            xticklabels(''), xticks([])        
        end

        %next row
        plot_row = plot_row+1;

    end
   
    disp('Waveform plotted')


end


end
