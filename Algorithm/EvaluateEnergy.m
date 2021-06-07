function [W_int,W_ex,W_clk,W_tot] = EvaluateEnergy(stack_driver, stack_mol, Vout, CK)
%first driver

%settings is conformation, internal, polarization, clock
settings.evalEnergy=[0 0 1 0];
    
% %dots
% D_DOT1 = stack_driver.stack(1).charge(1);
% D_DOT2 = stack_driver.stack(1).charge(2);
% D_DOT3 = stack_driver.stack(1).charge(3);
% D_DOT4 = stack_driver.stack(1).charge(4);

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
    mm = stack_mol.stack(ii).molType;
    [M_DOT1.q, M_DOT2.q, M_DOT3.q, M_DOT4.q] = applyTranschar(Vout(ii),stack_mol.stack(ii).clock,CK.stack(mm+1));
    
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
W_0 = 0;
% Pz=99999999; Py=1.1101e-37; Px=99999999; 7.6720e-33 %bisferrocene
Pz=99999999; Py=3.6716e-38; Px=99999999; %diallylbutano
mu0= [0 7.671972000000000e-33 0]; %diallylbutano
% clock = 2;

%evalute total conformation energy
W_0_TOT = 0;
if settings.evalEnergy(1)==1
    W_0_TOT =  length(mol)*W_0;
end

%evaluate internal energy
W_int = 0;
if settings.evalEnergy(2)==1
    for ii_mol = 1:length(mol)
         W_int(ii_mol) = EvaluateInternalEnergy( mol(ii_mol), Px, Py, Pz, mu0);
    end
end
W_int_sum = sum(W_int);

%evaluate exchange energy
W_ex = 0;
if settings.evalEnergy(3)==1
    for ii_mol = 1:length(mol)
        for jj_mol = (ii_mol+1):length(mol)
            W_ex = W_ex + EvaluateExchangeEnergy( mol(ii_mol), mol(jj_mol));
        end
    end
end

%evaluate clock energy
W_clk = 0;
if settings.evalEnergy(4)==1
    for ii_mol = 1:length(mol)
         W_clk = W_clk + EvaluateMolEnergyV3( mol(ii_mol), -clock, 0, 0) - + EvaluateMolEnergyV3( mol(ii_mol), 0, 0, 0);
    end
end

%evaluate total energy
W_tot = W_0_TOT + W_int_sum + W_ex + W_clk;

%convert energies to eV
qq=1.6e-19;
W_ex = W_ex/qq;
W_int = W_int_sum/qq;
W_tot = W_tot/qq;

end

