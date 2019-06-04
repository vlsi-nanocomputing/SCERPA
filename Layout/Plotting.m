function [] = Plotting(stack_mol, stack_driver,draw_association)

%WARNING: x-z axis are swapped

%Offset for displaying text on plots
textOffset = 2;

%Figure definition
figure(100), hold on, grid on
set(gca, 'Projection','perspective'), view(-45,25)
axis equal, axis vis3d
view(-40,50)
xlabel('Z direction');
ylabel('Y direction');
zlabel('X direction');
set(gca,'zdir','reverse') 
set(gca,'ydir','reverse') 

%plot molecules
for ii=1:stack_mol.num
    
    %plot connections
    n_connections = length(draw_association(:,1));
    for cncn =1:n_connections
        plot3([stack_mol.stack(ii).charge(draw_association(cncn,1)).z stack_mol.stack(ii).charge(draw_association(cncn,2)).z],...
            [stack_mol.stack(ii).charge(draw_association(cncn,1)).y stack_mol.stack(ii).charge(draw_association(cncn,2)).y],...
            [stack_mol.stack(ii).charge(draw_association(cncn,1)).x stack_mol.stack(ii).charge(draw_association(cncn,2)).x],...
            'k','LineWidth',3);
    end
    
    %plot charges
    n_charge = length(stack_mol.stack(ii).charge);
    for cc=1:n_charge
        sphere = scatter3(stack_mol.stack(ii).charge(cc).z, ...
                 stack_mol.stack(ii).charge(cc).y, ...
                 stack_mol.stack(ii).charge(cc).x, ...
                 max(stack_mol.stack(ii).charge(cc).q,0.01)*190, 'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);
        
    %change colors for first 2 dots
        if cc==1
            set(sphere,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
        elseif cc==2
            set(sphere,'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0]);
        end
    end
   
    %plot names
    text(stack_mol.stack(ii).charge(n_charge).z-textOffset,...
        stack_mol.stack(ii).charge(n_charge).y-textOffset,...
        stack_mol.stack(ii).charge(n_charge).x-textOffset,stack_mol.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10); 

end

%plot drivers
for ii=1:stack_driver.num
    
    %plot connections
    n_connections = length(draw_association(:,1));
    for cncn =1:n_connections
        plot3([stack_driver.stack(ii).charge(draw_association(cncn,1)).z stack_driver.stack(ii).charge(draw_association(cncn,2)).z],...
            [stack_driver.stack(ii).charge(draw_association(cncn,1)).y stack_driver.stack(ii).charge(draw_association(cncn,2)).y],...
            [stack_driver.stack(ii).charge(draw_association(cncn,1)).x stack_driver.stack(ii).charge(draw_association(cncn,2)).x],...
            'b','LineWidth',3);
    end
    
    %plot charges
    n_charge = length(stack_driver.stack(ii).charge);
    for cc=1:n_charge
        scatter3(stack_driver.stack(ii).charge(cc).z, ...
                 stack_driver.stack(ii).charge(cc).y, ...
                 stack_driver.stack(ii).charge(cc).x, ...
                 150, 'MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1]);
    end
   
    %plot names
    text(stack_driver.stack(ii).charge(n_charge).z-textOffset,...
        stack_driver.stack(ii).charge(n_charge).y-textOffset,...
        stack_driver.stack(ii).charge(n_charge).x-textOffset,stack_driver.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10); 

end

%run('GenerateElectrodesStackTest.m');
%GenerateElectrodesStack(dot_position, dist_z, dist_y, QCA_circuit_structure, QCA_circuit_rotation, QCASurface, electrode_variation);
disp('[WARNING] Electrode view disable');

end

