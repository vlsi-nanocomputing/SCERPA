function [stack_mol,stack_driver] = applyRoughness (stack_mol,stack_driver,settingsArg)

    plot_substrate_map = 0;
%   plot_substrate_map = 0;
    switch settingsArg.circuit.substrate.mode 
        case 'map'
            disp('Applying substrate map...')
          %plot map
          if plot_substrate_map==1
              figure(999) 
                  surf(settingsArg.circuit.substrate_mesh_y, settingsArg.circuit.substrate_mesh_z, settingsArg.circuit.substrate_mesh_x, 'FaceAlpha',0.3,'EdgeColor','none')
                  hold on
                  colormap copper
                  xlabel('mesh y'),ylabel('mesh z')
          end

        case 'random'
            fprintf('Using random substrate map [%.2f nm]...\n',settingsArg.circuit.substrate.averageRoughness/10);
    end

%%%%%%%%%%%%%   
%%% molecule management
%%%%%%%%%%%%%   

    for ii=1:stack_mol.num

        %molecule position coincides with last charge (anchoring point)
        z_anchor = stack_mol.stack(ii).charge(end).z;
        y_anchor = stack_mol.stack(ii).charge(end).y;

        %getshift
        if strcmp(settingsArg.circuit.substrate.mode,'random')
            %random roughness
            roughness_shift = settingsArg.circuit.substrate.averageRoughness*(rand(1) - 0.5);
        else
            %interp data
            roughness_shift = meshInterp(...
                settingsArg.circuit.substrate_mesh_y,...
                settingsArg.circuit.substrate_mesh_z,...
                settingsArg.circuit.substrate_mesh_x,...
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
        if strcmp(settingsArg.circuit.substrate.mode,'random')
            %random roughness
            roughness_shift = settingsArg.circuit.substrate.averageRoughness*(rand(1) - 0.5);
        else
            %interp data
            roughness_shift = meshInterp(...
                settingsArg.circuit.substrate_mesh_y,...
                settingsArg.circuit.substrate_mesh_z,...
                settingsArg.circuit.substrate_mesh_x,...
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


function shift = meshInterp(x,y,z,x0,y0) 

    %treat data
    x_max = x(1,end);
    x_min = x(1,1);
    Nx = length(x(1,:));
    y_max = y(end,1);
    y_min = y(1,1);
    Ny = length(y(:,1));

    %check boundary
    if x0 < x_min
        x0 = x_min;
    elseif x0>x_max
        x0 = x_max; 
    end

    if y0 < y_min
        y0 = y_min;
    elseif y0>y_max
        y0 = y_max; 
    end


    %determine x factor
    xFactor = (Nx-1)*(x0 - x_min) / (x_max - x_min) + 1;
    xIndex = floor(xFactor);
    xWeight = xFactor - xIndex;

    %determine y factor
    yFactor = (Ny - 1)*( y0 - y_min ) / (y_max - y_min) + 1;
    yIndex = floor(yFactor);
    yWeight = yFactor - yIndex;

    %eval charge with the lowest x and lowest y
    shiftLowX = z(:,xIndex);
    shift = shiftLowX(yIndex);

    if yWeight ~= 0
        %add contribution of yweight on the lowest x configuration
        shift = shift + yWeight*( shiftLowX(yIndex+1) - shift);
    end

    if xWeight ~= 0
        shiftHighX = z(:,xIndex+1);
        shiftH = shiftHighX(yIndex);

        if yWeight ~= 0
            shiftH = shiftH + yWeight*( shiftHighX(yIndex+1) - shiftH);
        end

        shift = shift + xWeight*(shiftH - shift);    
    end

end