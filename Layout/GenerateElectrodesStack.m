function [ output_args ] = GenerateElectrodesStack( dot_position, dist_z, dist_y, QCA_circuit_structure, QCA_circuit_rotation, QCASurface, electrode_variation )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%------------------------------------------------------------------
% starting_point=[0 0 0];

% electrode.width=1;
% electrode.height=2;
% electrode.space=14;
% electrode.vertical_offset=3;
% electrode.head_margin=3;
% electrode.tail_marign=3;
% electrode.downposition=-18;
% offset.y=8;
% test_lenght=8;

[electrode_setting_matrix]=import_electrode_file('Electrode_Settings.xlsx','Sheet1','B1:B9');
electrode.width=electrode_setting_matrix(1);
electrode.height=electrode_setting_matrix(2);
electrode.space=electrode_setting_matrix(3);
electrode.vertical_offset=electrode_setting_matrix(4);
electrode.head_margin=electrode_setting_matrix(5);
electrode.tail_marign=electrode_setting_matrix(6);
electrode.downposition=electrode_setting_matrix(7);
offset.y=electrode_setting_matrix(8);
test_lenght=electrode_setting_matrix(9);

starting_point=[0 7-(electrode.space/2) 0];

number_of_rows = size(QCA_circuit_structure, 1);
number_of_coloumns = size(QCA_circuit_structure, 2);

electrodes_matrix=zeros(number_of_rows, number_of_coloumns);

for j=1:number_of_rows
    for i=1:number_of_coloumns
        if ne(QCA_circuit_structure{j,i},0) & ~(strncmp(QCA_circuit_structure(j,i),'Dr',2))
            
            electrodes_matrix(j,i)=str2num(QCA_circuit_structure{j,i});
        end
    end
end

% electrodes_matrix





% PlotElectrode(starting_point, electrode.width, electrode.height, test_lenght);
% 
% starting_point=[0 3 0];
% PlotElectrode(starting_point, electrode.width, electrode.height, test_lenght);
% 
% starting_point=[8 2 0];
% PlotElectrode(starting_point, electrode.width, electrode.height, test_lenght);
% 
% starting_point=[16 0 0];
% PlotElectrode(starting_point, electrode.width, electrode.height, test_lenght);


new_electrode_position=zeros(1,2);
elecrtode_index=0;

for phase=1:max(electrodes_matrix(:))
    for j=1:number_of_rows
        new_electrode_find=0;
        new_electrode_lenght=0;
        
        i=1;

        while i<=number_of_coloumns
        
        
        
            if eq(electrodes_matrix(j,i),phase) && new_electrode_find==0 && i<=number_of_coloumns
                
                
                elecrtode_index=elecrtode_index+1;
                new_electrode_find=1;
                new_electrode_position(:)=[j i];
                
                while i<=number_of_coloumns && eq(electrodes_matrix(j,i),phase) 
                    new_electrode_lenght=new_electrode_lenght+1;
                    
                    i=i+1;
                end
                total_electrod_matrix(elecrtode_index,:)=[new_electrode_position new_electrode_lenght phase];
                new_electrode_find=0;
            else 
                    i=i+1;
                
            end
        
        end      


end
end

number_of_electrodes = size(total_electrod_matrix, 1);

%total electrode matrix
% for each electrode       x_position        y_position       length       phase
% for each electrode       x_position        y_position       length       phase
% for each electrode       x_position        y_position       length       phase
% for each electrode       x_position        y_position       length       phase


if strcmp(electrode_variation,'on')
    for i=1:number_of_electrodes
        surface_pattern(1,:)=8*QCASurface(total_electrod_matrix(i,1),total_electrod_matrix(i,2):total_electrod_matrix(i,2)+total_electrod_matrix(i,3)-1);
        %side
        starting_point1=[(total_electrod_matrix(i,2)-1)*dist_z-electrode.head_margin+starting_point(1)          (total_electrod_matrix(i,1)-1)*dist_y-offset.y+starting_point(2)          electrode.vertical_offset+starting_point(3)];
        PlotElectrodeVariations(starting_point1, electrode.width,         electrode.height,         total_electrod_matrix(i,3)*dist_z-dist_z+electrode.tail_marign+electrode.head_margin, surface_pattern(1,:), total_electrod_matrix(i,4)*1000);
        %side
        starting_point2=[(total_electrod_matrix(i,2)-1)*dist_z-electrode.head_margin+starting_point(1)          (total_electrod_matrix(i,1)-1)*dist_y+electrode.space-offset.y+starting_point(2)          electrode.vertical_offset+starting_point(3)];
        PlotElectrodeVariations(starting_point2, electrode.width,         electrode.height,         total_electrod_matrix(i,3)*dist_z-dist_z+electrode.tail_marign+electrode.head_margin,  surface_pattern(1,:),total_electrod_matrix(i,4)*1000);
        %bottom
        starting_point3=[starting_point1(1,1)          ((starting_point1(1,2)+starting_point2(1,2))/2)          electrode.downposition+electrode.vertical_offset];
        PlotElectrodeVariations(starting_point3, electrode.width,         electrode.height,         total_electrod_matrix(i,3)*dist_z-dist_z+electrode.tail_marign+electrode.head_margin,  surface_pattern(1,:),total_electrod_matrix(i,4)*1000);
        clear surface_pattern;
    end
else
    for i=1:number_of_electrodes
        %side
        starting_point1=[(total_electrod_matrix(i,2)-1)*dist_z-electrode.head_margin          (total_electrod_matrix(i,1)-1)*dist_y-offset.y          electrode.vertical_offset];
        PlotElectrode(starting_point1, electrode.width,         electrode.height,         total_electrod_matrix(i,3)*dist_z-dist_z+electrode.tail_marign+electrode.head_margin,  total_electrod_matrix(i,4)*1000);
        %side
        starting_point2=[(total_electrod_matrix(i,2)-1)*dist_z-electrode.head_margin          (total_electrod_matrix(i,1)-1)*dist_y+electrode.space-offset.y          electrode.vertical_offset];
        PlotElectrode(starting_point2, electrode.width,         electrode.height,         total_electrod_matrix(i,3)*dist_z-dist_z+electrode.tail_marign+electrode.head_margin,  total_electrod_matrix(i,4)*1000);
        %bottom
        starting_point3=[starting_point1(1,1)          ((starting_point1(1,2)+starting_point2(1,2))/2)          electrode.downposition+electrode.vertical_offset];
        PlotElectrode(starting_point3, electrode.width,         electrode.height,         total_electrod_matrix(i,3)*dist_z-dist_z+electrode.tail_marign+electrode.head_margin,  total_electrod_matrix(i,4)*1000);
    end
end

end

