%ENERGY EVALUATION (exchange only)
%internal energy= 0
DEBUG_Wi = 0;

%first driver

%dots
DEBUG_D_DOT1 = stack_driver.stack(1).charge(1);
DEBUG_D_DOT2 = stack_driver.stack(1).charge(2);
DEBUG_D_DOT3 = stack_driver.stack(1).charge(3);
DEBUG_D_DOT4 = stack_driver.stack(1).charge(4);

%molecule struct creation
DEBUG_system.x = [DEBUG_D_DOT1.x DEBUG_D_DOT2.x DEBUG_D_DOT3.x DEBUG_D_DOT4.x];
DEBUG_system.y = [DEBUG_D_DOT1.y DEBUG_D_DOT2.y DEBUG_D_DOT3.y DEBUG_D_DOT4.y];
DEBUG_system.z = [DEBUG_D_DOT1.z DEBUG_D_DOT2.z DEBUG_D_DOT3.z DEBUG_D_DOT4.z];
DEBUG_system.espCharge = [DEBUG_D_DOT1.q DEBUG_D_DOT2.q DEBUG_D_DOT3.q DEBUG_D_DOT4.q];
DEBUG_system.n_atoms = 4;
DEBUG_system.totalCharge = sum(DEBUG_system.espCharge);
DEBUG_system.element = {'DOT1','DOT2','DOT3','DOT4'};
    
DEBUG_Wi = EvaluateMolEnergyV3(DEBUG_system,0,0,0);
%add other drivers
for DEBUG_ii = 2:stack_driver.num %system creation: driver
    
    %dots
    DEBUG_D_DOT1 = stack_driver.stack(DEBUG_ii).charge(1);
    DEBUG_D_DOT2 = stack_driver.stack(DEBUG_ii).charge(2);
    DEBUG_D_DOT3 = stack_driver.stack(DEBUG_ii).charge(3);
    DEBUG_D_DOT4 = stack_driver.stack(DEBUG_ii).charge(4);
    
    %molecule struct creation
    DEBUG_drivermol.x = [DEBUG_D_DOT1.x DEBUG_D_DOT2.x DEBUG_D_DOT3.x DEBUG_D_DOT4.x];
    DEBUG_drivermol.y = [DEBUG_D_DOT1.y DEBUG_D_DOT2.y DEBUG_D_DOT3.y DEBUG_D_DOT4.y];
    DEBUG_drivermol.z = [DEBUG_D_DOT1.z DEBUG_D_DOT2.z DEBUG_D_DOT3.z DEBUG_D_DOT4.z];
    DEBUG_drivermol.espCharge = [DEBUG_D_DOT1.q DEBUG_D_DOT2.q DEBUG_D_DOT3.q DEBUG_D_DOT4.q];
    DEBUG_drivermol.n_atoms = 4;
    DEBUG_drivermol.totalCharge = sum(DEBUG_drivermol.espCharge);
    DEBUG_drivermol.element = {'DOT1','DOT2','DOT3','DOT4'};
    
    %assemble
    DEBUG_system=AssembleMols(DEBUG_system,DEBUG_drivermol,0,0,0);
    
    %eval internal energy
    DEBUG_Wi = DEBUG_Wi + EvaluateMolEnergyV3(DEBUG_system,0,0,0);
end

%add other molecules
for DEBUG_ii = 1:stack_mol.num %system creation: driver
            
    %dots
    DEBUG_M_DOT1 = stack_mol.stack(DEBUG_ii).charge(1);
    DEBUG_M_DOT2 = stack_mol.stack(DEBUG_ii).charge(2);
    DEBUG_M_DOT3 = stack_mol.stack(DEBUG_ii).charge(3);
    DEBUG_M_DOT4 = stack_mol.stack(DEBUG_ii).charge(4);
    
    %update charges
    [P1, P2, P3, P4] = SearchValues( Vout(DEBUG_ii), stack_mol.stack(DEBUG_ii).clock, CK );
    [ DEBUG_M_DOT1.q, DEBUG_M_DOT2.q,  DEBUG_M_DOT3.q, DEBUG_M_DOT4.q ] = Intersection( Vout(DEBUG_ii), stack_mol.stack(DEBUG_ii).clock, P1, P2, P3, P4 );
    
    %molecule struct creation
    DEBUG_mol.x = [DEBUG_M_DOT1.x DEBUG_M_DOT2.x DEBUG_M_DOT3.x DEBUG_M_DOT4.x];
    DEBUG_mol.y = [DEBUG_M_DOT1.y DEBUG_M_DOT2.y DEBUG_M_DOT3.y DEBUG_M_DOT4.y];
    DEBUG_mol.z = [DEBUG_M_DOT1.z DEBUG_M_DOT2.z DEBUG_M_DOT3.z DEBUG_M_DOT4.z];
    DEBUG_mol.espCharge = [DEBUG_M_DOT1.q DEBUG_M_DOT2.q DEBUG_M_DOT3.q DEBUG_M_DOT4.q];
    DEBUG_mol.n_atoms = 4;
    DEBUG_mol.totalCharge = sum(DEBUG_drivermol.espCharge);
    DEBUG_mol.element = {'DOT1','DOT2','DOT3','DOT4'};
    
    %assemble
    DEBUG_system=AssembleMols(DEBUG_system,DEBUG_mol,0,0,0);
    
    %internal energy eval
    DEBUG_Wi = DEBUG_Wi + EvaluateMolEnergyV3(DEBUG_mol,0,0,0);
end

%total energy
DEBUG_W = (EvaluateMolEnergyV3(DEBUG_system,0,0,0) - DEBUG_Wi)/1.6e-19

