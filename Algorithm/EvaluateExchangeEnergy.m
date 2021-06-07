function [ W ] = EvaluateExchangeEnergy(mol_1, mol_2)
    %constants
    q = 1.60217662e-19;
    e0 = 8.854187817e-12;
    k = 1/(4*pi*e0);
    
    %evaluate exchange energy
    N1 = length(mol_1.x);
    N2 = length(mol_2.x);
    
    W = 0;
    
    for qq_mol1 = 1:N1
        for qq_mol2 = 1:N2
            
                Qprod = q^2*mol_1.espCharge(qq_mol1)*mol_2.espCharge(qq_mol2);
                
                xdist = 1e-10*(mol_1.x(qq_mol1) - mol_2.x(qq_mol2));
                ydist = 1e-10*(mol_1.y(qq_mol1) - mol_2.y(qq_mol2));
                zdist = 1e-10*(mol_1.z(qq_mol1) - mol_2.z(qq_mol2));
                dist = sqrt(xdist^2 + ydist^2 + zdist^2);
                
                W = W + k*Qprod/dist;
        end
    end
    
end