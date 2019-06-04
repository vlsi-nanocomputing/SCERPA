function [driver_stack]=GenerateDriverStack(dist_z, dist_y, row, column, driver_stack, dot_position, driver_name, rotation_in)
        
        rotation = str2num(rotation_in);    

        Rx = [1,       0        ,       0         ;
              0,  cosd(rotation), -sind(rotation) ;
              0,  sind(rotation),  cosd(rotation)];
      
        Ry = [1, 0, 0 ; 
              0, 1, 0 ;
              0, 0, 1];

        Rz = [1, 0, 0 ;
              0, 1, 0 ;
              0,0 , 1];

        dot_1 = Rx*Ry*Rz*[dot_position(1,1); dot_position(1,2); dot_position(1,3)];
        dot_2 = Rx*Ry*Rz*[dot_position(2,1); dot_position(2,2); dot_position(2,3)];
        dot_3 = Rx*Ry*Rz*[dot_position(3,1); dot_position(3,2); dot_position(3,3)];
        dot_4 = Rx*Ry*Rz*[dot_position(4,1); dot_position(4,2); dot_position(4,3)];
        
    %% ====================Driver=========================     
    %===============Dot1=================%
        driver_para.charge(1).q = 0;
        driver_para.charge(1).x = dot_1(1);
        driver_para.charge(1).y = (row-1)*(dist_y)+dot_1(2);
        driver_para.charge(1).z = (column-1)*dist_z+dot_1(3);
    %=============Dot2==================%
        driver_para.charge(2).q = 0;
        driver_para.charge(2).x = dot_2(1);
        driver_para.charge(2).y = (row-1)*(dist_y)+dot_2(2);
        driver_para.charge(2).z = (column-1)*dist_z+dot_2(3);
    %=============Carbazole==============%
        driver_para.charge(3).q = 0;
        driver_para.charge(3).x = dot_3(1);
        driver_para.charge(3).y = (row-1)*(dist_y)+dot_3(2);
        driver_para.charge(3).z = (column-1)*dist_z+dot_3(3);
    %==============Thiol=================%
        driver_para.charge(4).q = 0;
        driver_para.charge(4).x = dot_4(1);
        driver_para.charge(4).y = (row-1)*(dist_y)+ dot_4(2);
        driver_para.charge(4).z = (column-1)*dist_z + dot_4(3);
        
        driver_para.position=[0 row column];
        
        driver_para.identifier = driver_name;
        
        driver_stack.num=driver_stack.num+1;
        driver_stack.stack(driver_stack.num)=driver_para;
end
