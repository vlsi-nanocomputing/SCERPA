function [driver_stack]=GenerateDriverStack(circuit, row, column, driver_stack, dot_position, draw_association)
        % The function GenerateDriverStack is used to create an istance of
        % the stack containing driver information. It extracts the
        % information from the <<circuit>>, based on the actual position in 
        % the structure specified by <<row>> and <<column>>. Also the
        % <<dot_position>> and the association between the dots are
        % provided as inputs. Data concerning the new driver are added to
        % the <<driver_stack>>.
        
        %casting of rotation and shift values
        rotation_x = circuit.rotation_x(row,column);  
        rotation_y = circuit.rotation_y(row,column);  
        rotation_z = circuit.rotation_z(row,column);  
        shift_x = circuit.shift_x(row,column);
        shift_y = circuit.shift_y(row,column);
        shift_z = circuit.shift_z(row,column);
        
        dist_y = circuit.dist_y;
        dist_z = circuit.dist_z;
        
        % rotation matrices
        Rx = [1,      0          ,       0           ;
              0, cosd(rotation_x), -sind(rotation_x) ;
              0, sind(rotation_x),  cosd(rotation_x)];
      
        Ry = [ cosd(rotation_y), 0, sind(rotation_y) ; 
                    0          , 1,      0           ;
              -sind(rotation_y), 0, cosd(rotation_y)];

        Rz = [cosd(rotation_z), -sind(rotation_z), 0  ;
              sind(rotation_z),  cosd(rotation_z), 0  ;
              0               ,       0          , 1 ];

        
        %eval position of each dot 
        n_dots = length(dot_position(:,1));
        for dd=1:n_dots
            %rotate - dot(i) =[x y z]
            dot_rotated = Rx*Ry*Rz*[dot_position(dd,1); dot_position(dd,2); dot_position(dd,3)];
            
            %evaluate new position (rotation+shift)
            driver_para.charge(dd).q = 0;
            driver_para.charge(dd).x = dot_rotated(1) + shift_x;
            driver_para.charge(dd).y = (row-1)*(dist_y)+dot_rotated(2) + shift_y;
            driver_para.charge(dd).z = (column-1)*(dist_z)+dot_rotated(3) + shift_z;
        end
        
        % add driver information
        driver_para.position=[0 row column];
        driver_para.identifier = circuit.structure{row,column};
        driver_para.molType = str2num(circuit.components{row,column});
        driver_para.association = draw_association;
        
        % add driver to stacks
        driver_stack.num=driver_stack.num+1;
        driver_stack.stack(driver_stack.num)=driver_para;
end
