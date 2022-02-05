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
function [] = RunTimePlotting(Vout, Charge_on_wire_done_set, stack_mol, stack_driver, stack_output, settings, figure_index)

%     %%%% Runtime Logic Plot
%     if settings.plot_logic ==1
%         P_map = 0;
%         
%         %consider molecules 2-by-2
%         for ii=1:2:stack_mol.num
%             %evaluate polarization
%             
%             P = (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q - stack_mol.stack(ii).charge(2).q - stack_mol.stack(ii+1).charge(1).q)/...
%                 (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q + stack_mol.stack(ii).charge(2).q + stack_mol.stack(ii+1).charge(1).q);
%             
%             
%             [p1] = sscanf(char(stack_mol.stack(ii).position),'[%d %d %d]');
%             [p2] = sscanf(char(stack_mol.stack(ii+1).position),'[%d %d %d]');
%             P_map(p1(2)+1,p1(3)+1) = P+2;
%             P_map(p2(2)+1,p2(3)+1) = P+2;
%             
%             
%         end
%         
%         map = [1 1 1; 1 1 1; 1 0 0; 0.5 0 0; 0 0 0; 0 0 0.5; 0 0 1];
%         fig_3 = figure(3*figure_index-3); hold on
%         imagesc(P_map)
%         colormap(map)
%         colorbar('XTickLabel',{'P = -1','P = 1'},'XTick',[1 3])
%         caxis([0 3])
%         axis equal
%         xlabel('Z direction'); ylabel('Y direction'); zlabel('X direction');
% %         set(gca,'zdir','reverse') 
%         set(gca,'ydir','reverse') 
%         
%     end
    
%%%% Runtime Clock Plot

if settings.plot_clock==1
    clockMap = 0;

    %consider clock of each molecule
    for ii=1:stack_mol.num
%             [coord] = sscanf(stack_mol.stack(ii).position,'[%d %d %d]');
        [coord] = sscanf(char(stack_mol.stack(ii).position),'[%d %d %d]');
        clockMap(coord(2)+1,coord(3)+1) = stack_mol.stack(ii).clock;

    end

    fig_4 = figure(3*figure_index-2); hold on
    imagesc(clockMap)
    colormap summer
    colorbar
    axis equal
    title('Distribution of clock [V/nm]')
    xlabel('Z direction'); ylabel('Y direction'); zlabel('X direction');
%         set(gca,'zdir','reverse') 
    set(gca,'ydir','reverse') 
    caxis([-2 2])

end

%%%% Runtime 3D Plot
if settings.plot_3dfig ==1
        %WARNING: x-z axis are swapped

    %charge plot function
    [c_x,c_y,c_z] = sphere();
    if settings.plot_plotAbsoluteCharge == 1
        plotCharge = @(q,x,y,z,col) surface(2*c_z*abs(q) + z,2*c_y*abs(q) + y,2*c_x*abs(q) + x,'FaceColor',col, 'EdgeColor', 'none');
    else
        plotCharge = @(q,x,y,z,col) surface(2*c_z*(abs(q)+q)/2 + z,2*c_y*(abs(q)+q)/2 + y,2*c_x*(abs(q)+q)/2 + x,'FaceColor',col, 'EdgeColor', 'none');
    end

    %Offset for displaying text on plots
    textOffset = 2;

    %Figure definition
    fig_2 = figure(3*figure_index-1), hold on, grid on
    set(gca, 'Projection','perspective'), view(-45,25)
    axis equal, axis vis3d, view(-40,50)
    xlabel('Z direction'); ylabel('Y direction'); zlabel('X direction');
    set(gca,'zdir','reverse') 
    set(gca,'ydir','reverse') 

    draw_association = [1 3; 2 3; 3 4];%debug

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
            if cc==1
                plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'r');
            elseif cc==2
                plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'g');
            else
                plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'k');
            end
        end

        %plot names
        if settings.plot_molnum==1
            text(stack_mol.stack(ii).charge(n_charge).z-textOffset,...
                stack_mol.stack(ii).charge(n_charge).y-textOffset,...
                stack_mol.stack(ii).charge(n_charge).x-textOffset,stack_mol.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10,'Interpreter','none'); 
        end

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
            plotCharge(stack_driver.stack(ii).charge(cc).q,stack_driver.stack(ii).charge(cc).x,stack_driver.stack(ii).charge(cc).y,stack_driver.stack(ii).charge(cc).z,'b');
        end

        %plot names
        if settings.plot_molnum==1
            text(stack_driver.stack(ii).charge(n_charge).z-textOffset,...
                stack_driver.stack(ii).charge(n_charge).y-textOffset,...
                stack_driver.stack(ii).charge(n_charge).x-textOffset,stack_driver.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10); 
        end

    end

    %plot outputs
    for ii=1:stack_output.num

        %plot connections
        n_connections = length(draw_association(:,1));
        for cncn =1:n_connections
            plot3([stack_output.stack(ii).charge(draw_association(cncn,1)).z stack_output.stack(ii).charge(draw_association(cncn,2)).z],...
                [stack_output.stack(ii).charge(draw_association(cncn,1)).y stack_output.stack(ii).charge(draw_association(cncn,2)).y],...
                [stack_output.stack(ii).charge(draw_association(cncn,1)).x stack_output.stack(ii).charge(draw_association(cncn,2)).x],...
                'r','LineWidth',3);
        end

        %plot charges
        n_charge = length(stack_output.stack(ii).charge);
        for cc=1:n_charge
            plotCharge(0.3,stack_output.stack(ii).charge(cc).x,stack_output.stack(ii).charge(cc).y,stack_output.stack(ii).charge(cc).z,'r');
        end

        %plot names
        if settings.plot_molnum==1
            text(stack_output.stack(ii).charge(n_charge).z-textOffset,...
                stack_output.stack(ii).charge(n_charge).y-textOffset,...
                stack_output.stack(ii).charge(n_charge).x-textOffset,stack_output.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10); 
        end

    end

end

    
%%% Runtime Charge Plot
if settings.plot_chargeFig==1

    fig_1 = figure(3*figure_index-2);
    plot(Charge_on_wire_done_set(:,1)',Charge_on_wire_done_set(:,2)','b--*',Charge_on_wire_done_set(:,1)',Charge_on_wire_done_set(:,3),'r--*','Linewidth',4,'MarkerSize',10);
    grid on;
    axis([0 stack_mol.num+1 -0.2 1.2])
    legend('Dot1','Dot2');
    title('Charge distribution along wire for static clock assignment');
    xlabel('Molecule number along the wire');
    ylabel('Aggregated charge distribution Dot1 & Dot2'); 

end

%%% Runtime Voltage Plot
if settings.plot_voltage==1
    figure(500000),hold on, grid on, grid minor
    title('Input Voltage on each molecule');
    xlabel('Molecule number'), ylabel('Input Voltage [V]')
    plot(Vout)
end

drawnow

end

