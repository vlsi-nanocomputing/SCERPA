function [mol_stack]=GenerateMolStack(dist_z, dist_y, row, column, mol_stack, dot_position, mol_phase, rotation_in, shift_x_in, shift_y_in, shift_z_in, initial_charge)
      
        %casting of rotation value
        rotation_x = str2double(rotation_in);
        shift_x = str2double(shift_x_in);
        shift_y = str2double(shift_y_in);
        shift_z = str2double(shift_z_in);
        
        % rotation matrices
        Rx = [1,       0        ,       0         ;
              0,  cosd(rotation_x), -sind(rotation_x) ;
              0,  sind(rotation_x),  cosd(rotation_x)];
      
        Ry = [1, 0, 0 ; 
              0, 1, 0 ;
              0, 0, 1];

        Rz = [1, 0, 0 ;
              0, 1, 0 ;
              0,0 , 1];
          
        %eval position of each dot 
        n_dots = length(dot_position(:,1));
        for dd=1:n_dots
            %rotate - dot(i) =[x y z]
            dot_rotated = Rx*Ry*Rz*[dot_position(dd,1); dot_position(dd,2); dot_position(dd,3)];
            
            %evaluate new position (rotation+shift)
            mol_para.charge(dd).q = initial_charge(dd);
            mol_para.charge(dd).x = dot_rotated(1) + shift_x;
            mol_para.charge(dd).y = (row-1)*(dist_y)+dot_rotated(2) + shift_y;
            mol_para.charge(dd).z = (column-1)*(dist_z)+dot_rotated(3) + shift_z;
        end
       
        %add molecule information
        mol_para.identifier = sprintf('Mol_%i', mol_stack.num+1);
        mol_para.phase = mol_phase;
        mol_para.position=[0 row column];
        mol_para.rotation_x = rotation_x;
        mol_para.shift_x = shift_x;
        mol_para.shift_y = shift_y;
        mol_para.shift_z = shift_z;
        
        %add  molecule to stack
        mol_stack.num=mol_stack.num+1;
        mol_stack.stack(mol_stack.num)=mol_para;
end
