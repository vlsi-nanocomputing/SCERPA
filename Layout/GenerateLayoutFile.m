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
%get circuit layout
if ~isfield(QCA_circuit,'structure')
    disp('[SCERPA ERROR] No circuit (QCA_circuit.structure) defined in the input file!')
    return_code=1;
    return
end

%determine size of layout
[row, column] = size(QCA_circuit.structure);

fprintf('Layout grid is: %d x %d \n',row,column)

%molecules type definition
if ~isfield(QCA_circuit,'molecule')
    molType = '1'; % bisfe4_ox_counterionOnThiol
else
    switch(QCA_circuit.molecule)
        case 'bisfe4_ox_counterionOnCarbazole'
            molType = '0';
        case {'bisfe4_ox_counterionOnThiol','bisfe_4'} % backward compatibility
            molType = '1';
        case {'bisfe4_ox_counterionOnThiol_orca','bisfe_4_orca'} % backward compatibility
            molType = '2';
        case 'bisfe4_ox_noCounterion'
            molType = '3';
        case 'bisfe4_ox_noCounterion_TSA_2states'
            molType = '4';
        case 'bisfe4_ox_noCounterion_TSA_3states'
            molType = '5';
        case 'bisfe4_sym'
            molType = '6';
        case {'butane_ox_noCounterion','butane'} % backward compatibility
            molType = '7';
        case 'butane_ox_noCounterion_orca'
            molType = '8';
        case 'butaneCam' % backward compatibility
            molType = '9';
        case {'decatriene_ox_noCounterion','decatriene'} % backward compatibility
            molType = '10';
        case {'linear_mol_w7_a2000','linear_w7'} % backward compatibility
            molType = '11';
        case 'linear_mol_w7_a3000'
            molType = '12';
        case {'linear_mol_w9_a3000','linear_w9'} % backward compatibility
            molType = '13';
        case {'linear_mol_w95_a3000','linear_w95'} % backward compatibility
            molType = '14';
        case 'newMol_1'
            molType = '15';
        case 'newMol_2'
            molType = '16';
        case 'newMol_3'
            molType = '17';
        case 'newMol_4'
            molType = '18';
        otherwise
            disp('[SCERPA ERROR] Unknown molecule (circuit.molecule)')
            return_code = 1;
            return
    end
end

if ~isfield(QCA_circuit,'components') 
    % if no components field, create default components
    QCA_circuit.components = {'0'};
    for ii=1:row
        for jj=1:column
           QCA_circuit.components{ii,jj} = molType;
        end
    end    
else % if components field is present, check dimensions
    [row_component, column_component] = size(QCA_circuit.components);
    if row_component ~= row || column_component ~= column 
        disp('[SCERPA ERROR] Components matrix is not well defined (size is not consistent)!')
        return_code=1;
        return;
    end
end


%get intermolecular distances
if ~isfield(QCA_circuit,'dist_z')
    QCA_circuit.dist_z = 10;
end

if ~isfield(QCA_circuit,'dist_y') 
    % 10.145 is the distance between dot1 and dot2 of the bisferrocene
    QCA_circuit.dist_y = QCA_circuit.dist_z + 10.145; 
end

%fprintf('Molecule: %s\n',QCA_circuit.molecule)
fprintf('Intermolecular distance: %.2f nm\n',QCA_circuit.dist_z/10)
fprintf('Vertical intermolecular distance: %.2f nm\n',QCA_circuit.dist_y/10)

%rotation on x
if ~isfield(QCA_circuit,'rotation_x')
    QCA_circuit.rotation_x = {'0'};
    %create rotations (0)
    for ii=1:row
        for jj=1:column
           QCA_circuit.rotation_x{ii,jj} = '0';
        end
    end
else %check rotation matrix dimension
    [row_rotation, column_rotation] = size(QCA_circuit.rotation_x);
    if row_rotation ~= row || column_rotation ~= column 
        disp('[SCERPA ERROR] Rotation(x) matrix is not well defined (size is not consistent)!')
        return_code=1;
        return;
    end
end

%rotation on y
if ~isfield(QCA_circuit,'rotation_y')
    QCA_circuit.rotation_y =  {'0'};
    %create rotations (0)
    for ii=1:row
        for jj=1:column
           QCA_circuit.rotation_y{ii,jj} = '0';
        end
    end
else %check rotation matrix dimension
    [row_rotation, column_rotation] = size(QCA_circuit.rotation_y);
    if row_rotation ~= row || column_rotation ~= column 
        disp('[SCERPA ERROR] Rotation(y) matrix is not well defined (size is not consistent)!')
        return_code=1;
        return;
    end
end

%rotation on z
if ~isfield(QCA_circuit,'rotation_z')
    QCA_circuit.rotation_z =  {'0'};
    %create rotations (0)
    for ii=1:row
        for jj=1:column
           QCA_circuit.rotation_z{ii,jj} = '0';
        end
    end
else %check rotation matrix dimension
    [row_rotation, column_rotation] = size(QCA_circuit.rotation_z);
    if row_rotation ~= row || column_rotation ~= column 
        disp('[SCERPA ERROR] Rotation(z) matrix is not well defined (size is not consistent)!')
        return_code=1;
        return;
    end
end

%shift on x
if ~isfield(QCA_circuit,'shift_x')
    QCA_circuit.shift_x =  {'0'};
    %create shift x (0)
    for ii=1:row
        for jj=1:column
            QCA_circuit.shift_x{ii,jj} = '0';
        end
    end
else %check shift matrix dimension
    [row_shift, column_shift] = size(QCA_circuit.shift_x);
    if row_shift ~= row || column_shift ~= column 
        disp('[SCERPA ERROR] Shift(x) matrix is not well defined (size is not consistent)!')
        return_code=1;
        return
    end
end

%shift on y
if ~isfield(QCA_circuit,'shift_y')
    QCA_circuit.shift_y =  {'0'};
    %create shift y (0)
    for ii=1:row
        for jj=1:column
            QCA_circuit.shift_y{ii,jj} = '0';
        end
    end
else %check shift matrix dimension
    [row_shift, column_shift] = size(QCA_circuit.shift_y);
    if row_shift ~= row || column_shift ~= column 
        disp('[SCERPA ERROR] Shift(y) matrix is not well defined (size is not consistent)!')
        return_code=1;
        return
    end
end

%shift on z
if ~isfield(QCA_circuit,'shift_z')
    QCA_circuit.shift_z =  {'0'};
    %create shift z (0)
    for ii=1:row
        for jj=1:column
            QCA_circuit.shift_z{ii,jj} = '0';
        end
    end
else %check shift matrix dimension
    [row_shift, column_shift] = size(QCA_circuit.shift_z);
    if row_shift ~= row || column_shift ~= column 
        disp('[SCERPA ERROR] Shift(z) matrix is not well defined (size is not consistent)!')
        return_code=1;
        return
    end
end

%external voltage
if ~isfield(QCA_circuit,'Vext')
    QCA_circuit.Vext =  {'0'};
    %create Vext (0)
    for ii=1:row
        for jj=1:column
            QCA_circuit.Vext{ii,jj} = '0';
        end
    end
else %check Vext matrix dimension
    [row_Vext, column_Vext] = size(QCA_circuit.Vext);
    if row_Vext ~= row || column_Vext ~= column 
        disp('[SCERPA ERROR] Vext matrix is not well defined (size is not consistent)!')
        return_code=1;
        return
    end
end

%compatibility 
stack_phase = QCA_circuit.stack_phase;
Values_Dr = QCA_circuit.Values_Dr;

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


% create the molecule and the driver stacks
[stack_driver, stack_mol] = GenerateStacks(QCA_circuit);

%plot layout
Plotting(stack_mol, stack_driver)



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
if exist('Database') == 7    % ==7 because the function 'exist' used for directory has as output 7
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

tt = 1;
ff = 1;
id_num = 1;
for ii=1:stack_mol.num

        % MOLECULE DATA
        k = (ii-1)*12 + 1;
        name = stack_mol.stack(ii).identifier;
        
        if mod(ii,2) == 0 %if ii is even
            qll_ID = sprintf('mol%d%s',id_num,'b');
            id_num = id_num+1;
        else %if ii is odd
            qll_ID = sprintf('mol%d%s',id_num,'a');
        end
        
        moleculeType = stack_mol.stack(ii).molType;
        phase = stack_mol.stack(ii).phase;
        Vext = stack_mol.stack(ii).Vext;
        rotation_x = stack_mol.stack(ii).rotation_x;
        rotation_y = stack_mol.stack(ii).rotation_y;
        rotation_z = stack_mol.stack(ii).rotation_z;
        shift_x = stack_mol.stack(ii).shift_x;
        shift_y = stack_mol.stack(ii).shift_y;
        shift_z = stack_mol.stack(ii).shift_z;
        position = sprintf('[%i %i %i]',stack_mol.stack(ii).position(1),stack_mol.stack(ii).position(2),stack_mol.stack(ii).position(3));
        
        setting = {   'name:'    , name, '', 'position:', position;
                      'fake phase:'   , phase, '','molType:',moleculeType;
                      'shift_x [A]:',   'shift_y [A]:','shift_z [A]:','','Vext [V]:';
                      shift_x, shift_y, shift_z,'',Vext;
                      'rotation_x [�]:', 'rotation_y [�]:','rotation_z [�]:','','identifier_QLL';
                      rotation_x, rotation_y, rotation_z,'',qll_ID;
                      '',         'x_pos [A]:',   'y_pos [A]:','z_pos [A]:','charge:';
                      'dot1:',stack_mol.stack(ii).charge(1).x, stack_mol.stack(ii).charge(1).y, stack_mol.stack(ii).charge(1).z, stack_mol.stack(ii).charge(1).q;
                      'dot2:',stack_mol.stack(ii).charge(2).x, stack_mol.stack(ii).charge(2).y, stack_mol.stack(ii).charge(2).z, stack_mol.stack(ii).charge(2).q;
                      'dot3:',stack_mol.stack(ii).charge(3).x, stack_mol.stack(ii).charge(3).y, stack_mol.stack(ii).charge(3).z, stack_mol.stack(ii).charge(3).q;
                      'dot4:',stack_mol.stack(ii).charge(4).x, stack_mol.stack(ii).charge(4).y, stack_mol.stack(ii).charge(4).z, stack_mol.stack(ii).charge(4).q;
                      '%%%%%%%','%%%%%%%','%%%%%%%','%%%%%%%','%%%%%%%'};
        matrix_mol(k:k+11,1:5) = setting;
        
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
filename = sprintf('Database/Data_Molecule_%i.mat', tt);
fprintf('Creating molecule data file "%s"... ', filename)
save(filename,'matrix_mol');
fprintf('[DONE] \n')
    
%%% FILE FOR COMSOL
filename = [sprintf('Database/Comsol_data_%i.txt', tt)];
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
    
    if mod(ii,2) == 0 %if ii is even
            qll_ID = sprintf('in%d%s',id_num,'b'); 
            id_num = id_num+1;
        else %if ii is odd
            qll_ID = sprintf('in%d%s',id_num,'a');
    end
    
    moleculeType = stack_driver.stack(ii).molType;
    position = sprintf('[%i %i %i]',stack_driver.stack(ii).position(1),stack_driver.stack(ii).position(2),stack_driver.stack(ii).position(3));
        
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

for jj=1:stack_mol.num
    phase = str2num(stack_mol.stack(jj).phase);
    matrix_phase(jj,:) = [stack_mol.stack(jj).identifier num2cell(stack_phase(phase,:))];
end
% end



%Clock file generation
filename = 'Database/Fake_Phases.mat';
fprintf('Creating clock value file "%s"... ', filename)
save(filename,'matrix_phase');
fprintf('[DONE] \n')

fprintf('\nSCERPA is ready to start.\n\n')

return_code=0;

end
