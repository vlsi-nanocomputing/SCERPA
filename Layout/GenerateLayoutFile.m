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
function GenerateLayoutFile(QCA_circuit)
% The function GenerateLayoutFile checks the correctness of the inputs
% provided by the user in the <<QCA_circuit>>, creates the layout files and
% saves them in the Database directory.

%SCERPA version
SCERPA_version = 4;

%Echo initial SCERPA message
fprintf('Running SCERPA Version %1.f \n',SCERPA_version);
fprintf(' - Politecnico di Torino |  VLSI nanocomputing\n');
fprintf(' - www.vlsilab.polito.it\n\n');              

%% input management
if QCA_circuit.magcadImporter == 1
    [stack_driver, stack_mol, stack_output,QCA_circuit.dist_y,QCA_circuit.dist_z] = importQLL(QCA_circuit);
    qll_path = regexp(QCA_circuit.qllFile,'\','split');
    simulation_file_name = qll_path{end};
    if ~isfield(QCA_circuit,'magcadMolOverwrite')
        QCA_circuit.magcadMolOverwrite = 0;
    end
else
    QCA_circuit = importMatlab(QCA_circuit);
    % create the molecule and the driver stacks
    [stack_driver, stack_mol, stack_output] = GenerateStacks(QCA_circuit);
    simulation_file_name = 'matlabDrawing';
end


%evaluate circuit area
moleculePositions=[stack_mol.stack.position];
molecularArea = (stack_mol.num+stack_driver.num)*QCA_circuit.dist_y*QCA_circuit.dist_z/100;
size_z= max(moleculePositions(3:3:end  ))-min(moleculePositions(3:3:end  ))+1;
size_y= max(moleculePositions(2:3:end-1))-min(moleculePositions(2:3:end-1))+1;
chipArea = QCA_circuit.dist_y/10*size_y*QCA_circuit.dist_z/10*size_z;

%print circuit info
fprintf('Layout grid is: %d x %d \n',size_y,size_z)
fprintf('Intermolecular distance: %.2f nm\n',QCA_circuit.dist_z/10)
fprintf('Vertical intermolecular distance: %.2f nm\n',QCA_circuit.dist_y/10)
fprintf('Area occupied by molecules, by considering also drivers: %.2f nm^2\n',molecularArea)
fprintf('Chip area occupied by molecules: %.2f nm^2\n',chipArea)

%clock management
if ~isfield(QCA_circuit,'clockMode')
    QCA_circuit.clockMode = 'phase';
end

stack_clock = createClockTable(stack_mol,QCA_circuit);
     
            
%roughness management
if isfield(QCA_circuit,'substrate')
    if isfield(QCA_circuit.substrate,'PVenable')
        if QCA_circuit.substrate.PVenable == 1
            [stack_mol,stack_driver] = applyRoughness(stack_mol,stack_driver,QCA_circuit);
        end    
    end
end

%plot layout
if isfield(QCA_circuit,'plotLayout') && QCA_circuit.plotLayout == 1
    PlotLayout(stack_mol, stack_driver,stack_output)
end




%% Output file creation
% Check if the directory "Database" is present
if isfolder('Data')
    delete('Data/*');  % delete its content 
else
    mkdir('Data');     % if not present. It is created.
end

% save simulation filename
filename = fullfile('Data','Simulation_filename.txt');
fileID = fopen(filename,'wt');
fprintf(fileID,'%s', simulation_file_name);
fclose(fileID);

ff = 1;
id_num = 1;
mol_parameter = cell(12*stack_mol.num,1); %pre-allocation of comsol file
for ii=1:stack_mol.num

        % MOLECULE DATA
        k = (ii-1)*9 + 1;
        name = stack_mol.stack(ii).identifier;
        if QCA_circuit.magcadImporter == 0
            if mod(ii,2) == 0 %if ii is even
                qll_ID = sprintf('%04d%s',id_num,'b');
                id_num = id_num+1;
            else %if ii is odd
                qll_ID = sprintf('%04d%s',id_num,'a');
            end
        else
            qll_ID = stack_mol.stack(ii).identifier_qll;
        end
        
        moleculeType = stack_mol.stack(ii).molType;
        phase = stack_mol.stack(ii).phase;
        Vext = stack_mol.stack(ii).Vext;
        position = sprintf('[%i %i %i]',stack_mol.stack(ii).position(1),stack_mol.stack(ii).position(2),stack_mol.stack(ii).position(3));
        
        setting = {   'name:',          name,               '',                         'position:',            position;
                      'fake phase:',    phase,              '',                         'molType:',             moleculeType;
                      'Vext [V]:',      Vext,               '',                         'identifier_QLL',       qll_ID;
                      '',               'x_pos [A]:',       'y_pos [A]:',               'z_pos [A]:',           'charge:';
                      'dot1:',stack_mol.stack(ii).charge(1).x, stack_mol.stack(ii).charge(1).y, stack_mol.stack(ii).charge(1).z, stack_mol.stack(ii).charge(1).q;
                      'dot2:',stack_mol.stack(ii).charge(2).x, stack_mol.stack(ii).charge(2).y, stack_mol.stack(ii).charge(2).z, stack_mol.stack(ii).charge(2).q;
                      'dot3:',stack_mol.stack(ii).charge(3).x, stack_mol.stack(ii).charge(3).y, stack_mol.stack(ii).charge(3).z, stack_mol.stack(ii).charge(3).q;
                      'dot4:',stack_mol.stack(ii).charge(4).x, stack_mol.stack(ii).charge(4).y, stack_mol.stack(ii).charge(4).z, stack_mol.stack(ii).charge(4).q;
                      '%%%%%%%','%%%%%%%','%%%%%%%','%%%%%%%','%%%%%%%'};
        matrix_mol(k:k+8,1:5) = setting;
        
        % COMSOL FILE
        mol_parameter{ff,1}    = sprintf('%s_dot1_x   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(1).x); 
        mol_parameter{ff+1,1}  = sprintf('%s_dot1_y   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(1).y); 
        mol_parameter{ff+2,1}  = sprintf('%s_dot1_z   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(1).z); 
        mol_parameter{ff+3,1}  = sprintf('%s_dot2_x   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(2).x); 
        mol_parameter{ff+4,1}  = sprintf('%s_dot2_y   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(2).y);
        mol_parameter{ff+5,1}  = sprintf('%s_dot2_z   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(2).z);
        mol_parameter{ff+6,1}  = sprintf('%s_dot3_x   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(3).x);
        mol_parameter{ff+7,1}  = sprintf('%s_dot3_y   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(3).y); 
        mol_parameter{ff+8,1}  = sprintf('%s_dot3_z   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(3).z);
        mol_parameter{ff+9,1}  = sprintf('%s_dot4_x   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(4).x); 
        mol_parameter{ff+10,1} = sprintf('%s_dot4_y   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(4).y);
        mol_parameter{ff+11,1} = sprintf('%s_dot4_z   %f[nm]',stack_mol.stack(ii).identifier, 0.1*stack_mol.stack(ii).charge(4).z);
        ff = ff + 12;
end

    
%%% FILE FOR MOLECULE DATA
filename = fullfile('Data','Data_Molecule.mat');
fprintf('Creating molecule data file "%s"... ', filename)
save(filename,'matrix_mol');
fprintf('[DONE] \n')
    
% data drivers
id_num = id_num+1;
for ii=1:stack_driver.num
    k = (ii-1)*8 + 1;
    name = stack_driver.stack(ii).identifier;
    moleculeType = stack_driver.stack(ii).molType;
    position = sprintf('[%i %i %i]',stack_driver.stack(ii).position(1),stack_driver.stack(ii).position(2),stack_driver.stack(ii).position(3));
    
    if QCA_circuit.magcadImporter == 0
        if mod(ii,2) == 0 %if ii is even
                qll_ID = sprintf('%04d%s',id_num,'b');
                id_num = id_num+1;
            else %if ii is odd
                qll_ID = sprintf('%04d%s',id_num,'a');
        end
    else
        qll_ID = stack_driver.stack(ii).identifier_qll;
    end
    
    setting = {   'name:', name, '','position:',position;
                  'type:', moleculeType, '','identifier_QLL:',qll_ID;
                  '', 'x_pos [A]:', 'y_pos [A]:','z_pos [A]:','charge:';
                  'dot1:', stack_driver.stack(ii).charge(1).x, stack_driver.stack(ii).charge(1).y, stack_driver.stack(ii).charge(1).z, stack_driver.stack(ii).charge(1).q;
                  'dot2:', stack_driver.stack(ii).charge(2).x, stack_driver.stack(ii).charge(2).y, stack_driver.stack(ii).charge(2).z, stack_driver.stack(ii).charge(2).q;
                  'dot3:', stack_driver.stack(ii).charge(3).x, stack_driver.stack(ii).charge(3).y, stack_driver.stack(ii).charge(3).z, stack_driver.stack(ii).charge(3).q;
                  'dot4:', stack_driver.stack(ii).charge(4).x, stack_driver.stack(ii).charge(4).y, stack_driver.stack(ii).charge(4).z, stack_driver.stack(ii).charge(4).q;
                  '%%%%%%%','%%%%%%%','%%%%%%%','%%%%%%%','%%%%%%%'};
    matrix_driv(k:k+7,1:5) = setting; 
end

%Driver files
filename = fullfile('Data','Data_Driver.mat');
fprintf('Creating driver geometry file "%s"... ', filename)
save(filename,'matrix_driv');
fprintf('[DONE] \n')

filename = fullfile('Data','Values_Driver.mat');
fprintf('Creating driver value file "%s"... ', filename)
Values_Dr = QCA_circuit.Values_Dr;
save(filename,'Values_Dr');
fprintf('[DONE] \n')

%===================================================================================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DATA OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
id_num = id_num+1;
for ii=1:stack_output.num
    k = (ii-1)*8 + 1;
    name = stack_output.stack(ii).identifier;
    moleculeType = stack_output.stack(ii).molType;
    position = sprintf('[%i %i %i]',stack_output.stack(ii).position(1),stack_output.stack(ii).position(2),stack_output.stack(ii).position(3));
    
    if QCA_circuit.magcadImporter == 0
        if mod(ii,2) == 0 %if ii is even
                qll_ID = sprintf('%04d%s',id_num,'b');
                id_num = id_num+1;
            else %if ii is odd
                qll_ID = sprintf('%04d%s',id_num,'a');
        end
    else
        qll_ID = stack_output.stack(ii).identifier_qll;
    end
   
    setting = {   'name:', name, 'position:',position;
                  'type:', moleculeType, 'identifier_QLL:',qll_ID;
                  '', 'x_pos [A]:', 'y_pos [A]:','z_pos [A]:';
                  'dot1:', stack_output.stack(ii).charge(1).x, stack_output.stack(ii).charge(1).y, stack_output.stack(ii).charge(1).z;
                  'dot2:', stack_output.stack(ii).charge(2).x, stack_output.stack(ii).charge(2).y, stack_output.stack(ii).charge(2).z;
                  'dot3:', stack_output.stack(ii).charge(3).x, stack_output.stack(ii).charge(3).y, stack_output.stack(ii).charge(3).z;
                  'dot4:', stack_output.stack(ii).charge(4).x, stack_output.stack(ii).charge(4).y, stack_output.stack(ii).charge(4).z;
                  '%%%%%%%','%%%%%%%','%%%%%%%','%%%%%%%'};
    matrix_out(k:k+7,1:4) = setting; 
end
if stack_output.num == 0 % output may be not present
    matrix_out = cell(0,0);
end

%Output files
filename = 'Data/Data_Output.mat';
fprintf('Creating output geometry file "%s"... ', filename)
save(filename,'matrix_out');
fprintf('[DONE] \n')

%Clock file generation
filename = 'Data/Fake_Phases.mat';
fprintf('Creating clock value file "%s"... ', filename)
save(filename,'stack_clock');
fprintf('[DONE] \n')

fprintf('\nSCERPA is ready to start.\n\n')

end
