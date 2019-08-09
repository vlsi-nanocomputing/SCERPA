%reshape transcharacteristics to avoid true interpolation
CK=reshapeTC(CK);

%TODO
% autodamping
% interaction range auto-enlargement
% AR threshold auto-decrease
% better plots
% output waveforms


%find the interaction tree for each molecule, this has to be done if the IR
%mode is active or if the AR mode is active (the IR mode is necessary as it
%defines the AR list)
if settings.enableInteractionRadiusMode == 1 || settings.enableActiveRegion
    for ii_mol =1:stack_mol.num
        %get position of ith molecule (NOT THE BEST WAY TO DO IT)
        pos_ii = [stack_mol.stack(ii_mol).charge(4).x stack_mol.stack(ii_mol).charge(4).y stack_mol.stack(ii_mol).charge(4).z];

        %create structure for the interaction (RX)
        stack_mol.stack(ii_mol).interactionRXlist = 0;
        number_of_RX_molecules = 0;

        %check all the other molecules
        for jj_mol =1:stack_mol.num

            if jj_mol ~= ii_mol

                %get position of jth molecule
                pos_jj = [stack_mol.stack(jj_mol).charge(4).x stack_mol.stack(jj_mol).charge(4).y stack_mol.stack(jj_mol).charge(4).z];

                %evaluate distance
                ii_jj_distance = norm(pos_ii - pos_jj);

                %evaluate interaction condition
                if ii_jj_distance <= settings.interactionRadius
                    number_of_RX_molecules = number_of_RX_molecules + 1;
                    stack_mol.stack(ii_mol).interactionRXlist(number_of_RX_molecules) = jj_mol;
                end
            end
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
for time = 2:n_times+1
    disp('Preparing Time evaluation')
%     disp('Time = ')
%     disp(time)
    fprintf('Evaluation of time = %.2f\n',time);
    
    tic
    %enable approximations
    refiningMode=0;
    
    %activate interactionRadiusmode if enabled
    %     if settings.interactionRadiusMode ==1
    %         interactionRadiusMode=1;
    %     else
    %         interactionRadiusMode = 0;
    %     end
    interactionRadiusMode = settings.enableInteractionRadiusMode;
    
    %activate the ActiveRegion mode if enabled
    %     if settings.enableActiveRegion ==1
    %         activeRegionMode=1;
    %     else
    %         activeRegionMode=0;
    %     end
    activeRegionMode = settings.enableActiveRegion;
    
%     stack_energy(time-1).time = time;
%     stack_energy(time-1).steps = 0;
    
   
    %Initialize drivers
    for ff=1:stack_driver.num
        for tt=1:size(driver_values,1)
            if strcmp(stack_driver.stack(ff).identifier{1},driver_values{tt,1})
                [Q1, Q2, Q3, Q4] = applyTranschar(driver_values{tt,time},+2,CK);
                stack_driver.stack(ff).charge(1).q =  Q1;    
                stack_driver.stack(ff).charge(2).q =  Q2;   
                stack_driver.stack(ff).charge(3).q =  Q3;   
                stack_driver.stack(ff).charge(4).q =  Q4;   
                driverIsChangedFlag=1;
            end
        end
    end 
    
%     %Initialize clocks
%     for ii_mol =1:stack_mol.num
%         stack_mol.stack(ii_mol).clock = stack_clock{ii_mol,time};
%     end

    %evaluate driver changes
    %WARNING: qui al posto di mettere il controllo su time si pu� fare sul
    %flag del driver cambiato
    
    if time>2 %not the first time
        
        %save current voltage (before changing)
        preV_beforeDriverChange = Vout;
        
        %Evaluate voltage of the new driver
        V_driver = yDrivers_effect( stack_driver, stack_mol);
        
        %switch off the previous driver and switch on the new driver
        Vout = Vout - pre_driver_effect + V_driver;
        
        %determine voltage variation
        voltageVariation = abs(Vout - preV_beforeDriverChange);
        
        %Initialize clocks
        for ii_mol =1:stack_mol.num
            if stack_mol.stack(ii_mol).clock ~= stack_clock{ii_mol,time}
                
                %update clock if different
                stack_mol.stack(ii_mol).clock = stack_clock{ii_mol,time};
                
                %insert molecule in the AR list
                voltageVariation(ii_mol) = 2*settings.activeRegionThreshold;
            end
        end
    else %first time
        V_driver = yDrivers_effect( stack_driver, stack_mol);
        Vout = zeros(1,stack_mol.num);
        preV_beforeDriverChange = zeros(1,stack_mol.num);
        newVout_wodamping = zeros(1,stack_mol.num);
        voltageVariation = abs(V_driver); % It should be abs(V_driver - 0)
        
        %Initialize clocks
        for ii_mol =1:stack_mol.num
            stack_mol.stack(ii_mol).clock = stack_clock{ii_mol,time};
        end
    end
    
    %Function_Saver(1, time, fileID, 0, Charge_on_wire_done, stack_mol, stack_driver);     
    
    %Self-Consistent Field evaluation
    max_error=settings.conv_threshold_HP;
    scfStep=0;
    convergence_flag=0;
    
    %print step header
    disp('Starting SCF Evaluation')
    fprintf('STEP - ERROR - MAX_ERROR - DAMPING - IR - AR\n')
    fprintf('--------------------------------------------\n')
    
    while(~convergence_flag)
        
        scfStep=scfStep+1; 
        err=0; %assume error=0 (next evaluations will chenage the value if larger)
        
        %disp(scfStep)
        
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
        preV_afterVoltageVariation = Vout;
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

                figure(2000000)
                    plot(1:stack_mol.num,voltageVariation, [1 stack_mol.num], [settings.activeRegionThreshold settings.activeRegionThreshold], 1:stack_mol.num, plot_activeMol, 1:stack_mol.num, plot_evaluationMol)
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

            figure(2000000)
                plot(1:stack_mol.num,voltageVariation, [1 stack_mol.num], [settings.activeRegionThreshold settings.activeRegionThreshold], 1:stack_mol.num, plot_activeMol, 1:stack_mol.num, plot_evaluationMol)
                drawnow
        end
            
        %evaluate voltage on each molecule
        for jj_mol=evaluationRange

            %insert effect of the driver on ii-th molecule
            Vout(jj_mol)=V_driver(jj_mol); 

            %if refining is active, evaluate the interaction with all
            %molecules
            if interactionRadiusMode==1 %si può fare in modo più furbo
                nearMolecules = stack_mol.stack(jj_mol).interactionRXlist;
            else
                nearMolecules = 1:stack_mol.num;
            end
            
            %evaluate voltage generated by other molecules
            for ii_mol = nearMolecules
                if ii_mol~=jj_mol
                    Vout(jj_mol) = Vout(jj_mol) + ChargeBased_CalPotential(stack_mol.stack(ii_mol), stack_mol.stack(jj_mol));
                end    
            end

            if settings.immediateUpdate == 1
                %update charges
                newVout_wodamping(jj_mol) = Vout(jj_mol); %save to evaluate convergence
                Vout(jj_mol) = preV_afterVoltageVariation(jj_mol) + (1-settings.y.damping)*(Vout(jj_mol) - preV_afterVoltageVariation(jj_mol));
                [Q1, Q2, Q3, Q4] = applyTranschar(Vout(jj_mol),stack_mol.stack(jj_mol).clock,CK);
                stack_mol.stack(jj_mol).charge(1).q =  Q1;    
                stack_mol.stack(jj_mol).charge(2).q =  Q2;   
                stack_mol.stack(jj_mol).charge(3).q =  Q3;   
                stack_mol.stack(jj_mol).charge(4).q =  Q4;  
            end
            
        end %end of first of two calculation loops

        %delayed update
        if settings.y.immediateUpdate == 0
            newVout_wodamping = Vout;
            Vout = preV_afterVoltageVariation + (1-settings.y.damping)*(Vout - preV_afterVoltageVariation);
            for jj_mol=1:stack_mol.num
                %update charges
                [Q1, Q2, Q3, Q4] = applyTranschar(Vout(jj_mol),stack_mol.stack(jj_mol).clock,CK);
                stack_mol.stack(jj_mol).charge(1).q =  Q1;   
                stack_mol.stack(jj_mol).charge(2).q =  Q2;   
                stack_mol.stack(jj_mol).charge(3).q =  Q3;   
                stack_mol.stack(jj_mol).charge(4).q =  Q4;   
            end
        end
        
        %convergence error
        voltageVariation = abs(newVout_wodamping-preV_afterVoltageVariation);
        if (strcmp(convergence_absolute,'true'))
            if max(voltageVariation(evaluationRange))< max_error
                if refiningMode==0 && settings.enableRefining==1
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
        end

        if settings.y.show_intermediate_steps == 1
        %    intermediate  plots
            figure(250000000), clf, hold on
                plot(preV_afterVoltageVariation)
                plot(newVout_wodamping) 
                plot(V_driver)
                plot([1 stack_mol.num],[0 0],'--k')
                legend ('preV','V','driver')
                grid on, grid minor
                axis([1 stack_mol.num -Inf +Inf])
                xlabel('Molecule number')
                ylabel('Input Voltage [V]')

                drawnow
                
            % block the execution if required by the user
            if settings.pauseStep == 1
                pause
            end
            
        end
        
%         %save energy
%         [W_int,W_ex,W_clk,W_tot] = EvaluateEnergy(stack_driver, stack_mol, Vout, CK);
%         stack_energy(time-1).steps = stack_energy(time-1).steps+1;
%         stack_energy(time-1).W_int(stack_energy(time-1).steps) = W_int;
%         stack_energy(time-1).W_ex(stack_energy(time-1).steps) = W_ex;
%         stack_energy(time-1).W_clk(stack_energy(time-1).steps) = W_clk;
%         stack_energy(time-1).W_tot(stack_energy(time-1).steps) = W_tot;

    %print log of scf step to console
    fprintf('%d   - %f - %f - %f - %d - %d\n',...
        scfStep,...
        max(voltageVariation(evaluationRange)),...
        max_error,...
        settings.y.damping,...
        interactionRadiusMode,...
        activeRegionMode);
        
    end %end of convergence loop


    %save current voltage of the driver
    pre_driver_effect = V_driver;
    
    %Charge_on_wire_done update
    for cc_mol = 1:stack_mol.num
        %number of molecule in the first col
        Charge_on_wire_done(cc_mol,1) = cc_mol; 
        %charges in other cols
        for ii_charge = 1:settings.Ncharges     
            Charge_on_wire_done(cc_mol,ii_charge+1) = stack_mol.stack(cc_mol).charge(ii_charge).q;
        end
    end
   
    %run('ConvergenceTable.m')
    timeComputation(time-1) = toc;
    
    %plot and save data
    Function_Plotting(Vout, Charge_on_wire_done, stack_mol, stack_driver,settings.fig_saver, 3*time-2);
    Function_Saver(0, time, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver);    
    
end %end of time loop

