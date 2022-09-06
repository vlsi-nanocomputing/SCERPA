%====================================================================================================
%======================================= GAUSSIAN ===================================================
%====================================================================================================


%% ROTATION X
if strcmp(pv.rotation_x.make,'yes')
    rotation_x = normrnd(pv.rotation_x.mu,pv.rotation_x.sigma,[stack_mol.num,1]);       % rotation_Y
elseif strcmp(pv.rotation_x.make,'map')
        xFileID = fopen('xMap.txt','r');
        formatSpec = '%f';
        sizeRotation_x = [stack_mol.num,1];
        rotation_x = fscanf(xFileID,formatSpec,sizeRotation_x);
        fclose(xFileID);
else
    rotation_x = zeros(stack_mol.num,1);
end

%% ROTATION Y
if strcmp(pv.rotation_y.make,'yes')
    rotation_y = normrnd(pv.rotation_y.mu,pv.rotation_y.sigma,[stack_mol.num,1]);       % rotation_Y
elseif strcmp(pv.rotation_y.make,'map')
        yFileID = fopen('yMap.txt','r');
        formatSpec = '%f';
        sizeRotation_y = [stack_mol.num,1];
        rotation_y = fscanf(yFileID,formatSpec,sizeRotation_y);
        fclose(yFileID);
else
    rotation_y = zeros(stack_mol.num,1);
end

%% ROTATION Z
if strcmp(pv.rotation_z.make,'yes')
    rotation_z = normrnd(pv.rotation_z.mu,pv.rotation_z.sigma,[stack_mol.num,1]);       % rotation_Y
elseif strcmp(pv.rotation_z.make,'map')
        zFileID = fopen('zMap.txt','r');
        formatSpec = '%f';
        sizeRotation_z = [stack_mol.num,1];
        rotation_z = fscanf(zFileID,formatSpec,sizeRotation_z);
        fclose(zFileID);
else
    rotation_z = zeros(stack_mol.num,1);
end

%% SHIFT X
if strcmp(pv.shift_x.make,'yes')
    shift_x = normrnd(pv.shift_x.mu,pv.shift_x.sigma,[stack_mol.num,1]);       % shift_x
elseif strcmp(pv.shift_x.make,'map')
        xShiftFileID = fopen('xShiftMap.txt','r');
        formatSpec = '%f';
        sizeShift_x = [stack_mol.num,1];
        shift_x = fscanf(xShiftFileID,formatSpec,sizeShift_x);
        fclose(xShiftFileID);
else
    shift_x = zeros(stack_mol.num,1);
end

%% SHIFT Y
if strcmp(pv.shift_y.make,'yes')
    shift_y = normrnd(pv.shift_y.mu,pv.shift_y.sigma,[stack_mol.num,1]);       % shift_y
elseif strcmp(pv.shift_y.make,'map')
        yShiftFileID = fopen('yShiftMap.txt','r');
        formatSpec = '%f';
        sizeShift_y = [stack_mol.num,1];
        shift_y = fscanf(yShiftFileID,formatSpec,sizeShift_y);
        fclose(yShiftFileID);
else
    shift_y = zeros(stack_mol.num,1);
end

%% SHIFT Z
if strcmp(pv.shift_z.make,'yes')
    shift_z = normrnd(pv.shift_z.mu,pv.shift_z.sigma,[stack_mol.num,1]);       % shift_z
elseif strcmp(pv.shift_z.make,'map')
        zShiftFileID = fopen('zShiftMap.txt','r');
        formatSpec = '%f';
        sizeShift_z = [stack_mol.num,1];
        shift_z = fscanf(zShiftFileID,formatSpec,sizeShift_z);
        fclose(zShiftFileID);
else
    shift_z = zeros(stack_mol.num,1);
end

%% CHARGE
if strcmp(pv.charge.make,'yes')
    charge_dot1 = normrnd(initial_charge(1),pv.charge.sigma,[stack_mol.num,1]);   % charge_dot1
    charge_dot2 = normrnd(initial_charge(2),pv.charge.sigma,[stack_mol.num,1]);   % charge_dot2
    charge_dot3 = normrnd(initial_charge(3),pv.charge.sigma,[stack_mol.num,1]);   % charge_dot3
    charge_dot4 = normrnd(initial_charge(4),pv.charge.sigma,[stack_mol.num,1]);   % charge_dot4
else
    charge_dot1(1:stack_mol.num,1) = initial_charge(1);
    charge_dot2(1:stack_mol.num,1) = initial_charge(2);
    charge_dot3(1:stack_mol.num,1) = initial_charge(3);
    charge_dot4(1:stack_mol.num,1) = initial_charge(4);
end

for i=1:stack_mol.num
    
    %ROTATION MATRIX
    Rx = [1,          0            ,         0            ;
          0,  cosd(rotation_x(i,1)+stack_mol.stack(i).rotation_x), -sind(rotation_x(i,1)+stack_mol.stack(i).rotation_x);
          0,  sind(rotation_x(i,1)+stack_mol.stack(i).rotation_x),  cosd(rotation_x(i,1)+stack_mol.stack(i).rotation_x)];
      
    Ry = [cosd(rotation_y(i,1)), 0, sind(rotation_y(i,1));
                   0           , 1,           0          ;
          -sind(rotation_y(i,1)), 0, cosd(rotation_y(i,1))];
      
    Rz = [cosd(rotation_z(i,1)), -sind(rotation_z(i,1)), 0;
          sind(rotation_z(i,1)),  cosd(rotation_z(i,1)), 0;
                   0           ,            0          , 1];
    
    dot_1 = Rx*Ry*Rz*[dot_position(1,1); dot_position(1,2); dot_position(1,3)];
    dot_2 = Rx*Ry*Rz*[dot_position(2,1); dot_position(2,2); dot_position(2,3)];
    dot_3 = Rx*Ry*Rz*[dot_position(3,1); dot_position(3,2); dot_position(3,3)];
    dot_4 = Rx*Ry*Rz*[dot_position(4,1); dot_position(4,2); dot_position(4,3)];
%===============Dot1=================%
    stack_mol_PV.stack(i).charge(1).q = charge_dot1(i,1);
  	stack_mol_PV.stack(i).charge(1).x = dot_1(1) + shift_x(i,1);
   	stack_mol_PV.stack(i).charge(1).y = (stack_mol.stack(i).position(2)-1)*(dist_y) + dot_1(2) + shift_y(i,1);
    stack_mol_PV.stack(i).charge(1).z = (stack_mol.stack(i).position(3)-1)*(dist_z) + dot_1(3) + shift_z(i,1);
%=============Dot2==================%
  	stack_mol_PV.stack(i).charge(2).q = charge_dot2(i,1);
  	stack_mol_PV.stack(i).charge(2).x = dot_2(1) + shift_x(i,1);
   	stack_mol_PV.stack(i).charge(2).y = (stack_mol.stack(i).position(2)-1)*(dist_y) + dot_2(2) + shift_y(i,1);
    stack_mol_PV.stack(i).charge(2).z = (stack_mol.stack(i).position(3)-1)*(dist_z) + dot_2(3) + shift_z(i,1);
%=============Carbazole==============%
  	stack_mol_PV.stack(i).charge(3).q = charge_dot3(i,1);
  	stack_mol_PV.stack(i).charge(3).x = dot_3(1) + shift_x(i,1);
   	stack_mol_PV.stack(i).charge(3).y = (stack_mol.stack(i).position(2)-1)*(dist_y) + dot_3(2) + shift_y(i,1);
    stack_mol_PV.stack(i).charge(3).z = (stack_mol.stack(i).position(3)-1)*(dist_z) + dot_3(3) + shift_z(i,1);
%==============Thiol=================%
    stack_mol_PV.stack(i).charge(4).q = charge_dot4(i,1);
  	stack_mol_PV.stack(i).charge(4).x = dot_4(1) + shift_x(i,1);
   	stack_mol_PV.stack(i).charge(4).y = (stack_mol.stack(i).position(2)-1)*(dist_y) + dot_4(2) + shift_y(i,1);
    stack_mol_PV.stack(i).charge(4).z = (stack_mol.stack(i).position(3)-1)*(dist_z) + dot_4(3) + shift_z(i,1);
     
    stack_mol_PV.stack(i).position =     stack_mol.stack(i).position;
    
    stack_mol_PV.stack(i).rotation_x = rotation_x(i,1);
    stack_mol_PV.stack(i).rotation_y = rotation_y(i,1);
    stack_mol_PV.stack(i).rotation_z = rotation_z(i,1);
    
    stack_mol_PV.stack(i).shift_x = shift_x(i,1);
    stack_mol_PV.stack(i).shift_y = shift_y(i,1);
    stack_mol_PV.stack(i).shift_z = shift_z(i,1);
    stack_mol_PV.stack(i).charge_dot1 = charge_dot1(i,1);
    stack_mol_PV.stack(i).charge_dot2 = charge_dot2(i,1);
    stack_mol_PV.stack(i).charge_dot3 = charge_dot3(i,1);
    stack_mol_PV.stack(i).charge_dot4 = charge_dot4(i,1);
    
    stack_mol_PV.num = stack_mol.num;
    stack_mol_PV.stack(i).identifier = stack_mol.stack(i).identifier;
    stack_mol_PV.stack(i).phase = stack_mol.stack(i).phase;
    
end
