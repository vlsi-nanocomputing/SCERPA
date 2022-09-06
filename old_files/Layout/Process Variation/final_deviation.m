%clear all;
%close all;

output_position = AuMapMatrix('AuSamplePoints.txt', 3);



QCA_circuit.structure = {  0    0   0   0   0  '1' '1' '2' '2' '2' '2'  0   0   0   0   0   0 ;
                         'Dr1' '1' '1' '1' '1' '1' '1'  0   0   0   0  '3' '3' '3' '3' '3' '3';
                           0    0   0   0   0  '1' '1' '2' '2' '2' '2'  0   0   0   0   0   0 };


QCASurface=[0.00109961477929809 0.00284178149510178 0.00585689761145013 0.00873450609107390 0.00564674356942750 -0.0160718080395823 -0.0740473364910968 -0.181051872410607 -0.330010453847524 -0.485644117921039 -0.595202968178298 -0.616499703618534 -0.543573853468711 -0.409186665925926 -0.262904979987113 -0.143651646537349 -0.0661923378714440;0.00128858277836597 0.00375606990797602 0.00879505938119915 0.0158947066671223 0.0191582364915501 0.00290019213549821 -0.0577654785216305 -0.184864672422156 -0.375711187601293 -0.587266657330197 -0.746926714976795 -0.791149764283510 -0.705071944049889 -0.530392054632814 -0.335975110706744 -0.177552363791339 -0.0765950703418218;0.000665646391900360 0.00315013847760032 0.00986681896749404 0.0231462599808460 0.0408348752284620 0.0490631690215254 0.0185471378046712 -0.0850047906722067 -0.273506866615914 -0.509635905833136 -0.710334595148595 -0.791037874041925 -0.720506059223909 -0.539674032240421 -0.329497481393735 -0.158944952408931 -0.0550847535062773];                       


%search for matrix dimensions
[number_of_rows, number_of_coloumns]=size(QCASurface);

%search for the mean disposition in y
for i=0:number_of_rows-1
y_averages(i+1)=(i*((max(output_position(:,2))- min(output_position(:,2)))/(number_of_rows-1))) + min(output_position(:,2));

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
        if ne(QCA_circuit.structure{j,i},0)
            
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
        if ne(QCA_circuit.structure{j,i},0)
            
            ideal_z=ideal_pattern(j,i,1);
            ideal_y=ideal_pattern(j,i,2);
            ideal_point=[ideal_z, ideal_y];
            [inds, dists] = knnsearch(output_position_neighbors_map, ideal_point);
            
            figure
            hold on
            plot(ideal_pattern(:,:,1),ideal_pattern(:,:,2), 'bo' );
            plot(ideal_z,ideal_y, 'k*', output_position_neighbors_map(inds,1), output_position_neighbors_map(inds,2), 'k*')
            
                %if  eq(QCA_circuit.structure{j,i},'Dr1') %|| strncmpi(QCA_circuit.structure{j, i},'Dr',2)
                if strncmpi(QCA_circuit.structure{j, i},'Dr',2)    %don't do anithyng 
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
    if ne( QCA_circuit.structure{j, i}, 0)
        if ne(strncmpi(QCA_circuit.structure{j, i},'Dr',2),1)
            
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
fileName= 'AuSamplePoints.txt';
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