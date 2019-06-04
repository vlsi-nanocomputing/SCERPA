function [W_int,W_ex,W_clk,W_tot] = EvaluateEnergy(stack_driver, stack_mol, Vout, CK)
%first driver

%dots
D_DOT1 = stack_driver.stack(1).charge(1);
D_DOT2 = stack_driver.stack(1).charge(2);
D_DOT3 = stack_driver.stack(1).charge(3);
D_DOT4 = stack_driver.stack(1).charge(4);

%add drivers
for ii = 1:stack_driver.num %system creation: driver
    
    %dots
    D_DOT1 = stack_driver.stack(ii).charge(1);
    D_DOT2 = stack_driver.stack(ii).charge(2);
    D_DOT3 = stack_driver.stack(ii).charge(3);
    D_DOT4 = stack_driver.stack(ii).charge(4);
    
    %molecule struct creation
    mol(ii).x = [D_DOT1.x D_DOT2.x D_DOT3.x D_DOT4.x];
    mol(ii).y = [D_DOT1.y D_DOT2.y D_DOT3.y D_DOT4.y];
    mol(ii).z = [D_DOT1.z D_DOT2.z D_DOT3.z D_DOT4.z];
    mol(ii).espCharge = [D_DOT1.q D_DOT2.q D_DOT3.q D_DOT4.q];
    mol(ii).n_atoms = 4;
    mol(ii).totalCharge = sum(mol(ii).espCharge);
    mol(ii).element = {'DOT1','DOT2','DOT3','DOT4'};
    
end

%add other molecules
for ii_system = stack_driver.num+1:stack_mol.num+stack_driver.num 
       
    
    ii = ii_system - stack_driver.num;
    
    %dots
    M_DOT1 = stack_mol.stack(ii).charge(1);
    M_DOT2 = stack_mol.stack(ii).charge(2);
    M_DOT3 = stack_mol.stack(ii).charge(3);
    M_DOT4 = stack_mol.stack(ii).charge(4);
    
    %update charges
    [P1, P2, P3, P4] = SearchValues( Vout(ii), stack_mol.stack(ii).clock, CK );
    [ M_DOT1.q, M_DOT2.q,  M_DOT3.q, M_DOT4.q ] = Intersection( Vout(ii), stack_mol.stack(ii).clock, P1, P2, P3, P4 );
    
    %molecule struct creation
    mol(ii_system).x = [M_DOT1.x M_DOT2.x M_DOT3.x M_DOT4.x];
    mol(ii_system).y = [M_DOT1.y M_DOT2.y M_DOT3.y M_DOT4.y];
    mol(ii_system).z = [M_DOT1.z M_DOT2.z M_DOT3.z M_DOT4.z];
    mol(ii_system).espCharge = [M_DOT1.q M_DOT2.q M_DOT3.q M_DOT4.q];
    mol(ii_system).n_atoms = 4;
    mol(ii_system).totalCharge = sum(mol(ii_system).espCharge);
    mol(ii_system).element = {'DOT1','DOT2','DOT3','DOT4'};

end

%molecule data
Pz=99999999; Py=1.1101e-37; Px=99999999;
mu0= [0 -4.0756e-30 0];
clock = 2;

%evaluate internal energy
W_int = 0;
for ii_mol = 1:length(mol)
     W_int(ii_mol) = EvaluateInternalEnergy( mol(ii_mol), Px, Py, Pz, mu0);
end
W_int_sum = sum(W_int);

%evaluate exchange energy
W_ex = 0;
for ii_mol = 1:length(mol)
    for jj_mol = (ii_mol+1):length(mol)
     W_ex = W_ex + EvaluateExchangeEnergy( mol(ii_mol), mol(jj_mol));
    end
end

%evaluate clock energy
W_clk = 0;
for ii_mol = 1:length(mol)
     W_clk = W_clk + EvaluateMolEnergyV3( mol(ii_mol), -clock, 0, 0) - + EvaluateMolEnergyV3( mol(ii_mol), 0, 0, 0);
end

%evaluate total energy
W_tot = W_ex + W_int_sum;%+ W_clock(voltage_step);

qq=1.6e-19;

W_ex = W_ex/qq;
W_int = W_int_sum/qq;
W_tot = W_tot/qq;

end

