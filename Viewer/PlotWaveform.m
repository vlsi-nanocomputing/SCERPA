function out_fig = PlotWaveform(file, settings)

%import file
disp('Loading simulation table')
data = readtable('../OUTPUT_FILES/Additional_Information.txt')

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

%size
Ndrivers = length(in_rows(1,:));
Noutputs = length(out_rows(1,:));
N_subplot = Ndrivers + Noutputs;



figure(1),clc

%plot drivers
row = 1;
disp('Plotting inputs')
for dd = 1:Ndrivers
     
    subplot(N_subplot,1,row), hold on
    plot_data = getfield(data,char(availableRows(in_rows(dd))));
    plot(data.Time,plot_data,'-k','LineWidth',1, 'MarkerSize',10)
    ylabel(sprintf('%s [V]',char(availableRows(in_rows(dd)))))
    xticklabels('')
    xticks([])
   % ylim([-0.1 1.1])
%     grid on, grid minor
	 ax = gca;
    ax.BoxStyle = 'full';
    
    row = row+1;
    
    
end

disp('Plotting outputs')
%plot outputs
for oo = 1:Noutputs
    
    subplot(N_subplot,1,row), hold on
    plot_data = getfield(data,char(availableRows(out_rows(oo))));
    plot(data.Time,plot_data,'-k','LineWidth',1, 'MarkerSize',10)
    ylabel(sprintf('%s [V]',char(availableRows(out_rows(oo)))))
    if oo~=Noutputs
        xticklabels('')
        xticks([])
    else
        xlabel('Timestep')
    end
    
    
    ax = gca;
    ax.BoxStyle = 'full';
%     ylim([-0.1 1.1])
%     grid on, grid minor
    
%     %plot lines
%     for ll = out_rules
%         plot([ll ll],[-1 2],'--k')
%     end

    row = row+1;
    
end


end
