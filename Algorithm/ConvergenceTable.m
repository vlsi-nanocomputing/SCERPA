function [] = ConvergenceTable(stack_mol,pre_driver_effect,Vout,CK,max_error)

convergenceMatrix = zeros(stack_mol.num, stack_mol.num + 4);

for ii = 1:stack_mol.num %charge update
    mm = stack_mol.stack(ii).molType;
    [Q1, Q2, Q3, Q4] = applyTranschar(Vout(ii),stack_mol.stack(ii).clock,CK.stack(mm+1));
    stack_mol.stack(ii).charge(1).q =  Q1;    
    stack_mol.stack(ii).charge(2).q =  Q2;   
    stack_mol.stack(ii).charge(3).q =  Q3;   
    stack_mol.stack(ii).charge(4).q =  Q4;  
end
    
for ii = 1:stack_mol.num
    
    %evaluate driver
    convergenceMatrix(ii,1) = sum(pre_driver_effect(:,ii));
    
    %contibutions
    for jj = 1:stack_mol.num
        if jj~=ii
            convergenceMatrix(ii,1+jj) = ChargeBased_CalPotential(stack_mol.stack(jj), stack_mol.stack(ii));
        end
    end
    
    %evaluated Vout
    convergenceMatrix(ii,stack_mol.num+2) = sum(convergenceMatrix(ii,1:stack_mol.num+1));
    
    %algorithm Vout
    convergenceMatrix(ii,stack_mol.num+3) = Vout(ii);
    
    %error
    convergenceMatrix(ii,stack_mol.num+4) = Vout(ii) - convergenceMatrix(ii,stack_mol.num+2);

end

%disp(convergenceMatrix)
fprintf('Maximum allowed SCERPA error is: %10f\n',max_error);
fprintf('Average voltage error is: %10f\n',mean(convergenceMatrix(:,end)));
fprintf('Maximum voltage error is: %10f\n',max(convergenceMatrix(:,end)));

pause
end