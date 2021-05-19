function return_code = GenerateLayoutFile(QCA_circuit)
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
    [stack_driver, stack_mol, stack_output] = importQLL(QCA_circuit);
    qll_path = regexp(QCA_circuit.qllFile,'\','split');
    simulation_file_name = qll_path{end};
else
    QCA_circuit = importMatlab(QCA_circuit);
    % create the molecule and the driver stacks
    [stack_driver, stack_mol, stack_output] = GenerateStacks(QCA_circuit);
    simulation_file_name = 'matlabDrawing';
end

%compatibility 
Values_Dr = QCA_circuit.Values_Dr;

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
    Plotting(stack_mol, stack_driver,stack_output)
end
%% creation of the layout


% [m,n]=size(QCA_circuit.structure);
% [X,Y] = meshgrid(0:dist_y:(n-1)*dist_y,0:dist_z:(m-1)*dist_z);
% Z = (1/2)*sin(X/50) - (Y/80).^2;
% plot3(X,Y,Z)
% QCASurface=Z;
% QCASurface=[0  0  0 0 0  0  0 0 0  0  0 0 0  0  0 0 0   ];
%||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||
% process_variation='off';
%||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||*||
%\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\%
%----------------------------auto variation---------------------------%
%         auto_variations='off';
%\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\./.\%        
%|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|%
%-------------------------electrode variaiton-------------------------%
%         electrode_variation='off';
%|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|.|%
% Number of Process Variations
%     kind_proc_variaiton = 'Gaussian';
%     num_processor = 1;
% Kind of Process Variations : Gaussian Distribution
% if strcmp(process_variation,'on')
%     if strcmp(auto_variations,'on')
%     pv.rotation_x.make = 'map';     % X Rotation
%         pv.rotation_x.mu = 10;
%         pv.rotation_x.sigma = 0.1;   
%     pv.rotation_y.make = 'map';     % Y Rotation
%         pv.rotation_y.mu = 0;
%         pv.rotation_y.sigma = 5;
%     pv.rotation_z.make = 'map';     % Z Rotation
%         pv.rotation_z.mu = 0;
%         pv.rotation_z.sigma = 1;   
%     pv.shift_x.make  = 'map';        % X Shift
%         pv.shift_x.mu = 0;
%         pv.shift_x.sigma = 0.2;
%     pv.shift_y.make  = 'map';        % Y Shift
%         pv.shift_y.mu = 0;
%         pv.shift_y.sigma = 0.2;
%     pv.shift_z.make  = 'map';        % Z Shift
%         pv.shift_z.mu = 0;
%         pv.shift_z.sigma = 1;
%     pv.charge.make   = 'no';        % Charge --- NOISE??????      
%         pv.charge.mu = 0;           % the values are set in "initial_charge" variable.
%         pv.charge.sigma = 0.01;
%     end
%     if strcmp(auto_variations,'off')
%         pv.rotation_x.make = 'on';     % X Rotation
%         pv.rotation_x.mu = 10;
%         pv.rotation_x.sigma = 90;   
%     pv.rotation_y.make = 'on';     % Y Rotation
%         pv.rotation_y.mu = 0;
%         pv.rotation_y.sigma = 90;
%     pv.rotation_z.make = 'on';     % Z Rotation
%         pv.rotation_z.mu = 0;
%         pv.rotation_z.sigma = 90;   
%     pv.shift_x.make  = 'on';        % X Shift
%         pv.shift_x.mu = 0;
%         pv.shift_x.sigma = 4;
%     pv.shift_y.make  = 'on';        % Y Shift
%         pv.shift_y.mu = 0;
%         pv.shift_y.sigma = 4;
%     pv.shift_z.make  = 'on';        % Z Shift
%         pv.shift_z.mu = 0;
%         pv.shift_z.sigma = 4;
%     pv.charge.make   = 'no';        % Charge --- NOISE??????      
%         pv.charge.mu = 0;           % the values are set in "initial_charge" variable.
%         pv.charge.sigma = 0.01;
%     end
% else
%     pv.rotation_x.make = 'no';     % X Rotation
%         pv.rotation_x.mu = 10;
%         pv.rotation_x.sigma = 0.1;   
%     pv.rotation_y.make = 'no';     % Y Rotation
%         pv.rotation_y.mu = 0;
%         pv.rotation_y.sigma = 5;
%     pv.rotation_z.make = 'no';     % Z Rotation
%         pv.rotation_z.mu = 0;
%         pv.rotation_z.sigma = 1;   
%     pv.shift_x.make  = 'no';        % X Shift
%         pv.shift_x.mu = 0;
%         pv.shift_x.sigma = 0.2;
%     pv.shift_y.make  = 'no';        % Y Shift
%         pv.shift_y.mu = 0;
%         pv.shift_y.sigma = 0.2;
%     pv.shift_z.make  = 'no';        % Z Shift
%         pv.shift_z.mu = 0;
%         pv.shift_z.sigma = 1;
%     pv.charge.make   = 'no';        % Charge --- NOISE??????      
%         pv.charge.mu = 0;           % the values are set in "initial_charge" variable.
%         pv.charge.sigma = 0.01;
% end        

% if strcmp(auto_variations,'on')
%     cd '.\Process Variation';
%     output_position = AuMapMatrix(AuMapName, 3);
%     final_variations( AuMapName, output_position, QCA_circuit.structure, QCASurface )
%     cd '..';
% end



% if strcmp(electrode_variation,'on')
%     
%     %if  electrode_variation do all the calculation here
%     
%         reset_switch_matrix=importdata('reset_switch.txt');
%         switch_hold_matrix =importdata('switch_hold.txt');
%         hold_release_matrix =importdata('hold_release.txt');
%         release_reset_matrix =importdata('release_reset.txt');
%         reset_matrix =importdata('reset.txt');
%         switched_matrix  =importdata('switched.txt');
%         
%     for electrod_variation_index= 1:stack_mol.num
%         %here read external txt files and store one row for cycle in the
%         %following vectors
%         
%          
%         Not_Enabled =   { nan   nan   nan    nan  nan   nan   nan    nan };
%         reset_switch =  reset_switch_matrix(electrod_variation_index,:);   % Gradual Clock Changing -2V ->  0V
%         switch_hold =   switch_hold_matrix(electrod_variation_index,:);   % Gradual Clock Changing  0V -> +2V
%         hold_release =  hold_release_matrix(electrod_variation_index,:);   % Gradual Clock Changing +2V ->  0V
%         release_reset = release_reset_matrix(electrod_variation_index,:);   % Gradual Clock Changing  0V -> -2V
%         reset =         reset_matrix(electrod_variation_index,:);   % Just Reset State -2V
%         switched  =     switched_matrix(electrod_variation_index,:);   % Just Reset State -2V
%         
% %stack_phase(1,:) = [    -2     reset_switch,    switch_hold,     hold_release,    release_reset,      reset,           reset,             reset      ];
% stack_phase(1,:) = [    -2     reset_switch,    switch_hold,     hold_release,    release_reset,      reset,           reset,             reset      ];
% stack_phase(2,:) = [    -2        reset,        reset_switch,    switch_hold,     hold_release,    release_reset,      reset,             reset      ];
% stack_phase(3,:) = [    -2        reset,           reset,        reset_switch,    switch_hold ,    hold_release,    release_reset,        reset      ];
% stack_phase(4,:) = [    -2        reset,           reset,           reset,        reset_switch,    switch_hold,     hold_release,     release_reset  ];
% stack_phase(5,:) = [    -2        reset,           reset,           reset,           reset,        reset_switch,    switch_hold ,     hold_release   ];
% stack_phase(6,:) = [    -2        reset,           reset,           reset,           reset,           reset,        reset_switch,     switch_hold    ];
%         
%         phase = stack_mol.stack(electrod_variation_index).phase(1);
%         matrix_phase(electrod_variation_index,:) = [stack_mol.stack(electrod_variation_index).identifier num2cell(stack_phase(str2num(phase),:))];  
% 
%     end
% else    
%                      time1  |   time 2->9   |   time 10->17  |   time 18->25  |   time 26->33  |   time 26->33  |   time 34->41  |   time 42->49  |    
% stack_phase(1,:) = [2];% -2 2 2];
% stack_phase(2,:) = [    -2        reset,        reset_switch,    switch_hold,     hold_release,    release_reset,      reset,             reset      ];
% stack_phase(3,:) = [    -2        reset,           reset,        reset_switch,    switch_hold ,    hold_release,    release_reset,        reset      ];
% stack_phase(4,:) = [    -2        reset,           reset,           reset,        reset_switch,    switch_hold,     hold_release,     release_reset  ];
% stack_phase(5,:) = [    -2        reset,           reset,           reset,           reset,        reset_switch,    switch_hold ,     hold_release   ];
% stack_phase(6,:) = [    -2        reset,           reset,           reset,           reset,           reset,        reset_switch,     switch_hold    ];
% end




%% Output file creation
% Check if the directory "Database" is present
if exist('Database','dir')
    delete('Database/*');  % delete its content 
else
    mkdir('Database');     % if not present. It is created.
end

%===================================================================================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DATA MOLECULE & PROCESS VARIATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for tt=1:num_processor
%     ff = 1;
%     run('Process Variation/Process_Variations.m');
% %     close all;
%     Plotting(stack_mol_PV, stack_driver, dot_position, dist_z, dist_y, QCA_circuit.structure, QCA_circuit.rotation, QCASurface, electrode_variation)

% save simulation filename
filename = sprintf('Database/Simulation_filename.txt');
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
filename = sprintf('Database/Data_Molecule.mat');
fprintf('Creating molecule data file "%s"... ', filename)
save(filename,'matrix_mol');
fprintf('[DONE] \n')
    
%%% FILE FOR COMSOL
filename = sprintf('Database/Comsol_data.txt');
fprintf('Creating COMSOL file "%s"... ', filename)
fileID = fopen(filename,'wt');
fprintf(fileID,'%s\n', mol_parameter{:,1});
fclose(fileID);
fprintf('[DONE] \n')


%===================================================================================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DATA DRIVERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
id_num = 1;
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
filename = 'Database/Data_Driver.mat';
fprintf('Creating driver geometry file "%s"... ', filename)
save(filename,'matrix_driv');
fprintf('[DONE] \n')

filename = 'Database/Values_Driver.mat';
fprintf('Creating driver value file "%s"... ', filename)
save(filename,'Values_Dr');
fprintf('[DONE] \n')

%===================================================================================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DATA OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
id_num = 1;
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
filename = 'Database/Data_Output.mat';
fprintf('Creating output geometry file "%s"... ', filename)
save(filename,'matrix_out');
fprintf('[DONE] \n')


    
% string_dr_line_format= '%s'; %string format creation
% for ss_line=1:length(Values_Dr(1,:))-1
%     string_dr_line_format = strcat(string_dr_line_format,', %s');
% end
% string_dr_line_format = strcat(string_dr_line_format,'\n');  
% 
% filename = sprintf('Database/Values_Driver.csv', tt);
% valuedriver_file = fopen(filename,'w');
% for line = 1:length(Values_Dr(:,1))
%    fprintf(valuedriver_file,string_dr_line_format,Values_Dr{line,:});
% endD
% fclose(valuedriver_file);

%===================================================================================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DATA FAKE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if strcmp(electrode_variation,'on')
%         
% %in this case all the calculation hve been already calculated before
%         
% else    

% matrix_phase = cell(stack_mol.num,length(stack_phase(phase,:)) + 1);
% for jj=1:stack_mol.num
%     phase = stack_mol.stack(jj).phase;
%     matrix_phase(jj,:) = [stack_mol.stack(jj).identifier num2cell(stack_phase(phase,:))];
% end

% end

%Clock file generation
filename = 'Database/Fake_Phases.mat';
fprintf('Creating clock value file "%s"... ', filename)
save(filename,'stack_clock');
fprintf('[DONE] \n')

fprintf('\nSCERPA is ready to start.\n\n')

return_code=0;

end
