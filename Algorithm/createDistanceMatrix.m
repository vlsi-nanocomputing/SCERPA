function [DIST] = createDistanceMatrix(stack_mol)
%DIST[MOL1][MOL2][CHARGE1][CHARGE2]
N_charges = 4;

%preallocation
DIST = zeros(stack_mol.num,stack_mol.num,N_charges,N_charges);

%loop on molecules
for ii = 1:stack_mol.num
    for jj = 1:stack_mol.num

        %loop on charges
        for mm = 1:N_charges
            for nn = 1:N_charges

                %distance eval
                DIST(ii,jj,mm,nn) = sqrt(...
                    (stack_mol.stack(ii).charge(mm).x - stack_mol.stack(jj).charge(nn).x)^2 + ...
                    (stack_mol.stack(ii).charge(mm).y - stack_mol.stack(jj).charge(nn).y)^2 + ...
                    (stack_mol.stack(ii).charge(mm).z - stack_mol.stack(jj).charge(nn).z)^2);

            end
        end
    end
end
    
end