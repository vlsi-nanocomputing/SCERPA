function stack_clock = createClockTable(stack_mol,circuit)

    switch circuit.clockMode
        case 'phase'
            for ii_mol=1:stack_mol.num

                %add to stack_clock
                stack_clock(ii_mol,:) =[stack_mol.stack(ii_mol).identifier, num2cell(circuit.stack_phase(stack_mol.stack(ii_mol).phase,:))];
            end
            
        case 'phase_level'
            
            %initially set clock of the phase
            for ii_mol=1:stack_mol.num
                stack_clock(ii_mol,:) =[stack_mol.stack(ii_mol).identifier, num2cell(circuit.stack_phase(stack_mol.stack(ii_mol).phase,:))];
            end
            
            %save the value of clock for levelling
            stack_clock_nolevel = stack_clock;
            
            nTimes = size(stack_clock,2)-1;
                   
            %gap dimension (at the moment it is fixed to 1 nm -> two molecules are affected)
            halfGap = 1;
                  
            %construct map of molecules
            circuitPhaseMap = 0;
            circuitAssociationMap = 0;
            for ii_mol=1:stack_mol.num
                [coord] = sscanf(stack_mol.stack(ii_mol).position,'[%d %d %d]');
                circuitPhaseMap(coord(2)+1,coord(3)+1) = stack_mol.stack(ii_mol).phase;
                circuitAssociationMap(coord(2)+1,coord(3)+1) = ii_mol;
            end

            %number of phases on the circuit
            numberOfAvailablePhases =  max(max(circuitPhaseMap));
            
            %enlarge map to avoid errors moving window outside map borders
            [circuitXLenght,circuitYLenght] = size(circuitPhaseMap);
            phaseMap_enl = zeros(circuitXLenght+halfGap*2,circuitYLenght+halfGap*2);
                x_min_enl = 1+halfGap; 
                x_max_enl = circuitXLenght+halfGap;
                y_min_enl = 1+halfGap; 
                y_max_enl = circuitYLenght+halfGap;
            phaseMap_enl(x_min_enl:x_max_enl,y_min_enl:y_max_enl) = circuitPhaseMap;
            
           
            
            for xx_enl=x_min_enl:x_max_enl
                for yy_enl=y_min_enl:y_max_enl
                    
                    %for each molecule, check if there is at least a
                    %molecule with different phase in the vicinity
                    
                    %get phase of current molecule
                    currentMolPhase = phaseMap_enl(xx_enl,yy_enl);
                    
                    %create a window around the molecule, enlargment-large,
                    windowPhases = phaseMap_enl(xx_enl-halfGap:xx_enl+halfGap,yy_enl-halfGap:yy_enl+halfGap);
                    
                    %molecule is a border if:
                    % molecule is present (currentMolPhase is not zero)
                    % there is at least a molecule with different phase and
                    % that phase is not zero (molecule exists, not vacuum)   
                    [xx_window_borders_list_row, yy_window_borders_list_row] = find(currentMolPhase * (windowPhases~=currentMolPhase) .* (windowPhases~=0));
                    
                    if ~isempty(xx_window_borders_list_row)

                        %among borders, level the field
                        centerMol_inStack = circuitAssociationMap(xx_enl-halfGap,yy_enl-halfGap);
                        
                        %loop on neighbor molecules
                        min_distance_border_inWindow = Inf*ones(1,numberOfAvailablePhases);
                        
                        interphaseClockContrib = zeros(numberOfAvailablePhases,nTimes);
                        for cc=1:length(xx_window_borders_list_row)
                            x_border_enl = (xx_enl-halfGap) + (xx_window_borders_list_row(cc)) - (halfGap+1);
                            y_border_enl = (yy_enl-halfGap) + (yy_window_borders_list_row(cc)) - (halfGap+1);
                            
                            neighborMol_inStack = circuitAssociationMap(x_border_enl,y_border_enl);
                            neighborMolPhase = stack_mol.stack(neighborMol_inStack).phase;
                            
                            %eval_distance_of molecules
                            distance_currentBorder =  sqrt(...
                                (stack_mol.stack(centerMol_inStack).charge(end).x - stack_mol.stack(neighborMol_inStack).charge(end).x)^2 + ...
                                (stack_mol.stack(centerMol_inStack).charge(end).y - stack_mol.stack(neighborMol_inStack).charge(end).y)^2 + ...
                                (stack_mol.stack(centerMol_inStack).charge(end).z - stack_mol.stack(neighborMol_inStack).charge(end).z)^2);
                            
                            %eval contribution from other phase
                            if distance_currentBorder < min_distance_border_inWindow(neighborMolPhase)
                                
                                min_distance_border_inWindow(neighborMolPhase) = distance_currentBorder;
                                
                                voltageSlope = 0.017; %V/A
                                %level the clock
%                                 stack_clock(centerMol_inStack,[2:end]) = num2cell(0.75*cell2mat(stack_clock_nolevel(centerMol_inStack,2:end)) + 0.25*cell2mat(stack_clock_nolevel(neighborMol_inStack,2:end)));
                                standardClock = cell2mat(stack_clock_nolevel(neighborMol_inStack,2:end));
                                interphaseClockContrib(neighborMolPhase,:) = max(abs(standardClock) - voltageSlope*distance_currentBorder,0).*sign(standardClock);

                            end
                            
                            
                        end
                        
                        %evaluate gap_reduction_factor
                        gapWindowWidth = 1:halfGap-1;
                        
                        %create a window around the center of the molecule
                        %with increasing width 
                        distanceFromElectrode = 1;
                        for gg_gap = gapWindowWidth
                            %create window
                            windowPhases_center = size(windowPhases,1)/2 +0.5;
                            gapWindowPhases = windowPhases(windowPhases_center-gg_gap:windowPhases_center+gg_gap,windowPhases_center-gg_gap:windowPhases_center+gg_gap);
                            
                            %if there is at least a single molecule, so
                            %depth is correct, otherwise increase depth
                            if isempty(find(gapWindowPhases ~= currentMolPhase))
                                distanceFromElectrode = distanceFromElectrode + 1;
                                break;
                            end
                            
                        end
                        
                        gap_reduction_factor = 0.25*distanceFromElectrode*10;%0.82;
                        
                        %Apply all corrections
                        stack_clock(centerMol_inStack,[2:end]) = num2cell(min(max(gap_reduction_factor*cell2mat(stack_clock_nolevel(centerMol_inStack,2:end)) + sum(interphaseClockContrib,1),-2),2));

                    end
                    
                end
            end
            
    end
    
end