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
function out_fig = Plot3DAC(stack_mol, stack_driver, stack_output, settings)

%WARNING: x-z axis are swapped

%charge plot function
[c_x,c_y,c_z] = sphere();
if settings.plot_3dfig_plotAbsoluteCharge == 1
    plotCharge = @(q,x,y,z,col) surface(2*c_z*abs(q) + z,2*c_y*abs(q) + y,2*c_x*abs(q) + x,'FaceColor',col, 'EdgeColor', 'none');
else
    plotCharge = @(q,x,y,z,col) surface(2*c_z*(abs(q)+q)/2 + z,2*c_y*(abs(q)+q)/2 + y,2*c_x*(abs(q)+q)/2 + x,'FaceColor',col, 'EdgeColor', 'none');
end

%Offset for displaying text on plots
textOffset = 2;

%Figure definition
if settings.HQimage
    dpi = 150;            % Resolution
    sz = [0 0 2880 1800]; % Image size in pixels
    out_fig = figure('visible','off','PaperUnits','inches','PaperPosition', sz/dpi,'PaperPositionMode','manual','position',[0 0  1920 1080]);
    ha = gca;
    uistack(ha,'bottom');
    ha2=axes('OuterPosition',[0,0, 1,1],'Position',[0,0, 0.14,0.14]);
    hIm = imshow(fullfile('..','Documentation','scerpa_logo.png'));
    set(ha2,'handlevisibility','off','visible','off')
else
    out_fig = figure('visible','off');
    ha = gca;
    uistack(ha,'bottom');
    ha2=axes('OuterPosition',[0,0, 1,1],'Position',[0,0, 0.14,0.14]);
    [LogoImage, mapImage] = imread(fullfile('..','Documentation','scerpa_logo.png'));
    image(LogoImage)
    colormap (mapImage)
    set(ha2,'handlevisibility','off','visible','off')
end

hold on, grid on
set(gca, 'Projection','perspective'), view(-45,25)
axis equal, axis vis3d, view(-40,50)
xlabel('Z direction'); ylabel('Y direction'); zlabel('X direction');
set(gca,'zdir','reverse') 
set(gca,'ydir','reverse') 

draw_association = [1 3; 2 3; 3 4];%debug

%base sphere


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
    if settings.plot_3dfig_molnum==1
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
    if settings.plot_3dfig_molnum==1
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
    if settings.plot_3dfig_molnum==1
        text(stack_output.stack(ii).charge(n_charge).z-textOffset,...
            stack_output.stack(ii).charge(n_charge).y-textOffset,...
            stack_output.stack(ii).charge(n_charge).x-textOffset,stack_output.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10); 
    end

end

end