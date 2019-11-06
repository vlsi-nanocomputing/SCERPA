function [stack_mol,stack_driver,stack_clock,driver_values] = importQLL(qllFile,Values_Dr,stack_phase,settings)
%IMPORTQLL Summary of this function goes here
%   Detailed explanation goes here
% stack_clock = -1;
% driver_values = -1;
%debug info:


xmlStruct = xml2struct(qllFile);

%Layout properties
n_properties = length(xmlStruct.qcalayout.technologies.settings.property);
for ii = 1:n_properties %loop on properties
    
    currentPropAttrib = xmlStruct.qcalayout.technologies.settings.property{ii}.Attributes;
    switch currentPropAttrib.name
        case 'Intermolecular Distance'
            %convert pm to angstrom
            intermolecular_distance = str2double(currentPropAttrib.value)/100;
            vertical_intermolecular_distance = 2*intermolecular_distance;
    end

end

% Available molecules
n_possibleMolecules = length(xmlStruct.qcalayout.components.item);
n_layoutMols = 0;
for ii = 1:n_possibleMolecules %loop on possible molecules and obtan associated characteristics
    
    %case only one molecule
    if n_possibleMolecules == 1
        currentMolAttrib = xmlStruct.qcalayout.components.item.Attributes;
    else
        currentMolAttrib = xmlStruct.qcalayout.components.item{ii}.Attributes;
    end
    switch currentMolAttrib.name
        case 'Bisferrocene'
            %import dot data for bisferrocene
            n_layoutMols = n_layoutMols +1;
            [molecule_data(n_layoutMols).initial_charge, molecule_data(n_layoutMols).dot_position, molecule_data(n_layoutMols).draw_association] = GetMoleculeData('bisfe_4');
        case 'Butane'
            %import dot data for bisferrocene
            n_layoutMols = n_layoutMols +1;
            [molecule_data(n_layoutMols).initial_charge, molecule_data(n_layoutMols).dot_position, molecule_data(n_layoutMols).draw_association] = GetMoleculeData('butane');
    end
end

%Driver (and output) creation
n_possibleDrivers = length(xmlStruct.qcalayout.layout.pin);
n_importedDrivers = 0;
for ii = 1:n_possibleDrivers %loop on possible drivers
    if n_possibleDrivers == 1
        currentPinAttrib = xmlStruct.qcalayout.layout.pin.Attributes;
    else
        currentPinAttrib = xmlStruct.qcalayout.layout.pin{ii}.Attributes;
    end

    if currentPinAttrib.direction == '0'
        %this is an input driver, increase number of driver
        if settings.doubleMolDriverMode == 1
            n_importedDrivers = n_importedDrivers +2;
        elseif settings.doubleMolDriverMode == 0
            n_importedDrivers = n_importedDrivers +1;
        end
              
        %get driver position
        try 
            x_driver = str2double(currentPinAttrib.x);
        catch
            x_driver = 0; 
        end
        
        try 
            y_driver = str2double(currentPinAttrib.y);
        catch
            y_driver = 0; 
        end
        
        try 
            z_driver = str2double(currentPinAttrib.z);
        catch
            z_driver = 0; 
        end
        
        stack_driver.stack(n_importedDrivers).position = sprintf('[%d %d %d]',z_driver,y_driver,2*x_driver+1);
        if settings.doubleMolDriverMode == 1
            stack_driver.stack(n_importedDrivers - 1).position = sprintf('[%d %d %d]',z_driver,y_driver,2*x_driver);
        end
        
        try 
            theta_driver = str2double(currentPinAttrib.angle);
        catch
            theta_driver = 0; 
        end
        
        %driver is automatically assigned to first available molecule
        molecule_type = 1;
        number_of_charges = length(molecule_data(molecule_type).dot_position(:,1));

        %effective position of the cell (necesssary for rotation implementation)
        y_cell_center = vertical_intermolecular_distance * y_driver; %position of cell center
        z_cell_center = 2*intermolecular_distance *(0.5+x_driver);
            
        %update driver charge and positions (mol 1)
        for cc=1:number_of_charges
            stack_driver.stack(n_importedDrivers).charge(cc).x = molecule_data(molecule_type).dot_position(cc,1); 
            
            %relative position of the charge in the cell
            y_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,2)); %position inside the cell
            z_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,3) + intermolecular_distance*0.5)  ;     
          
            stack_driver.stack(n_importedDrivers).charge(cc).y = y_dot_in_cell*cosd(theta_driver) + z_dot_in_cell*sind(theta_driver) +  y_cell_center;
            stack_driver.stack(n_importedDrivers).charge(cc).z = z_dot_in_cell*cosd(theta_driver) - y_dot_in_cell*sind(theta_driver) + z_cell_center; 
            stack_driver.stack(n_importedDrivers).charge(cc).q = molecule_data(molecule_type).initial_charge(cc);
        end      
        
        %update driver charge and positions (mol 2)
        if settings.doubleMolDriverMode == 1
            for cc=1:number_of_charges
                stack_driver.stack(n_importedDrivers-1).charge(cc).x = molecule_data(molecule_type).dot_position(cc,1); 

                %relative position of the charge in the cell
                y_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,2)); %position inside the cell
                z_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,3) - intermolecular_distance*0.5)  ;     

                stack_driver.stack(n_importedDrivers-1).charge(cc).y = y_dot_in_cell*cosd(theta_driver) + z_dot_in_cell*sind(theta_driver) +  y_cell_center;
                stack_driver.stack(n_importedDrivers-1).charge(cc).z = z_dot_in_cell*cosd(theta_driver) - y_dot_in_cell*sind(theta_driver) + z_cell_center; 
                stack_driver.stack(n_importedDrivers-1).charge(cc).q = molecule_data(molecule_type).initial_charge(cc);
            end  
        end

        %set driver identifier
        stack_driver.stack(n_importedDrivers).identifier{1} = currentPinAttrib.name;
        if settings.doubleMolDriverMode == 1
            stack_driver.stack(n_importedDrivers-1).identifier{1} = sprintf('%s_c',currentPinAttrib.name);  
        end
%         stack_driver.stack(n_importedDrivers).identifier = currentPinAttrib.name;
%         stack_driver.stack(n_importedDrivers).identifier{1} = sprintf('Dr%d',n_importedDrivers);
        
        %update number of drivers
        stack_driver.num = n_importedDrivers;
        
    elseif currentPinAttrib.direction == '1'
        %output is not yet implemented
    end
end

%Layout creation
%set number of molecules
number_of_cells_in_layout = length(xmlStruct.qcalayout.layout.item);
stack_mol.num = 0;

for jj = 1:number_of_cells_in_layout %loop on possible mols 
    
    %get current cell and associated molecule positions
    currentCell = xmlStruct.qcalayout.layout.item{jj};

    [mol,phase] = cell2mols(currentCell,molecule_data,intermolecular_distance,vertical_intermolecular_distance);
      
    number_of_cell_mols = length(mol.stack);
    
    for nn = 1:number_of_cell_mols
        stack_mol.num = stack_mol.num+1;
        
        %load mol parameters into stack
        stack_mol.stack(stack_mol.num).charge = mol.stack(nn).charge;
        stack_mol.stack(stack_mol.num).position = mol.stack(nn).position;
        
        %set identifier
        stack_mol.stack(stack_mol.num).identifier = sprintf('Mol_%d',stack_mol.num);
        
        %get molecule phase
        mol_phase = phase + 1;
    
        %add to stack_clock
        stack_clock(stack_mol.num,:) =[stack_mol.stack(jj).identifier, num2cell(stack_phase(mol_phase,:))];
    end
    
       
    
    
end



%create driver_values
driver_values = Values_Dr;

end

%%%%% function that converts cells to molecules

function [stack,phase] = cell2mols(cell,molecule_data,intermolecular_distance,vertical_intermolecular_distance)

    %get cell position
    try 
        x_cell = str2double(cell.Attributes.x);
    catch
        x_cell = 0; 
    end

    try 
        y_cell = str2double(cell.Attributes.y);
    catch
        y_cell = 0; 
    end

    try 
        z_cell = str2double(cell.Attributes.z);
    catch
        z_cell = 0; 
    end
    
    try 
        theta_cell = str2double(cell.Attributes.angle);
    catch
        theta_cell = 0; 
    end
    
    %default paramters
    mol1_angle = 0;
    mol1_xshift = 0;
    mol1_yshift = 0;
    mol1_zshift = 0;
    mol1_disable = 0;
    mol2_angle = 0;
    mol2_xshift = 0;
    mol2_yshift = 0;
    mol2_zshift = 0;
    mol2_disable = 0;
    
    %check existence of first molecule
    number_of_cell_properties = length(cell.property);
    for ii = 1:number_of_cell_properties
        if number_of_cell_properties==1
            currentPropertyName = cell.property.Attributes.name;
            currentPropertyValue = cell.property.Attributes.value;
        else
            currentPropertyName = cell.property{ii}.Attributes.name;
            currentPropertyValue = cell.property{ii}.Attributes.value
        end
        
        switch currentPropertyName
            case 'phase'
                phase = str2double(currentPropertyValue);
            case 'angle_1'
                mol1_angle = str2double(currentPropertyValue);
            case 'xshift_1'
                mol1_xshift = str2double(currentPropertyValue)/100;
            case 'yshift_1'
                mol1_yshift = str2double(currentPropertyValue)/100;
            case 'zshift_1'    
                mol1_zshift = str2double(currentPropertyValue)/100;
            case 'disabled_1'   
                mol1_disable = 1;
            case 'angle_2'
                mol2_angle = str2double(currentPropertyValue);
            case 'xshift_2'
                mol2_xshift = str2double(currentPropertyValue)/100;
            case 'yshift_2'
                mol2_yshift = str2double(currentPropertyValue)/100;
            case 'zshift_2'    
                mol2_zshift = str2double(currentPropertyValue)/100;
            case 'disabled_2'   
                mol2_disable = 1;
        end
    end
    
    %molecule is assigned to specified molecule (component)
    molecule_type = str2double(cell.Attributes.comp) + 1; %add 1 so that 0 becomes first MATLAB molecule
    number_of_charges = length(molecule_data(molecule_type).dot_position(:,1));
    
    %effective position of the cell (necesssary for rotation implementation)
    y_cell_center = vertical_intermolecular_distance * y_cell; %position of cell center
    z_cell_center = 2*intermolecular_distance *(0.5+x_cell);
            
    %update driver charge and positions (mol 1)
    if mol1_disable == 0
        mol_index = 1;
        stack.stack(mol_index).position = sprintf('[%d %d %d]',z_cell,y_cell,2*x_cell);
        
        for cc=1:number_of_charges
            stack.stack(mol_index).charge(cc).x = molecule_data(molecule_type).dot_position(cc,1) ; 
            
            %relative position of the charge in the cell
            y_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,2)); %position inside the cell
            z_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,3) + intermolecular_distance*0.5)  ;  
                       
            stack.stack(mol_index).charge(cc).y = y_dot_in_cell*cosd(theta_cell) + z_dot_in_cell*sind(theta_cell) +  y_cell_center;
            stack.stack(mol_index).charge(cc).z = z_dot_in_cell*cosd(theta_cell) - y_dot_in_cell*sind(theta_cell) + z_cell_center; 
            stack.stack(mol_index).charge(cc).q = molecule_data(molecule_type).initial_charge(cc);
        end       
    end
        
    %update driver charge and positions (mol 1)
    if mol2_disable == 0
        mol2_index = 2 - mol1_disable;
        stack.stack(mol2_index).position = sprintf('[%d %d %d]',z_cell,y_cell,2*x_cell + 1);
        
        for cc=1:number_of_charges
            stack.stack(mol2_index).charge(cc).x = molecule_data(molecule_type).dot_position(cc,1) ; 
            
            %relative position of the charge in the cell
            y_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,2)); %position inside the cell
            z_dot_in_cell = (molecule_data(molecule_type).dot_position(cc,3) - intermolecular_distance*0.5)  ;  
                       
            stack.stack(mol2_index).charge(cc).y = y_dot_in_cell*cosd(theta_cell) + z_dot_in_cell*sind(theta_cell) +  y_cell_center;
            stack.stack(mol2_index).charge(cc).z = z_dot_in_cell*cosd(theta_cell) - y_dot_in_cell*sind(theta_cell) + z_cell_center; 
            stack.stack(mol2_index).charge(cc).q = molecule_data(molecule_type).initial_charge(cc);
        end       
    end
    
end