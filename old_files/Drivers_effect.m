function [ stack_potential, stack_driver_effect ] = Drivers_effect( stack_potential, stack_driver, stack_mol)
    
    %step = size(stack_potential,1);
    
    for ii=1:stack_driver.num
        for jj =1:stack_mol.num
            V_effect = ChargeBased_CalPotential(stack_driver.stack(ii),stack_mol.stack(jj));
            stack_potential(size(stack_potential,1), jj) = stack_potential(size(stack_potential,1), jj) + V_effect;
            driv_effect(jj) = V_effect;
        end
        stack_driver_effect(ii,:) = driv_effect;       
    end
end

