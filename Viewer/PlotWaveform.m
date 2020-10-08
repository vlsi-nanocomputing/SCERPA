function out_fig = PlotWaveform(file, settings)

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

%size
Ndrivers = length(in_rows(1,:));
Noutputs = length(out_rows(1,:));
N_subplot = Ndrivers + Noutputs;

%figure creation
out_fig = figure('visible','off');

%plot drivers
row = 1;
disp('Plotting inputs')

for dd = 1:Ndrivers
     
    subplot(N_subplot,1,row), hold on
    %plot_data = getfield(data,char(availableRows(in_rows(dd))));
    plot_data = max(-1,min(1,- getfield(data,char(availableRows(in_rows(dd))))));
    plot(data.Time,plot_data,'-k','LineWidth',1, 'MarkerSize',10)
    ylabel(sprintf('%s',char(availableRows(in_rows(dd)))),'Interpreter', 'none');
    yticklabels({'L','H'}), yticks([-1 1]), ylim([-1.1 1.1]);
    xticklabels(''), xticks([])
    ax = gca; ax.BoxStyle = 'full'; box on; grid on;
    
    %next row
    row = row+1;
    
end

%plot outputs
disp('Plotting outputs')

for oo = 1:Noutputs
    
    subplot(N_subplot,1,row), hold on
    %plot_data = getfield(data,char(availableRows(out_rows(oo))));
    plot_data = 1/0.1*max(-0.1,min(0.1,getfield(data,char(availableRows(out_rows(oo))))));
    plot(data.Time,plot_data,'-k','LineWidth',1, 'MarkerSize',10)
    ylabel(sprintf('%s',char(availableRows(out_rows(oo)))),'Interpreter', 'none');
    yticklabels({'L','H'}), yticks([-1 1]), ylim([-1.1 1.1]);
    xticklabels(''), xticks([])
    ax = gca; ax.BoxStyle = 'full'; box on; grid on;

    %plot timesteps on the last plot
    if oo==Noutputs
        xlabel('Timestep')
    else
        xticklabels(''), xticks([])        
    end
    
    %next row
    row = row+1;
    
end


end
