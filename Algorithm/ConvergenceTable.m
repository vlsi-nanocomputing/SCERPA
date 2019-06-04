% DEBUG1: generation of table, each line is a molecule, N molecules:
% Driver, N contributions, sum of contributions and driver, Vout

% DEBUG_table = zeros(stack_mol.num, stack_mol.num + 5);
DEBUG_table = zeros(stack_mol.num, stack_mol.num + 4);

for DEBUG_ii = 1:stack_mol.num %charge update
    [P1, P2, P3, P4] = SearchValues( Vout(DEBUG_ii), stack_mol.stack(DEBUG_ii).clock, CK );
    [ Q1, Q2,  Q3, Q4 ] = Intersection( Vout(DEBUG_ii), stack_mol.stack(DEBUG_ii).clock, P1, P2, P3, P4 );
    stack_mol.stack(DEBUG_ii).charge(1).q =  Q1;    
    stack_mol.stack(DEBUG_ii).charge(2).q =  Q2;   
    stack_mol.stack(DEBUG_ii).charge(3).q =  Q3;   
    stack_mol.stack(DEBUG_ii).charge(4).q =  Q4;  
end
    
for DEBUG_ii = 1:stack_mol.num
    
    %evaluate driver
    DEBUG_table(DEBUG_ii,1) = sum(pre_driver_effect(:,DEBUG_ii));
    
    %contibutions
    for DEBUG_jj = 1:stack_mol.num
        if DEBUG_jj~=DEBUG_ii
            DEBUG_table(DEBUG_ii,1+DEBUG_jj) = ChargeBased_CalPotential(stack_mol.stack(DEBUG_jj), stack_mol.stack(DEBUG_ii));
        end
    end
    
    %evaluated Vout
    DEBUG_table(DEBUG_ii,stack_mol.num+2) = sum(DEBUG_table(DEBUG_ii,1:stack_mol.num+1));
    
    %algorithm Vout
    DEBUG_table(DEBUG_ii,stack_mol.num+3) = Vout(DEBUG_ii);
    
    %error
    DEBUG_table(DEBUG_ii,stack_mol.num+4) = Vout(DEBUG_ii) - DEBUG_table(DEBUG_ii,stack_mol.num+2);
%     %algorithm Charges
%     DEBUG_table(DEBUG_ii,stack_mol.num+4) = stack_mol.stack(DEBUG_ii).charge(1).q;
%     DEBUG_table(DEBUG_ii,stack_mol.num+5) = stack_mol.stack(DEBUG_ii).charge(2).q;
end

DEBUG_table

;

% pause