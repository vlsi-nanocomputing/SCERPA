function intermediatePlot(stack_mol, stack_driver, preV, V, V_driver)

%number of charge to be plotted
number_of_mols = stack_mol.num + stack_driver.num;

%creation of dataTable (x-name-preV-V-Vdriver-chargeDOT1-chargeDOT2)
dataTable{number_of_mols,7} = [];

%analyse molecules
for ii=1:stack_mol.num
    %get position
    positionOfMol = sscanf(string(stack_mol.stack(ii).position),'[%d %d %d]');
    dataTable{ii,1} = positionOfMol(3);
    
    %get name
    dataTable{ii,2} = stack_mol.stack(ii).identifier;
    
    %set voltages
    dataTable{ii,3} = preV(ii);
    dataTable{ii,4} = V(ii);
    dataTable{ii,5} = V_driver(ii);
    
    %get charge
    dataTable{ii,6} = stack_mol.stack(ii).charge(1).q;
    dataTable{ii,7} = stack_mol.stack(ii).charge(2).q;
    
end

%add drivers
for ii=1:stack_driver.num
    %dataTable index
    dd = ii + stack_mol.num;
    
    %get position
    positionOfMol = sscanf(string(stack_driver.stack(ii).position),'[%d %d %d]');
    dataTable{dd,1} = positionOfMol(3);
    
    %get name
    dataTable{dd,2} = char(stack_driver.stack(ii).identifier);
    
    %set voltages
    dataTable{dd,3} = NaN;
    dataTable{dd,4} = NaN;
    dataTable{dd,5} = NaN;
    
    %get charge
    dataTable{dd,6} = stack_driver.stack(ii).charge(1).q;
    dataTable{dd,7} = stack_driver.stack(ii).charge(2).q;
    
end

%sort molecules
dataTable = sortrows(dataTable,1);
    
%plot
figure(250000000)

%voltage
subplot(2,1,1), cla, hold on
    plot(cell2mat(dataTable(:,1)),cell2mat(dataTable(:,3)),'-r.','Linewidth',1,'MarkerSize',10)
    plot(cell2mat(dataTable(:,1)),cell2mat(dataTable(:,4)),'--b.','Linewidth',1,'MarkerSize',10)
    plot(cell2mat(dataTable(:,1)),cell2mat(dataTable(:,5)),'-k.','Linewidth',1,'MarkerSize',10)
    plot([0 number_of_mols-1],[0 0],'--k')
    legend ('Molecule input voltages (k-1)','Molecule input voltages (k)','Driver Voltage Contribution')
    grid on
    ylabel('Input Voltage [V]')
    xticks(cell2mat(dataTable(:,1)));xticklabels(string(dataTable(:,2)));xtickangle(90);
	set(gca,'TickLabelInterpreter','none')

%charge
subplot(2,1,2), cla
    hold on, grid on;
    plot(cell2mat(dataTable(:,1)),cell2mat(dataTable(:,6)),'-b.',cell2mat(dataTable(:,1)),cell2mat(dataTable(:,7)),'-r.','Linewidth',1,'MarkerSize',10);
    ylim([-0.2 1.2])
	xticks(cell2mat(dataTable(:,1)));xticklabels(string(dataTable(:,2)));xtickangle(90);
	set(gca,'TickLabelInterpreter','none')
	legend('Dot1','Dot2');
	ylabel('Aggregated charge'); 

drawnow




 end