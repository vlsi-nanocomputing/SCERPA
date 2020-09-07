function [ stack_driver_effect ] = evaluateDriverEffect( stack_driver, stack_mol)
    
    %preallocation
    stack_driver_effect(stack_mol.num)=0;
    
    %loop on drivers
    for ii=1:stack_driver.num
        
        %evaluate effect on all the molecules
        for jj =1:stack_mol.num
            V_effect = ChargeBased_CalPotential(stack_driver.stack(ii),stack_mol.stack(jj));
            stack_driver_effect(jj) = stack_driver_effect(jj) + V_effect;
        end   
    end
end

