function QCA_circuit = importMatlab(QCA_circuit)


%get circuit layout
if ~isfield(QCA_circuit,'structure')
    disp('[SCERPA ERROR] No circuit (QCA_circuit.structure) defined in the input file!')
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
            return
    end
end

if ~isfield(QCA_circuit,'components') 
    % if no components field, create default components
    QCA_circuit.components(1:row,1:column) = {molType};    
else % if components field is present, check dimensions
    [row_component, column_component] = size(QCA_circuit.components);
    if row_component ~= row || column_component ~= column 
        disp('[SCERPA ERROR] Components matrix is not well defined (size is not consistent)!')
        return;
    end
end

%get intermolecular distances
if ~isfield(QCA_circuit,'dist_z')
    QCA_circuit.dist_z = 10;
end

if ~isfield(QCA_circuit,'dist_y') 
    %before was QCA_circuit.dist_z + 10.145 (which is the distance between dot1 and dot2 of the bisferrocene)
    QCA_circuit.dist_y = 2*QCA_circuit.dist_z;  
end

%fprintf('Molecule: %s\n',QCA_circuit.molecule)
fprintf('Intermolecular distance: %.2f nm\n',QCA_circuit.dist_z/10)
fprintf('Vertical intermolecular distance: %.2f nm\n',QCA_circuit.dist_y/10)

%rotation on x
if ~isfield(QCA_circuit,'rotation_x')
    %assigning rotation_x = 0 for each molecule
    QCA_circuit.rotation_x =  zeros(row,column);
else %check rotation matrix dimension
    [row_rotation, column_rotation] = size(QCA_circuit.rotation_x);
    if row_rotation ~= row || column_rotation ~= column 
        disp('[SCERPA ERROR] Rotation(x) matrix is not well defined (size is not consistent)!')
        return;
    end
end

%rotation on y
if ~isfield(QCA_circuit,'rotation_y')
    %assigning rotation_y = 0 for each molecule
    QCA_circuit.rotation_y =  zeros(row,column);
else %check rotation matrix dimension
    [row_rotation, column_rotation] = size(QCA_circuit.rotation_y);
    if row_rotation ~= row || column_rotation ~= column 
        disp('[SCERPA ERROR] Rotation(y) matrix is not well defined (size is not consistent)!')
        return;
    end
end

%rotation on z
if ~isfield(QCA_circuit,'rotation_z')
    %assigning rotation_z = 0 for each molecule
    QCA_circuit.rotation_z =  zeros(row,column);
else %check rotation matrix dimension
    [row_rotation, column_rotation] = size(QCA_circuit.rotation_z);
    if row_rotation ~= row || column_rotation ~= column 
        disp('[SCERPA ERROR] Rotation(z) matrix is not well defined (size is not consistent)!')
        return;
    end
end

%shift on x
if ~isfield(QCA_circuit,'shift_x')
    %assigning shift_x = 0 for each molecule
    QCA_circuit.shift_x =  zeros(row,column);
else %check shift matrix dimension
    [row_shift, column_shift] = size(QCA_circuit.shift_x);
    if row_shift ~= row || column_shift ~= column 
        disp('[SCERPA ERROR] Shift(x) matrix is not well defined (size is not consistent)!')
        return
    end
end

%shift on y
if ~isfield(QCA_circuit,'shift_y')
    %assigning shift_y = 0 for each molecule
    QCA_circuit.shift_y =  zeros(row,column);
else %check shift matrix dimension
    [row_shift, column_shift] = size(QCA_circuit.shift_y);
    if row_shift ~= row || column_shift ~= column 
        disp('[SCERPA ERROR] Shift(y) matrix is not well defined (size is not consistent)!')
        return
    end
end

%shift on z
if ~isfield(QCA_circuit,'shift_z')
    %assigning shift_z = 0 for each molecule
    QCA_circuit.shift_z =  zeros(row,column);
else %check shift matrix dimension
    [row_shift, column_shift] = size(QCA_circuit.shift_z);
    if row_shift ~= row || column_shift ~= column 
        disp('[SCERPA ERROR] Shift(z) matrix is not well defined (size is not consistent)!')
        return
    end
end

%external voltage
if ~isfield(QCA_circuit,'Vext')
    %assigning Vext = 0 for each molecule
    QCA_circuit.Vext =  zeros(row,column);
else %check Vext matrix dimension
    [row_Vext, column_Vext] = size(QCA_circuit.Vext);
    if row_Vext ~= row || column_Vext ~= column 
        disp('[SCERPA ERROR] Vext matrix is not well defined (size is not consistent)!')
        return
    end
end

end