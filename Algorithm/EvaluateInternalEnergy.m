function [ W ] = EvaluateInternalEnergy( mol, Px, Py, Pz, mu0)
% function [ W ] = EvaluateInternalEnergy( mol, Px, Py, Pz, n_charges_per_molecule, n_mol)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%non conviene fare una funzione che calcoli gi� l'energia del sistema,
%perch� potrebbero esserci molecole con diverso numero di cariche nello
%stesso sistema (tipico quando abbiamo il driver a 3 e le molecole a 91)
%funzione solo per la singola molecola, per adesso, poi vediamo

% il dipolo funziona abbastanza bene sulle cariche aggregate, ma solo su y
% (switching)... poi bisogna lavorare sulla parte di clock, ma se ne
% parler� pi� avanti, forse basta usare le cariche aggregate nuove (ESP
% based). EDIT: mettendo tre cariche funziona anche sulla direzione del
% clock. Ma per ora non importa, basta che funzioni bene sulla direzione di
% switching.

%calcola il dipolo
dipole = EvaluateDipole(mol,[mean(mol.x) mean(mol.y) mean(mol.z)])*3.336e-30; %convert from Debye to SI
disp('Dipole is converted in SI units')
W = 0.5*((dipole(1) - mu0(1))^2/Px +(dipole(2) - mu0(2))^2/Py + (dipole(3) - mu0(3))^2/Pz );

end