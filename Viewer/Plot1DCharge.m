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


%figure creation
dpi = 150;            % Resolution
sz = [0 0 2880 1800]; % Image size in pixels
out_fig = figure('visible','off','PaperUnits','inches','PaperPosition', sz/dpi,'PaperPositionMode','manual','position',[0 0  1920 1080]);
ha = gca;
uistack(ha,'bottom');
ha2=axes('OuterPosition',[0,0, 1,1],'Position',[0,0, 0.14,0.14]);
hIm = imshow(fullfile('..','Documentation','scerpa_logo.png'));
set(ha2,'handlevisibility','off','visible','off')

hold on, grid on;
plot(cell2mat(dataTable(:,1)),cell2mat(dataTable(:,3)),'b--*',cell2mat(dataTable(:,1)),cell2mat(dataTable(:,4)),'r--*','Linewidth',4,'MarkerSize',10);
axis([0 number_of_mols -0.2 1.2])
xticks(cell2mat(dataTable(:,1)));xticklabels(string(dataTable(:,2)));xtickangle(90);
set(gca,'TickLabelInterpreter','none')
legend('Dot1','Dot2');title('Charge distribution');
xlabel('Molecule'); ylabel('Aggregated charge distribution Dot1 & Dot2'); 


 end