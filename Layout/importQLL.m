function [stack_driver, stack_mol, stack_output] = importQLL(QCA_circuit)

xmlStruct = xmlRead(QCA_circuit.qllFile);

if ~isfield(QCA_circuit,'dist_y') 
    dist_y = 2*xmlStruct.dist_z;
end

%% create driver stack
if QCA_circuit.doubleMolDriverMode == 1
    stack_driver.num = 2*length(xmlStruct.driver.name);
else
    stack_driver.num = length(xmlStruct.driver.name);
end
for ii = 1:length(xmlStruct.driver.name)
    if QCA_circuit.doubleMolDriverMode == 1
        stack_driver.stack(2*ii).position = [xmlStruct.driver.z(ii),xmlStruct.driver.y(ii),2*xmlStruct.driver.x(ii)+1];
        stack_driver.stack(2*ii-1).position = [xmlStruct.driver.z(ii),xmlStruct.driver.y(ii),2*xmlStruct.driver.x(ii)];
        
        %set molType for the Drivers: driver is automatically assigned to first available molecule
        stack_driver.stack(2*ii).molType = xmlStruct.molecules(1).molType;
        stack_driver.stack(2*ii-1).molType = xmlStruct.molecules(1).molType;
        
        [initial_charge, dot_position, draw_association] = GetMoleculeData(num2str(stack_driver.stack(2*ii).molType));
        number_of_charges = length(dot_position(:,1));

        %effective position of the cell (necesssary for rotation implementation)
        y_cell_center = dist_y * xmlStruct.driver.y(ii); %position of cell center
        z_cell_center = 2*xmlStruct.dist_z *(0.5+xmlStruct.driver.x(ii));
        
        theta_driver = xmlStruct.driver.angle(ii);
        %update driver charge and positions (mol 1)
        for cc=1:number_of_charges
            stack_driver.stack(2*ii).charge(cc).x = dot_position(cc,1); 
            stack_driver.stack(2*ii-1).charge(cc).x = dot_position(cc,1); 

            %relative position of the charge in the cell
            y_dot_in_cell = dot_position(cc,2); %position inside the cell
            z_dot_in_cell_b = dot_position(cc,3) + xmlStruct.dist_z*0.5  ;     
            z_dot_in_cell_a = dot_position(cc,3) - xmlStruct.dist_z*0.5  ;     

            stack_driver.stack(2*ii).charge(cc).y = y_dot_in_cell*cosd(theta_driver) + z_dot_in_cell_b*sind(theta_driver) +  y_cell_center;
            stack_driver.stack(2*ii-1).charge(cc).y = y_dot_in_cell*cosd(theta_driver) + z_dot_in_cell_a*sind(theta_driver) +  y_cell_center;
            
            stack_driver.stack(2*ii).charge(cc).z = z_dot_in_cell_b*cosd(theta_driver) - y_dot_in_cell*sind(theta_driver) + z_cell_center; 
            stack_driver.stack(2*ii-1).charge(cc).z = z_dot_in_cell_a*cosd(theta_driver) - y_dot_in_cell*sind(theta_driver) + z_cell_center; 
            
            stack_driver.stack(2*ii).charge(cc).q = initial_charge(cc);
            stack_driver.stack(2*ii-1).charge(cc).q = initial_charge(cc);
        
        end 
        stack_driver.stack(2*ii).association = draw_association;
        stack_driver.stack(2*ii-1).association = draw_association;
        
        %set driver identifier    
        stack_driver.stack(2*ii).identifier = xmlStruct.driver.name{ii};
        stack_driver.stack(2*ii-1).identifier = sprintf('%s_c',xmlStruct.driver.name{ii}); 
        
        stack_driver.stack(2*ii).identifier_qll = sprintf('%.4db',str2double(xmlStruct.driver.id{ii}));
        stack_driver.stack(2*ii-1).identifier_qll = sprintf('%.4da',str2double(xmlStruct.driver.id{ii}));
                
    else %if not double mol driver mode
        stack_driver.stack(ii).position = [xmlStruct.driver.z(ii),xmlStruct.driver.y(ii),2*xmlStruct.driver.x(ii)+1];
        
        %set molType for the Drivers: driver is automatically assigned to first available molecule
        stack_driver.stack(ii).molType = xmlStruct.molecules(1).molType;
        [initial_charge, dot_position, draw_association] = GetMoleculeData(num2str(stack_driver.stack(ii).molType));
        number_of_charges = length(dot_position(:,1));

        %effective position of the cell (necesssary for rotation implementation)
        y_cell_center = dist_y * xmlStruct.driver.y(ii); %position of cell center
        z_cell_center = 2*xmlStruct.dist_z *(0.5+xmlStruct.driver.x(ii));
        
        theta_driver = xmlStruct.driver.angle(ii);
        %update driver charge and positions (mol 1)
        for cc=1:number_of_charges
            stack_driver.stack(ii).charge(cc).x = dot_position(cc,1); 
            
            %relative position of the charge in the cell
            y_dot_in_cell = dot_position(cc,2); %position inside the cell
            z_dot_in_cell = dot_position(cc,3) + xmlStruct.dist_z*0.5  ;     
            
            stack_driver.stack(ii).charge(cc).y = y_dot_in_cell*cosd(theta_driver) + z_dot_in_cell*sind(theta_driver) +  y_cell_center;
            stack_driver.stack(ii).charge(cc).z = z_dot_in_cell*cosd(theta_driver) - y_dot_in_cell*sind(theta_driver) + z_cell_center; 
            stack_driver.stack(ii).charge(cc).q = initial_charge(cc);
            
        end 
        stack_driver.stack(ii).association = draw_association;
        
        %set driver identifier    
        stack_driver.stack(ii).identifier = xmlStruct.driver.name{ii};
        stack_driver.stack(ii).identifier_qll = sprintf('%.4d',str2double(xmlStruct.driver.id{ii}));
    end
end   
     
%% create output stack: output are single molecules by default
stack_output.num = length(xmlStruct.output.name);
for ii = 1:stack_output.num
    stack_output.stack(ii).position = [xmlStruct.output.z(ii),xmlStruct.output.y(ii),2*xmlStruct.output.x(ii)+1];
        
    %set molType for the output: output is automatically assigned to first available molecule
    stack_output.stack(ii).molType = xmlStruct.molecules(1).molType;
    [~, dot_position, draw_association] = GetMoleculeData(num2str(stack_output.stack(ii).molType));
    number_of_charges = length(dot_position(:,1));

    %effective position of the cell (necesssary for rotation implementation)
    y_cell_center = dist_y * xmlStruct.output.y(ii); %position of cell center
    z_cell_center = 2*xmlStruct.dist_z *(0.5+xmlStruct.output.x(ii));

    theta_output = xmlStruct.output.angle(ii);
    %update output charge and positions (mol 1)
    for cc=1:number_of_charges
        stack_output.stack(ii).charge(cc).x = dot_position(cc,1); 

        %relative position of the charge in the cell
        y_dot_in_cell = dot_position(cc,2); %position inside the cell
        z_dot_in_cell = dot_position(cc,3) - xmlStruct.dist_z*0.5  ;     

        stack_output.stack(ii).charge(cc).y = y_dot_in_cell*cosd(theta_output) + z_dot_in_cell*sind(theta_output) +  y_cell_center;
        stack_output.stack(ii).charge(cc).z = z_dot_in_cell*cosd(theta_output) - y_dot_in_cell*sind(theta_output) + z_cell_center; 
        
    end
    stack_output.stack(ii).association = draw_association;
        
    %set driver identifier    
    stack_output.stack(ii).identifier = xmlStruct.output.name{ii};
    stack_output.stack(ii).identifier_qll = sprintf('%.4d',str2double(xmlStruct.output.id{ii}));
end 

%% create molecule stack 
stack_mol.num = 0;
for ii = 1:length(xmlStruct.molecules)
    %verify the presence of shifts or rotations
    theta_cell = xmlStruct.molecules(ii).angle;
    if ~isfield(xmlStruct.molecules(ii),'xshift_a')
        mol1_xshift = 0;
    else
        mol1_xshift = xmlStruct.molecules(ii).xshift_a;
    end
    if ~isfield(xmlStruct.molecules(ii),'xshift_b')
        mol2_xshift = 0;
    else
        mol2_xshift = xmlStruct.molecules(ii).xshift_b;
    end
    if ~isfield(xmlStruct.molecules(ii),'yshift_a')
        mol1_yshift = 0;
    else
        mol1_yshift = xmlStruct.molecules(ii).yshift_a;
    end
    if ~isfield(xmlStruct.molecules(ii),'yshift_b')
        mol2_yshift = 0;
    else
        mol2_yshift = xmlStruct.molecules(ii).yshift_b;
    end
    if ~isfield(xmlStruct.molecules(ii),'zshift_a')
        mol1_zshift = 0;
    else
        mol1_zshift = xmlStruct.molecules(ii).zshift_a;
    end
    if ~isfield(xmlStruct.molecules(ii),'zshift_b')
        mol2_zshift = 0;
    else
        mol2_zshift = xmlStruct.molecules(ii).zshift_b;
    end
    if ~isfield(xmlStruct.molecules(ii),'angle_a')
        mol1_angle = 0;
    else
        mol1_angle = xmlStruct.molecules(ii).angle_a;
    end
    if ~isfield(xmlStruct.molecules(ii),'angle_b')
        mol2_angle = 0;
    else
        mol2_angle = xmlStruct.molecules(ii).angle_b;
    end
    %effective position of the cell (necessary for rotation implementation)
    y_cell_center = dist_y * xmlStruct.molecules(ii).y; %position of cell center
    z_cell_center = 2*xmlStruct.dist_z *(0.5+xmlStruct.molecules(ii).x);

    if ~isfield(xmlStruct.molecules(ii),'disabled_a') % if the molecule is present
        stack_mol.num = stack_mol.num + 1;
        stack_mol.stack(stack_mol.num).position = [xmlStruct.molecules(ii).z,xmlStruct.molecules(ii).y,2*xmlStruct.molecules(ii).x+1];
        
        %set phase for the molecules
        stack_mol.stack(stack_mol.num).phase = xmlStruct.molecules(ii).phase + 1; % phases in magcad starts from 0 instead of 1
        
        %set molType for the molecules
        stack_mol.stack(stack_mol.num).molType = xmlStruct.molecules(ii).molType;

        [initial_charge, dot_position, draw_association] = GetMoleculeData(num2str(stack_mol.stack(ii).molType));
        number_of_charges = length(dot_position(:,1)); 

        %update molecule charge and positions (mol 1)
        for cc=1:number_of_charges
            stack_mol.stack(stack_mol.num).charge(cc).x = dot_position(cc,1) + mol1_zshift; 
            
            %relative position of the charge in the cell
            y_dot_in_cell = dot_position(cc,2); %position inside the cell
            z_dot_in_cell = dot_position(cc,3) + xmlStruct.dist_z*0.5  ;     
            
            y_mol_rotation = y_dot_in_cell*cosd(mol1_angle) + z_dot_in_cell*sind(mol1_angle);
            z_mol_rotation = z_dot_in_cell*cosd(mol1_angle) - y_dot_in_cell*sind(mol1_angle);
            stack_mol.stack(stack_mol.num).charge(cc).y = y_mol_rotation*cosd(theta_cell) + z_mol_rotation*sind(theta_cell) + y_cell_center + mol1_yshift;
            stack_mol.stack(stack_mol.num).charge(cc).z = z_mol_rotation*cosd(theta_cell) - y_mol_rotation*sind(theta_cell) + z_cell_center + mol1_xshift; 
            
            stack_mol.stack(stack_mol.num).charge(cc).q = initial_charge(cc);
        end 
        stack_mol.stack(stack_mol.num).association = draw_association;
        
        %set external voltage (not implemented, set to zero for comptibility with matlab version)
        stack_mol.stack(stack_mol.num).Vext = 0;
        
        %set mol identifier    
        stack_mol.stack(stack_mol.num).identifier = sprintf('Mol_%d',stack_mol.num);
        stack_mol.stack(stack_mol.num).identifier_qll = sprintf('%.4da',str2double(xmlStruct.molecules(ii).id));
    end
    
    if ~isfield(xmlStruct.molecules(ii),'disabled_b') % if the molecule is present
        stack_mol.num = stack_mol.num + 1;
        stack_mol.stack(stack_mol.num).position = [xmlStruct.molecules(ii).z,xmlStruct.molecules(ii).y,2*xmlStruct.molecules(ii).x];
        
        %set phase for the molecules
        stack_mol.stack(stack_mol.num).phase = xmlStruct.molecules(ii).phase + 1; % phases in magcad starts from 0 instead of 1
        
        %set molType for the molecules
        stack_mol.stack(stack_mol.num).molType = xmlStruct.molecules(ii).molType;

        [initial_charge, dot_position, draw_association] = GetMoleculeData(num2str(stack_mol.stack(ii).molType));
        number_of_charges = length(dot_position(:,1));

        %update molecule charge and positions (mol 1)
        for cc=1:number_of_charges
            stack_mol.stack(stack_mol.num).charge(cc).x = dot_position(cc,1) + mol2_zshift; 
            
            %relative position of the charge in the cell
            y_dot_in_cell = dot_position(cc,2); %position inside the cell
            z_dot_in_cell = dot_position(cc,3) - xmlStruct.dist_z*0.5  ;     
            
            y_mol_rotation = y_dot_in_cell*cosd(mol2_angle) + z_dot_in_cell*sind(mol2_angle);
            z_mol_rotation = z_dot_in_cell*cosd(mol2_angle) - y_dot_in_cell*sind(mol2_angle);
            stack_mol.stack(stack_mol.num).charge(cc).y = y_mol_rotation*cosd(theta_cell) + z_mol_rotation*sind(theta_cell) + y_cell_center + mol2_yshift;
            stack_mol.stack(stack_mol.num).charge(cc).z = z_mol_rotation*cosd(theta_cell) - y_mol_rotation*sind(theta_cell) + z_cell_center + mol2_xshift; 
            
            stack_mol.stack(stack_mol.num).charge(cc).q = initial_charge(cc);
        end 
        stack_mol.stack(stack_mol.num).association = draw_association;
        
        %set external voltage (not implemented, set to zero for comptibility with matlab version)
        stack_mol.stack(stack_mol.num).Vext = 0;
        
        %set mol identifier    
        stack_mol.stack(stack_mol.num).identifier = sprintf('Mol_%d',stack_mol.num);
        stack_mol.stack(stack_mol.num).identifier_qll = sprintf('%.4db',str2double(xmlStruct.molecules(ii).id));
    end
end

end
