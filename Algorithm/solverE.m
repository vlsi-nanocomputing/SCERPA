%TODO
% autodamping
% interaction range auto-enlargement
% AR threshold auto-decrease
% flag system (i.e. settings stracture but that can be modified by the
%   software)

Ncharges = 4; 

%find the interaction tree for each molecule, this has to be done if the IR
%mode is active or if the AR mode is active (the IR mode is necessary as it
%defines the AR list)
if settings.enableInteractionRadiusMode || settings.enableActiveRegion
    for ii_mol =1:stack_mol.num

        %create structure for the interaction (RX)
        stack_mol.stack(ii_mol).interactionRXlist = 0;
        number_of_RX_molecules = 0;

        %check all the other molecules
        for jj_mol =1:stack_mol.num

            if jj_mol ~= ii_mol

                %evaluate distance
                %ii_jj_distance = DIST_MATRIX(ii_mol,jj_mol,end,end);
                ii_jj_distance = 0.5*(DIST_MATRIX(ii_mol,jj_mol,1,1)+DIST_MATRIX(ii_mol,jj_mol,2,2)); %average btw r_dot_11 and r_dot_22
                
                %evaluate interaction condition
                if ii_jj_distance <= settings.interactionRadius
                    number_of_RX_molecules = number_of_RX_molecules + 1;
                    stack_mol.stack(ii_mol).interactionRXlist(number_of_RX_molecules) = jj_mol;
                end
            end
        end
    end
end
    
%output IR management
for out_mol =1:stack_output.num

    %create structure for the interaction (RX)
    stack_output.stack(out_mol).interactionRXlist = 0;
    number_of_RX_molecules = 0;

    %check all the other molecules
    for jj_mol =1:stack_mol.num

        %evaluate distance
        distance =  sqrt((stack_mol.stack(jj_mol).charge(end).x - stack_output.stack(out_mol).charge(end).x)^2 + ...
                    (stack_mol.stack(jj_mol).charge(end).y - stack_output.stack(out_mol).charge(end).y)^2 + ...
                    (stack_mol.stack(jj_mol).charge(end).z - stack_output.stack(out_mol).charge(end).z)^2);

        %evaluate interaction condition
        if distance <= settings.interactionRadius
            number_of_RX_molecules = number_of_RX_molecules + 1;
            stack_output.stack(out_mol).interactionRXlist(number_of_RX_molecules) = jj_mol;
        end
    end
end

convergence_absolute = 'true';
pre_driver_effect = 0;
Charge_on_wire_done(stack_mol.num,5)=0; %preallocation charge_on_wire
n_times = size(stack_clock,2)-1;

%create time vector
timeComputation =zeros(1,n_times);

%%Time loop
disp('Starting Time evaluation')
for time = 1:n_times
    
    fprintf('Evaluating time step %.2f of %.2f\n',time,n_times); 
    
    tic
    
    %enable approximations
    refiningMode=0;

    interactionRadiusMode = settings.enableInteractionRadiusMode;

    activeRegionMode = settings.enableActiveRegion;

    %prepare energy stack for this time
    if settings.energyEval==1
        stack_energy(time).time = time;
        stack_energy(time).steps = 0;
    else
        stack_energy = 0;
    end
   
    %Initialize drivers
    for ff=1:stack_driver.num
        for tt=1:size(driver_values,1)
            if strcmp(stack_driver.stack(ff).identifier,driver_values{tt,1})
                mm = stack_driver.stack(ff).molType;
                [Q1, Q2, Q3, Q4] = applyTranschar(driver_values{tt,time+1},+2,CK.stack(mm+1));
                
                %saturation of driver charges (if required)
                if settings.driverSaturation == 1
                    if Q1 > 0.6
                        Q1 = 1;
                        Q2 = 0;
                    elseif Q1 < 0.4
                        Q1 = 0;
                        Q2 = 1;
                    else
                        Q1 = 0.5; 
                        Q2 = 0.5;
                    end
                    Q3 = 0;
                    Q4 = 0;
                end
                
                stack_driver.stack(ff).charge(1).q =  Q1;    
                stack_driver.stack(ff).charge(2).q =  Q2;   
                stack_driver.stack(ff).charge(3).q =  Q3;   
                stack_driver.stack(ff).charge(4).q =  Q4; 
            end
        end
    end 
    
    
    %evaluate driver changes
    %WARNING: qui al posto di mettere il controllo su time si pu? fare sul
    %flag del driver cambiato
    
    if time>1 %not the first time
        
        %save current voltage (before changing)
        preV_beforeDriverChange = Vout;
        
        %Evaluate voltage of the new driver
        V_driver = evaluateDriverEffect( stack_driver, stack_mol);
        
        %switch off the previous driver and switch on the new driver
        Vout = Vout - pre_driver_effect + V_driver;
        
        %determine voltage variation
        voltageVariation = abs(Vout - preV_beforeDriverChange);
        
        %Initialize clocks
        for ii_mol =1:stack_mol.num
            if stack_mol.stack(ii_mol).clock ~= stack_clock{ii_mol,time+1}
                
                %update clock if different
                stack_mol.stack(ii_mol).clock = stack_clock{ii_mol,time+1};
                
                %update charges if new clock %added on 5/09/2019
                mm = stack_mol.stack(ii_mol).molType;
                [Q1, Q2, Q3, Q4] = applyTranschar(Vout(ii_mol),stack_mol.stack(ii_mol).clock,CK.stack(mm+1));
                
                stack_mol.stack(ii_mol).charge(1).q =  Q1;   
                stack_mol.stack(ii_mol).charge(2).q =  Q2;   
                stack_mol.stack(ii_mol).charge(3).q =  Q3;   
                stack_mol.stack(ii_mol).charge(4).q =  Q4;   
                
                %insert molecule in the AR list
                voltageVariation(ii_mol) = 2*settings.activeRegionThreshold;
                
            end
        end
    else %first time
        V_driver = evaluateDriverEffect( stack_driver, stack_mol);
        Vext = [stack_mol.stack(:).Vext];
        Vout = zeros(1,stack_mol.num) + Vext;
        preV_beforeDriverChange = zeros(1,stack_mol.num);
        newVout_wodamping = zeros(1,stack_mol.num);
        voltageVariation = abs(V_driver + Vext); % It should be abs(V_driver - 0)
        
        %Initialize clocks
%         for ii_mol =1:stack_mol.num
%             stack_mol.stack(ii_mol).clock = stack_clock{ii_mol,time+1};
%         end
        [stack_mol.stack.clock] = stack_clock{:,time+1}; %vectorized
    end
    
    
    %Self-Consistent Field evaluation
    max_error=settings.conv_threshold_HP;
    scfStep=0;
    convergence_flag=0;
    
    %print step header
    if settings.verbosity==2
            disp('Starting SCF Evaluation')
            fprintf('STEP - ERROR - MAX_ERROR - DAMPING - IR Flag- Active mols %% [AR Flag]\n')
            fprintf('--------------------------------------------\n')
    end
    
    while(~convergence_flag)
        
        scfStep=scfStep+1; 
        err=0; %assume error=0 (next evaluations will chenage the value if larger)
        
        if settings.verbosity==1 %verbosity mode only scfStep
            disp(scfStep)
        end
        
        %evaluate max_step reached
        if (scfStep==settings.max_step)
            
            %max step reached, increase tolerance (LP Mode)
            max_error=settings.conv_threshold_LP;
            disp('Warning: low precision');
            
            if (scfStep==settings.max_step + settings.LPmode)
                
                %max step reached, LP mode didn't converge, increase tolerance
                max_error=settings.conv_threshold_LLP;
                disp('Warning very low precision');
                if (scfStep==settings.max_step + settings.LPmode + settings.LLPmode)
                    disp('No convergence');
                    pause
                    break;
                end
            end
        end

        %save last voltage for error evaluation
        if scfStep==1 %at first step, the driver effect should not be considered
            preV_afterVoltageVariation = preV_beforeDriverChange;
        else
            preV_afterVoltageVariation = Vout;
        end
        
        newVout_wodamping = Vout;
        
        if activeRegionMode == 1
            activeListMolecule = zeros(1,stack_mol.num);
            activeMolecules = find (voltageVariation > settings.activeRegionThreshold);
            
            for ii=activeMolecules
                activeListMolecule(ii) = 1;
                activeListMolecule(stack_mol.stack(ii).interactionRXlist) = 1;
            end
            
            if settings.plotActiveRegionWindow==1
                plot_activeMol = zeros(1,stack_mol.num);
                plot_activeMol(activeMolecules) = 0.05;

                plot_evaluationMol = zeros(1,stack_mol.num);
%                 plot_evaluationMol(find(activeListMolecule==1)) = 1;
                plot_evaluationMol(activeListMolecule==1) = 0.05;

                figure(2000000), clf, hold on
                    plot(1:stack_mol.num,voltageVariation, [1 stack_mol.num], [settings.activeRegionThreshold settings.activeRegionThreshold], 1:stack_mol.num, plot_activeMol, 1:stack_mol.num, plot_evaluationMol)
                    legend('Voltage variation','TH','active','evaluated')
                    drawnow
            end
            
            evaluationRange = find(activeListMolecule==1);
            
            %if no active wall is present, disable activeRegionMode
            if isempty(evaluationRange) 
                evaluationRange=1:stack_mol.num;
                activeRegionMode=0;
                disp('Disabling Active Region Mode');
            end
            
        elseif activeRegionMode==0
            activeListMolecule = 0;
            evaluationRange = 1:stack_mol.num;
            activeRegionMode = 2; %avoid re-evaluation in refining mode
        end
           
        %plot of AR mode
        if settings.plotActiveRegionWindow==1
            plot_activeMol = zeros(1,stack_mol.num);
            plot_activeMol(activeMolecules) = 0.05;

            plot_evaluationMol = zeros(1,stack_mol.num);
    %                 plot_evaluationMol(find(activeListMolecule==1)) = 1;
            plot_evaluationMol(activeListMolecule==1) = 0.05;

            figure(2000000), clf, hold on
                plot(1:stack_mol.num,voltageVariation, [1 stack_mol.num], [settings.activeRegionThreshold settings.activeRegionThreshold], 1:stack_mol.num, plot_activeMol, 1:stack_mol.num, plot_evaluationMol)
                legend('Voltage variation','TH','active','evaluated')
                drawnow
        end
         
        
        %evaluate voltage on each molecule
        for jj_mol=evaluationRange
            
            %insert effect of the driver on ii-th molecule
            Vout(jj_mol)=V_driver(jj_mol) + Vext(jj_mol);

            %if refining is active, evaluate the interaction with all
            %molecules
            if interactionRadiusMode==1 %si pu� fare in modo pi� furbo
                nearMolecules = stack_mol.stack(jj_mol).interactionRXlist;
            else
                nearMolecules = 1:stack_mol.num;
            end
            
            %evaluate voltage generated by other molecules
            for ii_mol = nearMolecules
                if ii_mol~=jj_mol
                    Vout(jj_mol) = Vout(jj_mol) + ChargeBased_CalPotential_DIST(stack_mol,ii_mol,jj_mol,DIST_MATRIX);
                end    
            end

            if settings.immediateUpdate == 1
                %update charges
                newVout_wodamping(jj_mol) = Vout(jj_mol); %save to evaluate convergence
                deltaV = abs(Vout(jj_mol) - preV_afterVoltageVariation(jj_mol));
                if settings.autodamping == 1    
                    if scfStep<=0.8*settings.max_step    
                        if deltaV <= 0.05
                            damping = 1-0.2;
                        elseif deltaV <= 0.15
                            damping = 1-0.4;
                        else
                            damping = 1-0.6;
                        end
                    else
                        damping = 1-0.6;
                    end
                else
                    damping = 1 - settings.damping;
                end
                Vout(jj_mol) = preV_afterVoltageVariation(jj_mol) + damping*(Vout(jj_mol) - preV_afterVoltageVariation(jj_mol));
%                 Vout(jj_mol) = preV_afterVoltageVariation(jj_mol) + (1-settings.y.damping)*(Vout(jj_mol) - preV_afterVoltageVariation(jj_mol));
                
                mm = cell2mat(stack_mol.stack(jj_mol).molType);
                [Q1, Q2, Q3, Q4] = applyTranschar(Vout(jj_mol),stack_mol.stack(jj_mol).clock,CK.stack(mm+1));
                stack_mol.stack(jj_mol).charge(1).q =  Q1;    
                stack_mol.stack(jj_mol).charge(2).q =  Q2;   
                stack_mol.stack(jj_mol).charge(3).q =  Q3;   
                stack_mol.stack(jj_mol).charge(4).q =  Q4;  
            end
            
        end %end of first of two calculation loops

        %delayed update
        if settings.y.immediateUpdate == 0
            newVout_wodamping = Vout;
            deltaV = abs(Vout - preV_afterVoltageVariation);
            if settings.autodamping == 1 
                if scfStep<=0.8*settings.max_step    
                    if deltaV <= 0.05
                        damping = 1-0.2;
                    elseif deltaV <= 0.15
                        damping = 1-0.4;
                    else
                        damping = 1-0.6;
                    end
                else
                    damping = 1-0.6;
                end
            else
                damping = 1 - settings.damping;
            end
            Vout = preV_afterVoltageVariation + damping*(Vout - preV_afterVoltageVariation);
%             Vout = preV_afterVoltageVariation + (1-settings.y.damping)*(Vout - preV_afterVoltageVariation);
            for jj_mol=1:stack_mol.num
                mm = stack_mol.stack(jj_mol).molType;
                %update charges
                [Q1, Q2, Q3, Q4] = applyTranschar(Vout(jj_mol),stack_mol.stack(jj_mol).clock,CK.stack(mm+1));
                stack_mol.stack(jj_mol).charge(1).q =  Q1;   
                stack_mol.stack(jj_mol).charge(2).q =  Q2;   
                stack_mol.stack(jj_mol).charge(3).q =  Q3;   
                stack_mol.stack(jj_mol).charge(4).q =  Q4;   
            end
        end
        
        %convergence evaluation
        voltageVariation = abs(newVout_wodamping-preV_afterVoltageVariation);
        if (strcmp(convergence_absolute,'true'))
                if max(voltageVariation(evaluationRange))< max_error
                    
                    %continue evaluation if refining is required
                    if refiningMode==0 && settings.enableRefining==1
                        %activate Refining Mode and disable IR/AR Modes
                        refiningMode=1;
                        activeRegionMode=0;
                        interactionRadiusMode=0;
                        disp('Refining solution! ActiveRegion and InteractionRadius disabled!')
                    else
                        convergence_flag=1;
                    end
                end
        else
            %%%%% Not implemented
            error('[SCERPA] Relative convergence is not implemented yet!')
        end

        if settings.plotIntermediateSteps == 1
               
            
            %clear intermediate plot figures at first step
            if scfStep == 1
                figure(250000000), clf
            end

            %Plot intermediate state
            intermediatePlot(stack_mol, ...
                stack_driver, ...
                preV_afterVoltageVariation, ...
                newVout_wodamping, ...
                V_driver...
            )
        
            % block the execution if required by the user
            if settings.pauseStep == 1
                pause
            end
            
        end
        
        %save energy
        if settings.energyEval==1
            [W_int,W_ex,W_clk,W_tot] = EvaluateEnergy(stack_driver, stack_mol, Vout, CK);
            stack_energy(time).steps = stack_energy(time).steps+1;
            stack_energy(time).W_int(stack_energy(time).steps) = W_int;
            stack_energy(time).W_ex(stack_energy(time).steps) = W_ex;
            stack_energy(time).W_clk(stack_energy(time).steps) = W_clk;
            stack_energy(time).W_tot(stack_energy(time).steps) = W_tot;
        end
        
        if settings.verbosity==2
            %print log of scf step to console if verbosity mode 2
            fprintf('%d   - %f - %f - %f - %d - %.2f[%d]\n',...
                scfStep,...
                max(voltageVariation(evaluationRange)),...
                max_error,...
                settings.y.damping,...
                interactionRadiusMode,...
                sum(activeListMolecule)/stack_mol.num,...
                activeRegionMode);
        end
        
    end %end of convergence loop


    %save current voltage of the driver
    pre_driver_effect = V_driver;
    
    %Charge_on_wire_done update
    for cc_mol = 1:stack_mol.num
        %number of molecule in the first col
        Charge_on_wire_done(cc_mol,1) = cc_mol; 
        %charges in other cols
        for ii_charge = 1:Ncharges     
            Charge_on_wire_done(cc_mol,ii_charge+1) = stack_mol.stack(cc_mol).charge(ii_charge).q;
        end
    end
   
   
%     run('ConvergenceTable.m')
    timeComputation(time) = toc;
    disp(timeComputation(time))

    %evaluate output
    if stack_output.num ~= 0
        for oo_mol = 1:stack_output.num
            stack_output.stack(oo_mol).Vprobe = 0;
            for ii_mol=stack_output.stack(oo_mol).interactionRXlist
                stack_output.stack(oo_mol).Vprobe = stack_output.stack(oo_mol).Vprobe + ChargeBased_CalPotential(stack_mol.stack(ii_mol),stack_output.stack(oo_mol));
            end    
        end
    end
    
    %plot and save data
    RunTimePlotting(Vout, Charge_on_wire_done, stack_mol, stack_driver, stack_output, settings, 3*time-2);
    Function_Saver(0, time, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver);    
    Function_SaveQSS(time, stack_mol, stack_driver,simulation_file_name);    
    Function_SaveTable(0,settings,stack_mol,stack_driver,stack_output,fileTable, time, Vout, driver_values,timeComputation(time),stack_energy);
    
%     clock_tmp(1,:) = [stack_mol.stack.clock];
%     output_txt(time,:) = [clock_tmp Vout];
    
end %end of time loop

