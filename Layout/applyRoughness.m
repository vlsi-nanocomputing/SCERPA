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
function [stack_mol,stack_driver] = applyRoughness (stack_mol,stack_driver,circuit)

    plot_substrate_map = 0;
%   plot_substrate_map = 0;
    switch circuit.substrate.mode 
        case 'map'
            disp('Applying substrate map...')
          %plot map
          if plot_substrate_map==1
              figure(999) 
                  surf(circuit.substrate_mesh_y, circuit.substrate_mesh_z, circuit.substrate_mesh_x, 'FaceAlpha',0.3,'EdgeColor','none')
                  hold on
                  colormap copper
                  xlabel('mesh y'),ylabel('mesh z')
          end

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
        else
            %interp data
            roughness_shift = meshInterp(...
                circuit.substrate_mesh_y,...
                circuit.substrate_mesh_z,...
                circuit.substrate_mesh_x,...
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
          plot3(y_anchor,z_anchor,roughness_shift,'or')
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
                circuit.substrate_mesh_y,...
                circuit.substrate_mesh_z,...
                circuit.substrate_mesh_x,...
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
          plot3(y_anchor,z_anchor,roughness_shift,'or')
      end

    end
   
    if plot_substrate_map==1
        pause
    end



end

