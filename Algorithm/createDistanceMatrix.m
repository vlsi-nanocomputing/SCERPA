function [DIST] = createDistanceMatrix(stack_mol)
%DIST[MOL1][MOL2][CHARGE1][CHARGE2]
N_charges = 4;

%preallocation
A = zeros(stack_mol.num,stack_mol.num,N_charges,N_charges);
[mG,nG] = ndgrid(1:N_charges,1:N_charges); % grid points for loop on charges vectorized 

%loop on molecules
for ii = 1:stack_mol.num
    for jj = (ii+1):stack_mol.num

        %loop on charges now vectorized, before was 
        %for nn=1:N_charges 
        % for mm =1:N_charges
        
        %distance eval
        tmp = sqrt(...
            ([stack_mol.stack(ii).charge(mG).x] - [stack_mol.stack(jj).charge(nG).x]).^2 + ...
            ([stack_mol.stack(ii).charge(mG).y] - [stack_mol.stack(jj).charge(nG).y]).^2 + ...
            ([stack_mol.stack(ii).charge(mG).z] - [stack_mol.stack(jj).charge(nG).z]).^2);
        %from previous line we get a line vector because of struct presence, so we reshape it below
        A(ii,jj,1:N_charges,1:N_charges) = reshape(tmp,N_charges,N_charges); 
    end
end
%transpose
DIST_complete = A + permute(A,[2,1,4,3]); % calculate the symmetric part through permutation of dimensions
DIST(:,:,:,1:2) = DIST_complete(:,:,:,1:2); % only these values neede, save memory
end