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
function [output_stack]=GenerateOutputStack(circuit, row, column, output_stack, dot_position, draw_association,nCharges)
        % The function GenerateOutputStack is used to create an istance of
        % the stack containing output information. It extracts the
        % information from the <<circuit>>, based on the actual position in 
        % the structure specified by <<row>> and <<column>>. Also the
        % <<dot_position>> and the association between the dots are
        % provided as inputs. Data concerning the new output are added to
        % the <<output_stack>>.
        
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
        out_para.chargeNum = nCharges;
        for dd=1:nCharges
            dot_rotated = Rx*Ry*Rz*[dot_position(dd,1); dot_position(dd,2); dot_position(dd,3)];
            
            %evaluate new position (rotation+shift)
            out_para.charge(dd).q = 0;
            out_para.charge(dd).x = dot_rotated(1) + shift_x;
            out_para.charge(dd).y = (row-1)*(dist_y)+dot_rotated(2) + shift_y;
            out_para.charge(dd).z = (column-1)*(dist_z)+dot_rotated(3) + shift_z;
        end
        
        % add driver information
        out_para.position=[0 row column];
        out_para.identifier = circuit.structure{row,column};
        out_para.molType = str2double(circuit.components{row,column});
        out_para.association = draw_association;
        
        % add driver to stacks
        output_stack.num=output_stack.num+1;
        output_stack.stack(output_stack.num)=out_para;
end
