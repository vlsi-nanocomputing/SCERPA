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
function stack_clock = createClockTable(stack_mol,circuit)

    switch circuit.clockMode
        
%%% Clock is set with classical 'phase' method
        case 'phase'
            stack_clock = cell(stack_mol.num,size(circuit.stack_phase,2)+1);
            for ii_mol=1:stack_mol.num

                %add to stack_clock
                stack_clock(ii_mol,:) =[stack_mol.stack(ii_mol).identifier, num2cell(circuit.stack_phase(stack_mol.stack(ii_mol).phase,:))];
            end
                    
%%% Clock is set with external clock map given by the user
        case 'map'
            
            %create clock table
            stack_clock = cell(stack_mol.num,length(circuit.ckmap.field(1,:))+1);
            for ii_mol=1:stack_mol.num    
                %add identifier
                stack_clock(ii_mol,1) = {stack_mol.stack(ii_mol).identifier};
            end
            
            %get coordinates
            zvalues = circuit.ckmap.coords(:,1);
            yvalues = circuit.ckmap.coords(:,2);
            
            %find z-limits
            zmin = min(zvalues);
            zmax = max(zvalues);

            %find y-limits
            ymin = min(yvalues);
            ymax = max(yvalues);
            
            %create meshgrid
            [zq,yq] = meshgrid(linspace(zmin,zmax),linspace(ymin,ymax));
                
            for tt=1:length(circuit.ckmap.field(1,:))
                
                %get field values for time tt
                Evalues = circuit.ckmap.field(:,tt);

                %interpolate field on mesh 
                Eq = griddata(zvalues,yvalues,Evalues,zq,yq,'cubic');

                for ii_mol=1:stack_mol.num
                    %molecule position
                    y_mol = stack_mol.stack(ii_mol).charge(3).y;
                    z_mol = stack_mol.stack(ii_mol).charge(3).z;

                    %add field to stack_clock  (range -2/2 forced)                
                    stack_clock(ii_mol,tt+1) = num2cell(min(2,max(-2,meshInterp(zq,yq,Eq,z_mol,y_mol))));
                end
                
                %%%% Runtime Clock Plot
                plot_clock=1;
                if plot_clock==1
                    
                    figure;
                    clf, hold on
                    surf(zq,yq,Eq,'FaceAlpha',0.8,'EdgeColor','none'), 
                    colormap summer
                    colorbar, axis equal
                    title('Clock field distribution [V/nm]')
                    xlabel('Z direction'); ylabel('Y direction'); zlabel('X direction');
                    set(gca,'ydir','reverse') 
                    caxis([-2 2])
                    
                    
                    %draw position of molecules
                    for ii_mol=1:stack_mol.num
                        for cc=1:4
                            plot(stack_mol.stack(ii_mol).charge(cc).z,stack_mol.stack(ii_mol).charge(cc).y,'r.','Markersize',10)
                        end

                    end

                    %wait for user check
                    fprintf('Please check the clock and press a button...')
                    pause
                    fprintf('DONE;\n')
                end
                close all
            end
                
    end
    
end