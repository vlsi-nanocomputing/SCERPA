function [ stack_driver_effect ] = yDrivers_effect( stack_driver, stack_mol)
    
    %step = size(stack_potential,1);
    stack_driver_effect(stack_mol.num)=0;
    for ii=1:stack_driver.num
        for jj =1:stack_mol.num
            V_effect = ChargeBased_CalPotential(stack_driver.stack(ii),stack_mol.stack(jj));
            %stack_potential(size(stack_potential,1), jj) = stack_potential(size(stack_potential,1), jj) + V_effect;
            stack_driver_effect(jj) = stack_driver_effect(jj) + V_effect;
        end   
    end
end

