function [ output_args ] = final_variations( fileName, output_position, QCA_circuit_structure, QCASurface )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%search for matrix dimensions
[number_of_rows, number_of_coloumns]=size(QCASurface);

%search for the mean disposition in y
for i=0:number_of_rows-1
y_averages(i+1)=(i*((max(output_position(:,2))- min(output_position(:,2)))/(number_of_rows-1))) + min(output_position(:,2));

end

if (number_of_rows==1)
y_averages(1)=(1*((max(output_position(:,2))- min(output_position(:,2)))/(number_of_rows))) + min(output_position(:,2));
end

%search for the mean disposition in z
for i=0:number_of_coloumns-1
z_averages(i+1)=(i*((max(output_position(:,1))- min(output_position(:,1)))/(number_of_coloumns-1))) + min(output_position(:,1));

end

ideal_pattern= zeros(number_of_rows,number_of_coloumns);

%search the presence and fill an ideal pattern matrix with ideal position
%(ideal pattern index start from bottom left of the matrix)
for j=number_of_rows:-1:1
    for i=1:number_of_coloumns
        if ne(QCA_circuit_structure{j,i},0)
            
            plot(z_averages(i),y_averages(j),'gx');
            ideal_pattern(j,i,1)=[z_averages(i)];
            ideal_pattern(j,i,2)=[y_averages(j)];
            
            hold on
        end
    end
end

output_position_neighbors_map= output_position;
z_shift_map_index = 1;
y_shift_map_index = 1;



for j=1:number_of_rows
    for i=1:number_of_coloumns
        if ne(QCA_circuit_structure{j,i},0)
            
            ideal_z=ideal_pattern(j,i,1);
            ideal_y=ideal_pattern(j,i,2);
            ideal_point=[ideal_z, ideal_y];
            [inds, dists] = knnsearch(output_position_neighbors_map, ideal_point);
            
            figure
            hold on
            plot(ideal_pattern(:,:,1),ideal_pattern(:,:,2), 'bo' );
            plot(ideal_z,ideal_y, 'k*', output_position_neighbors_map(inds,1), output_position_neighbors_map(inds,2), 'k*')
            
                %if  eq(QCA_circuit_structure{j,i},'Dr1') %|| strncmpi(QCA_circuit_structure{j, i},'Dr',2)
                if strncmpi(QCA_circuit_structure{j, i},'Dr',2)    %don't do anithyng 
                else
                z_shift_map(z_shift_map_index)=-(ideal_z-output_position_neighbors_map(inds,1));
                y_shift_map(y_shift_map_index)=-(ideal_y-output_position_neighbors_map(inds,2));
                z_shift_map_index= z_shift_map_index + 1;
                y_shift_map_index= y_shift_map_index + 1;
                end                
            %delete point after selection
            output_position_neighbors_map(inds,:)=[];
        end
    end
end


fid = fopen( 'zShiftMap.txt', 'wt' );
for i=1:z_shift_map_index-1
 
fprintf( fid, '%f\n', z_shift_map(i));
end
fclose(fid);


fid = fopen( 'yShiftMap.txt', 'wt' );
for i=1:y_shift_map_index-1
 
fprintf( fid, '%f\n', y_shift_map(i));
end
fclose(fid);

%------------------------------------vertical_process_variation---------------
% %transistor matrix (0 => not present; 1 => present)
% for j=1:RowsSurface
% for i=1:ColumnsSurface
%     if QCACircuitStructure{j,i}==0 || 
% s(j,i)=0;
%     else s(j,i)=1; end
% end
% end

vertical_shift_map_index=0;
for j=number_of_rows:-1:1
for i=1:number_of_coloumns
    
    %if the transistor is present (is not nan print realtive variation in the file)
    if ne( QCA_circuit_structure{j, i}, 0)
        if ne(strncmpi(QCA_circuit_structure{j, i},'Dr',2),1)
            
            vertical_shift_map_index=vertical_shift_map_index+1;
            vertical_shift_map(vertical_shift_map_index)= -8*QCASurface(j,i);   
        end
    end
end
end


fid = fopen( 'xShiftMap.txt', 'wt' );
for i=1:vertical_shift_map_index
    %if the transistor is present (is not nan print realtive variation in the file)
        fprintf( fid, '%f\n', vertical_shift_map(i));
end
fclose(fid);
%------------------------------------vertical_process_variation---------------

z_shift_map=z_shift_map';
y_shift_map=y_shift_map';

figure

plot(output_position(1,1),output_position(1,2), 'ro' );
hold on;
plot(output_position(:,1),output_position(:,2), 'bx' );
hold on
plot(ideal_pattern(:,:,1),ideal_pattern(:,:,2), 'bo' );


%--------------------plot_Au_map_pattern------------------------
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%fileName= 'AuSamplePoints.txt';
AuPlantMap = fopen(fileName,'r');
formatSpec = '%f, %f\n';
nol = 0;

while feof(AuPlantMap) == 0
        line = fgetl(AuPlantMap);
        nol = nol + 1;
end
        fclose(AuPlantMap);

        AuSamplePointMatrix = zeros(nol,2);            
        AuSamplePointMatrix = importfile(fileName, 1, nol);
        x=(AuSamplePointMatrix(:,1))';
        y=(AuSamplePointMatrix(:,2))';
        figure
        scatter(x,y,'b');
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%--------------------plot_Au_map_pattern------------------------


% plot(z_averages(:),y_averages(1),'ro');
% hold on;
% plot(z_averages(:),y_averages(2),'bo');
% hold on;
% plot(z_averages(:),y_averages(3),'go');
% hold on;
% plot(z_averages(1),y_averages(1),'gx');

end

