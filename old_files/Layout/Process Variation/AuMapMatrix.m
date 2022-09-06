function [ output_position ] = AuMapMatrix( mapName, number_of_chemical_bonds )

%open the file -use dedicated function-
% clear all;
% close all;
% mapName='AuSamplePoints.txt';
% number_of_chemical_bonds=3


fileName= mapName;
AuPlantMap = fopen(fileName,'r');
formatSpec = '%f, %f\n';
nol = 0;
noAuAtoms = 3;

%count number of line
while feof(AuPlantMap) == 0
        line = fgetl(AuPlantMap);
        nol = nol + 1;
end
        fclose(AuPlantMap);

        AuSamplePointMatrix = zeros(nol,2);            
        AuSamplePointMatrix = importfile(fileName, 1, nol);
        
        
        x=(AuSamplePointMatrix(:,1))';
        y=(AuSamplePointMatrix(:,2))';
        
        [X,Y] = meshgrid(x,y);
        
        
        %find nearest neighbours
       [inds, dists] = knnsearch(AuSamplePointMatrix, AuSamplePointMatrix, 'k', number_of_chemical_bonds);
       

       
       



j=1;
       
       
       
         for i=1:number_of_chemical_bonds:(nol-1)
             
             
             
            [inds, dists] = knnsearch(AuSamplePointMatrix, AuSamplePointMatrix, 'k', number_of_chemical_bonds);
             
             
             for k=0:number_of_chemical_bonds-1
             coordinates(k+1,:) =[AuSamplePointMatrix((inds(1+k)),1) ,AuSamplePointMatrix((inds(1+k)),2);];
             end
             
             
         [central_coordinates] = mean(coordinates);
         
         x_central=(central_coordinates(:,1))';
         y_central=(central_coordinates(:,2))';
         

            
            figure  
            axis equal;
            plot(x,y,'.', AuSamplePointMatrix((inds(1,1)),1),AuSamplePointMatrix((inds(1,1)),2), 'ro', AuSamplePointMatrix((inds(1,2)),1),AuSamplePointMatrix((inds(1,2)),2), 'bo', AuSamplePointMatrix((inds(1,3)),1),AuSamplePointMatrix((inds(1,3)),2), 'go', x_central,y_central, 'x' );
            axis equal;
            hold on;
            
            
            
   
            
         output_position(j,1)=x_central;
         output_position(j,2)=y_central;
         
         j =j+1;
         
         
         
            
            
%             for k=1:number_of_chemical_bonds 
%             AuSamplePointMatrix(1,:)=[];
%             end
            

indices_to_remove=[(inds(1,1)) (inds(1,2)) (inds(1,3))];
AuSamplePointMatrix(indices_to_remove,:)=[];


         end
         
         
         
         
         
            
         figure
         plot(output_position(:,1),output_position(:,2), 'bx' )
end

