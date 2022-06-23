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
function [stack_mol,stack_driver] = applyRoughness(stack_mol,stack_driver,circuit)

    plot_substrate_map = 1;
%   plot_substrate_map = 0;
    switch circuit.substrate.mode 
        case 'map'
            disp('Plotting substrate map...')
            figure(211) 
                surf(circuit.substrate.map_MeshY/10, circuit.substrate.map_MeshZ/10, circuit.substrate.map_MeshX/10, 'FaceAlpha',0.3,'EdgeColor','none')
                hold on
                title('Substrate')
                colormap copper
                xlabel('y [nm]'),ylabel('z [nm]'),zlabel('Substrate [nm]')
                view([1 1 1])
        case 'random'
            fprintf('Using random substrate map [%.2f nm]...\n',circuit.substrate.averageRoughness/10);
    end

%%%%%%%%%%%%%   
%%% molecule management
%%%%%%%%%%%%%   

    for ii=1:stack_mol.num

        %molecule position coincides with last charge (anchoring point)
        z_anchor = stack_mol.stack(ii).charge(end).z;
        y_anchor = stack_mol.stack(ii).charge(end).y;

        %getshift
        if strcmp(circuit.substrate.mode,'random')
            %random roughness
            roughness_shift = circuit.substrate.averageRoughness*(rand(1) - 0.5);
        elseif strcmp(circuit.substrate.mode,'map')
            %interp data
            roughness_shift = meshInterp(...
                circuit.substrate.map_MeshY,...
                circuit.substrate.map_MeshZ,...
                circuit.substrate.map_MeshX,...
                y_anchor,z_anchor);

            %if molecule position is out of range, set roughness to 0
            if isnan(roughness_shift)
                roughness_shift = 0;
            end
        end

        %shift all charges
        for jj=1:4
            stack_mol.stack(ii).charge(jj).x = stack_mol.stack(ii).charge(jj).x + roughness_shift;
        end

      %plot
      if plot_substrate_map == 1
          figure(212), hold on
          plot3([1 1]*y_anchor/10,[1 1]*z_anchor/10,[0 roughness_shift]/10,'k')
          plot3(y_anchor/10,z_anchor/10,roughness_shift/10,'or')
      end

    end
    
%%%%%%%%%%%%%   
%%% driver management
%%%%%%%%%%%%%   

    for ii=1:stack_driver.num

        %molecule position coincides with last charge (anchoring point)
        z_anchor = stack_driver.stack(ii).charge(end).z;
        y_anchor = stack_driver.stack(ii).charge(end).y;

        %getshift
        if strcmp(circuit.substrate.mode,'random')
            %random roughness
            roughness_shift = circuit.substrate.averageRoughness*(rand(1) - 0.5);
        else
            %interp data
            roughness_shift = meshInterp(...
                circuit.substrate.map_MeshY,...
                circuit.substrate.map_MeshZ,...
                circuit.substrate.map_MeshX,...
                y_anchor,z_anchor);
            
            %if molecule position is out of range, set roughness to 0
            if isnan(roughness_shift)
                roughness_shift = 0;
            end
        end

        %shift all charges
        for jj=1:4
            stack_driver.stack(ii).charge(jj).x = stack_driver.stack(ii).charge(jj).x + roughness_shift;
        end

      %plot
      if plot_substrate_map == 1
          figure(212), hold on
          plot3([1 1]*y_anchor/10,[1 1]*z_anchor/10,[0 roughness_shift]/10,'k')
          plot3(y_anchor/10,z_anchor/10,roughness_shift/10,'ob')
      end

    end
   
    if plot_substrate_map==1
        title('Molecule position on the substrate')
        view([1 1 1]), xlabel('y [nm]'), ylabel('z [nm]'), zlabel('-x [nm]')
        grid on, grid minor, axis equal
        fprintf('\n\nPlotting Substrate... Press any key to continue...\n')
        pause
    end



end

