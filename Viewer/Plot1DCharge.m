function out_fig = Plot1DCharge(stack_mol, stack_driver, stack_output, settings)

%number of charge to be plotted
number_of_mols = stack_mol.num + stack_driver.num;

%creation of dataTable (x-name-chargeDOT1-chargeDOT2)
dataTable{number_of_mols,4} = [];

%analyse molecules
for ii=1:stack_mol.num
    %get position
    positionOfMol = sscanf(string(stack_mol.stack(ii).position),'[%d %d %d]');
    dataTable{ii,1} = positionOfMol(3);
    
    %get name
    dataTable{ii,2} = stack_mol.stack(ii).identifier;
    
    %get charge
    dataTable{ii,3} = stack_mol.stack(ii).charge(1).q;
    dataTable{ii,4} = stack_mol.stack(ii).charge(2).q;
    
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
    
    %get charge
    dataTable{dd,3} = stack_driver.stack(ii).charge(1).q;
    dataTable{dd,4} = stack_driver.stack(ii).charge(2).q;
    
end

dataTable = sortrows(dataTable,1);

out_fig = figure('visible','off');
hold on, grid on;
plot(cell2mat(dataTable(:,1)),cell2mat(dataTable(:,3)),'b--*',cell2mat(dataTable(:,1)),cell2mat(dataTable(:,4)),'r--*','Linewidth',4,'MarkerSize',10);
axis([0 number_of_mols -0.2 1.2])
xticks(cell2mat(dataTable(:,1)));xticklabels(string(dataTable(:,2)));xtickangle(90);
set(gca,'TickLabelInterpreter','none')
 
legend('Dot1','Dot2');title('Charge distribution');
xlabel('Molecule'); ylabel('Aggregated charge distribution Dot1 & Dot2'); 



 end