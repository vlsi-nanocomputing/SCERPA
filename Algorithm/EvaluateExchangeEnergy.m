function [ W ] = EvaluateExchangeEnergy(mol1, mol2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%evaluate single e.s. energies
W1 = EvaluateMolEnergyV3(mol1,0,0,0);
W2 = EvaluateMolEnergyV3(mol2,0,0,0);

%evaluate system e.s. energy
mol_system = AssembleMols(mol1,mol2,0,0,0);
Wtot = EvaluateMolEnergyV3(mol_system,0,0,0);

%evaluate exchange energy
W = Wtot - W1 - W2;
end