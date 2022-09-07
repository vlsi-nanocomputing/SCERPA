function [ stack_mol ] = Next_Clock( stack_mol, stack_clock, step )
           
    if strcmp(step,'init')
        for ii=1:stack_mol.num
            stack_mol.stack(ii).pre_clock = 0;
            stack_mol.stack(ii).clock = 0;
        end
    elseif strcmp(step,'reset')
        for ii=1:stack_mol.num
            stack_mol.stack(ii).pre_clock = -2;
            stack_mol.stack(ii).clock = -2;
        end
    else
        for ii=1:stack_mol.num
            for jj=1:size(stack_clock,1)
                if strcmp(stack_clock(jj,1),stack_mol.stack(ii).identifier)
                        stack_mol.stack(ii).pre_clock = stack_mol.stack(ii).clock;
                        stack_mol.stack(ii).clock = stack_clock{ii, step};
                    continue;
                end
            end
        end
    end
end

