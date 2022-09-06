function [ Wclock ] = EvaluateFieldEnergy(mut,Ex,Ey,Ez)
%Evaluate the electrostatic energy of the molecule considering a clock
%field E positive in the -x direction.
%   mut: molecule object
%   E: electric field (given in V/nm)
%   W: Energy
% E=0;disp('WARNING: clock is not considered in the evaluation');

%constants
q = 1.60217662e-19;

% The potential energy associated to the i-th atom due to the clock is 
% the product between: the distance from the reference point mol.x(i),
% the value of the charge q*mol.espCharge(i) and the electric field
% module E.

% The electric field tends to push charges towards the -x direction then
% the larger is the charge, the higher is the pushing force (higher
% energy), the more positive is the distance from the reference point,
% the larger is the energy, the larger is the electric field, the larger
% is the pushing force
Wclock = 0;
for i=1:mut.n_atoms
    %rescale length (1e10) and field (1e9) -> 0.1
    Wclock = Wclock - 0.1*q*(mut.x(i)*mut.espCharge(i)*Ex + mut.y(i)*mut.espCharge(i)*Ey - mut.z(i)*mut.espCharge(i)*Ez);
end

end


