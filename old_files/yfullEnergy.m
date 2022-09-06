%ENERGY EVALUATION (exchange only)
%internal energy= 0
DEBUG_Wi = 0;

%first driver

%dots
DEBUG_D_DOT1 = stack_driver.stack(1).charge(1);
DEBUG_D_DOT2 = stack_driver.stack(1).charge(2);
DEBUG_D_DOT3 = stack_driver.stack(1).charge(3);
DEBUG_D_DOT4 = stack_driver.stack(1).charge(4);

%add drivers
for DEBUG_ii = 1:stack_driver.num %system creation: driver
    
    %dots
    DEBUG_D_DOT1 = stack_driver.stack(DEBUG_ii).charge(1);
    DEBUG_D_DOT2 = stack_driver.stack(DEBUG_ii).charge(2);
    DEBUG_D_DOT3 = stack_driver.stack(DEBUG_ii).charge(3);
    DEBUG_D_DOT4 = stack_driver.stack(DEBUG_ii).charge(4);
    
    %molecule struct creation
    DEBUG_mol(DEBUG_ii).x = [DEBUG_D_DOT1.x DEBUG_D_DOT2.x DEBUG_D_DOT3.x DEBUG_D_DOT4.x];
    DEBUG_mol(DEBUG_ii).y = [DEBUG_D_DOT1.y DEBUG_D_DOT2.y DEBUG_D_DOT3.y DEBUG_D_DOT4.y];
    DEBUG_mol(DEBUG_ii).z = [DEBUG_D_DOT1.z DEBUG_D_DOT2.z DEBUG_D_DOT3.z DEBUG_D_DOT4.z];
    DEBUG_mol(DEBUG_ii).espCharge = [DEBUG_D_DOT1.q DEBUG_D_DOT2.q DEBUG_D_DOT3.q DEBUG_D_DOT4.q];
    DEBUG_mol(DEBUG_ii).n_atoms = 4;
    DEBUG_mol(DEBUG_ii).totalCharge = sum(DEBUG_mol(DEBUG_ii).espCharge);
    DEBUG_mol(DEBUG_ii).element = {'DOT1','DOT2','DOT3','DOT4'};
    
end

%add other molecules
for DEBUG_ii_system = stack_driver.num+1:stack_mol.num+stack_driver.num 
       
    
    DEBUG_ii = DEBUG_ii_system - stack_driver.num;
    
    %dots
    DEBUG_M_DOT1 = stack_mol.stack(DEBUG_ii).charge(1);
    DEBUG_M_DOT2 = stack_mol.stack(DEBUG_ii).charge(2);
    DEBUG_M_DOT3 = stack_mol.stack(DEBUG_ii).charge(3);
    DEBUG_M_DOT4 = stack_mol.stack(DEBUG_ii).charge(4);
    
    %update charges
    [P1, P2, P3, P4] = SearchValues( Vout(DEBUG_ii), stack_mol.stack(DEBUG_ii).clock, CK );
    [ DEBUG_M_DOT1.q, DEBUG_M_DOT2.q,  DEBUG_M_DOT3.q, DEBUG_M_DOT4.q ] = Intersection( Vout(DEBUG_ii), stack_mol.stack(DEBUG_ii).clock, P1, P2, P3, P4 );
    
    %molecule struct creation
    DEBUG_mol(DEBUG_ii_system).x = [DEBUG_M_DOT1.x DEBUG_M_DOT2.x DEBUG_M_DOT3.x DEBUG_M_DOT4.x];
    DEBUG_mol(DEBUG_ii_system).y = [DEBUG_M_DOT1.y DEBUG_M_DOT2.y DEBUG_M_DOT3.y DEBUG_M_DOT4.y];
    DEBUG_mol(DEBUG_ii_system).z = [DEBUG_M_DOT1.z DEBUG_M_DOT2.z DEBUG_M_DOT3.z DEBUG_M_DOT4.z];
    DEBUG_mol(DEBUG_ii_system).espCharge = [DEBUG_M_DOT1.q DEBUG_M_DOT2.q DEBUG_M_DOT3.q DEBUG_M_DOT4.q];
    DEBUG_mol(DEBUG_ii_system).n_atoms = 4;
    DEBUG_mol(DEBUG_ii_system).totalCharge = sum(DEBUG_mol(DEBUG_ii_system).espCharge);
    DEBUG_mol(DEBUG_ii_system).element = {'DOT1','DOT2','DOT3','DOT4'};

end

%molecule data
Pz=99999999; Py=1.1101e-37; Px=99999999;
mu0= [0 -4.0756e-30 0];
clock = 2;

%preallocation
W_ex=0;
W_int=0;
W_clock=0;
W_tot=0;

%evaluate internal energy
W_int = 0;
for ii_mol = 1:length(DEBUG_mol)
     W_int(ii_mol) = EvaluateInternalEnergy( DEBUG_mol(ii_mol), Px, Py, Pz, mu0);
end
W_int_sum = sum(W_int);

%evaluate exchange energy
W_ex = 0;
for ii_mol = 1:length(DEBUG_mol)
    for jj_mol = (ii_mol+1):length(DEBUG_mol)
     W_ex = W_ex + EvaluateExchangeEnergy( DEBUG_mol(ii_mol), DEBUG_mol(jj_mol));
    end
end

%evaluate clock energy
W_clock = 0;
for ii_mol = 1:length(DEBUG_mol)
     W_clock = W_clock + EvaluateMolEnergyV3( DEBUG_mol(ii_mol), -clock, 0, 0) - + EvaluateMolEnergyV3( DEBUG_mol(ii_mol), 0, 0, 0);
end

%evaluate total energy
W_tot = W_ex + W_int_sum;%+ W_clock(voltage_step);

qq=1.6e-19;
W_ex/qq
W_int_sum/qq
W_tot/qq
(W_tot+W_clock)/qq
    
