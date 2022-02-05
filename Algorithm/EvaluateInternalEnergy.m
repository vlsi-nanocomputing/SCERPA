%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%       Self-Consistent Electrostatic Potential Algorithm (SCERPA)         %
%                                                                          %
%       VLSI Nanocomputing Research Group                                  %
%       Dept. of Electronics and Telecommunications                        %
%       Politecnico di Torino, Turin, Italy                                %
%       (https://www.vlsilab.polito.it/)                                   %
%                                                                          %
%       People [people you may contact for info]                           %
%         Yuri Ardesi (yuri.ardesi@polito.it)                              %
%         Giuliana Beretta (giuliana.beretta@polito.it)                    %
%                                                                          %
%       Supervision: Gianluca Piccinini, Mariagrazia Graziano              %
%                                                                          %
%       Relevant pubblications doi: 10.1109/TCAD.2019.2960360              %
%                                   10.1109/TVLSI.2020.3045198             %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
mu=[0 0 0];
q = 1.60217662e-19;

ref = [mean(mol.x) mean(mol.y) mean(mol.z)];

%loop each atom
for ii=1:mol.n_atoms

    %evaluate dipole factor
    mu = mu + q*mol.espCharge(ii)* 1e-10*[mol.x(ii)-ref(1) mol.y(ii)-ref(2) mol.z(ii)-ref(3)];

end
    
W = 0.5*((mu(1) - mu0(1))^2/Px +(mu(2) - mu0(2))^2/Py + (mu(3) - mu0(3))^2/Pz );

end