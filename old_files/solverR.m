Vout = zeros(stack_mol.num,1);
pre_driver_effect = zeros(1, stack_mol.num);

stack_potential = zeros(2, stack_mol.num);
stack_mol = Next_Clock( stack_mol, stack_clock, 'reset');
Charge_on_wire_done = DotChargeCal(stack_potential(1,:), stack_mol, CK); 
Function_Plotting(Vout,Charge_on_wire_done, stack_mol, stack_driver,settings.fig_saver,5000);

driver_is_changed_flag = 0;

%set initial driver to zero (no previous driver at first step)
stack_driver_effect = 0;


for ii = 2:size(stack_clock,2)
    Vout_dr_take_out = zeros(1,stack_driver.num);
	for ff=1:stack_driver.num
        for tt=1:size(driver_values,1)
            if strcmp(stack_driver.stack(ff).identifier{1},driver_values{tt,1})
%                 if driver_values{tt,ii} == 1 %windows version
%                	if driver_values{tt,ii} == '1'
%                     stack_driver.stack(ff).charge(1).q = 0.003;
%                     stack_driver.stack(ff).charge(2).q = 0.9270;
%                     stack_driver.stack(ff).charge(3).q = -0.212;
%                     stack_driver.stack(ff).charge(4).q = 0.283;
%                    	driver_is_changed_flag = 1;
% %               	elseif driver_values{tt,ii} == 0 %windows version
%                 elseif driver_values{tt,ii} == '0'
%                     stack_driver.stack(ff).charge(1).q = 0.9283;
%                     stack_driver.stack(ff).charge(2).q = 7.0011e-04;
%                     stack_driver.stack(ff).charge(3).q = -0.2120;
%                     stack_driver.stack(ff).charge(4).q = 0.2830;
%                     driver_is_changed_flag = 1;
%                 end
        
            %NEW VERSION
            [P1, P2, P3, P4] = SearchValues( driver_values{tt,ii}, +2, CK );
            [ Q1, Q2,  Q3, Q4 ] = Intersection( driver_values{tt,ii}, +2, P1, P2, P3, P4 );
            stack_driver.stack(ff).charge(1).q =  Q1;    
            stack_driver.stack(ff).charge(2).q =  Q2;   
            stack_driver.stack(ff).charge(3).q =  Q3;   
            stack_driver.stack(ff).charge(4).q =  Q4;   
            
            driver_is_changed_flag = 1;
            end
        end
	end 


    if driver_is_changed_flag == 1
        %========= ACTIVATION DRIVER  ===============================================================================================
        Function_Saver(driver_is_changed_flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver)
        driver_is_changed_flag = 0;
        
        if ii < 3 %first step
            %Driver Effect Evaluation
            [stack_potential, stack_driver_effect] = Drivers_effect(stack_potential, stack_driver, stack_mol);
            pre_driver_effect = stack_driver_effect;
        
            stack_mol = Next_Clock(stack_mol, stack_clock, ii);
            Vout = sum(stack_potential,1)';
 
            clock_eff = Clock_Change(Vout',Charge_on_wire_done,stack_mol, CK);
            stack_potential = [Vout'; clock_eff];
        
            [Vout, stack_potential] = MQCAWireCalCharge(stack_potential,stack_mol, CK, settings);
            Charge_on_wire_done = DotChargeCal(Vout', stack_mol, CK);        

        else
            %clock  
            pre_clock_effect = Clock_Change(Vout',Charge_on_wire_done,stack_mol,CK);
            stack_mol = Next_Clock( stack_mol, stack_clock, ii);

            Vout = sum(stack_potential(1:size(stack_potential,1),:))';
       
            clock_eff=Clock_Change(Vout',Charge_on_wire_done,stack_mol,CK);
            
            %driver
            old_driver = sum(pre_driver_effect,1);
            [~, pre_driver_effect] = Drivers_effect(stack_potential, stack_driver, stack_mol);
            new_driver = sum(pre_driver_effect,1);
            
            %sum driver and clock effects
            stack_potential = [Vout'; clock_eff  - pre_clock_effect - old_driver + new_driver];

            [Vout, stack_potential] = MQCAWireCalCharge(stack_potential,stack_mol, CK, settings);
            Charge_on_wire_done = DotChargeCal(Vout',stack_mol, CK);
        
        end
        
        Function_Plotting(Vout, Charge_on_wire_done, stack_mol, stack_driver, settings.fig_saver, 3*ii-2);
        Function_Saver(driver_is_changed_flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver);    
        
%         %Driver Effect Evaluation
%         [stack_potential, stack_driver_effect] = Drivers_effect(stack_potential, stack_driver, stack_mol);
%         stack_potential(length(stack_potential(:,1)),:) = stack_potential(length(stack_potential(:,1)),:) - sum(pre_driver_effect,1);
%         pre_driver_effect = stack_driver_effect;
%         
%         stack_mol = Next_Clock( stack_mol, stack_clock, ii);
%         Vout = sum(stack_potential,1)';
%  
%         clock_eff = Clock_Change(Vout',Charge_on_wire_done,stack_mol, CK);
%         stack_potential = [Vout'; clock_eff];
%         
%         [Vout, stack_potential] = MQCAWireCalCharge(stack_potential,stack_mol, CK, max_step);
%         Charge_on_wire_done = DotChargeCal(Vout', stack_mol, CK);        
% 
%         Function_Plotting(Vout, Charge_on_wire_done, stack_mol, stack_driver,fig_saver, 3*ii-2);
%         Function_Saver(driver_is_changed_flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver);        
%             
%========= INTERACTION & CLOCK CHANGING ====================================================================================
        run('ConvergenceTable.m')
    else         
        pre_clock_effect = Clock_Change(Vout',Charge_on_wire_done,stack_mol,CK);
        stack_mol = Next_Clock( stack_mol, stack_clock, ii);

        Vout = sum(stack_potential(1:size(stack_potential,1),:))';
       
        clock_eff=Clock_Change(Vout',Charge_on_wire_done,stack_mol,CK);
        stack_potential = [Vout'; clock_eff  - pre_clock_effect];

        [Vout, stack_potential] = MQCAWireCalCharge(stack_potential,stack_mol, CK, settings);
        Charge_on_wire_done = DotChargeCal(Vout',stack_mol, CK);
        
        Function_Plotting(Vout, Charge_on_wire_done, stack_mol, stack_driver,settings.fig_saver, 3*ii);
        Function_Saver(driver_is_changed_flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver); 
        run('ConvergenceTable.m')
        
% %        working without driver changes:
% %         ========= ACTIVATION DRIVER  ===============================================================================================
%         Function_Saver(driver_is_changed_flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver)
%         driver_is_changed_flag = 0;
%         
%         if ii > 2
% %             %Take out previous Driver Effect
% %             driver_effect_take_off = Vout'-Vout_dr_take_out;
% %             Vout_dr_take_out = TakeOut_Driver(driver_effect_take_off,Charge_on_wire_done,stack_mol,CK);
% %             stack_potential = [driver_effect_take_off;Vout_dr_take_off];
% %             [Vout, stack_potential] = MQCAWireCalCharge(stack_potential,stack_mol, CK, max_step);
% %             Charge_on_wire_done = DotChargeCal(Vout',stack_mol,CK);
% 
%             %Take out previous Driver Effect
%             stack_potential = [Vout' - sum(pre_driver_effect,1)]; %remove previous driver
%         end  
%         
%         %Driver Effect Evaluation
%         [stack_potential, stack_driver_effect] = Drivers_effect(stack_potential, stack_driver, stack_mol);
% %         pre_driver_effect = stack_potential(size(stack_potential,1),:); 
%         pre_driver_effect = stack_driver_effect;
%         
%         stack_mol = Next_Clock( stack_mol, stack_clock, ii);
% %         Vout = sum(stack_potential(1:size(stack_potential,1),:))';
%         Vout = sum(stack_potential,1)';
%  
%         clock_eff = Clock_Change(Vout',Charge_on_wire_done,stack_mol, CK);
%         stack_potential = [Vout'; clock_eff];
%         
%         [Vout, stack_potential] = MQCAWireCalCharge(stack_potential,stack_mol, CK, max_step);
%         Charge_on_wire_done = DotChargeCal(Vout', stack_mol, CK);        
% 
%         Function_Plotting(Vout, Charge_on_wire_done, stack_mol, stack_driver,fig_saver, 3*ii-2);
%         Function_Saver(driver_is_changed_flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver);        
%         
% %========= INTERACTION & CLOCK CHANGING ====================================================================================
%         run('ydebug_table.m')
%     else         
%         pre_clock_effect = Clock_Change(Vout',Charge_on_wire_done,stack_mol,CK);
%         stack_mol = Next_Clock( stack_mol, stack_clock, ii);
% 
%         Vout = sum(stack_potential(1:size(stack_potential,1),:))';
%        
%         clock_eff=Clock_Change(Vout',Charge_on_wire_done,stack_mol,CK);
%         stack_potential = [Vout'; clock_eff  - pre_clock_effect];
% 
% 
%         [Vout, stack_potential] = MQCAWireCalCharge(stack_potential,stack_mol, CK, max_step);
%         Charge_on_wire_done = DotChargeCal(Vout',stack_mol, CK);
%         
%  
%         Function_Plotting(Vout, Charge_on_wire_done, stack_mol, stack_driver,fig_saver, 3*ii);
%         Function_Saver(driver_is_changed_flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver); 
%         run('ydebug_table.m')
    end
end