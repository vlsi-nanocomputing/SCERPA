function [ W ] = EvaluateFieldEnergy( mol, Ex,Ey,Ez )
%Evaluate the electrostatic energy of the molecule considering a clock
%field E positive in the -x direction.
%   mol: molecule object
%   E: electric field (given in V/nm)
%   W: Energy
% E=0;disp('WARNING: clock is not considered in the evaluation');

%constants
q = 1.60217662e-19;

%   clock energy

% The potential energy associated to the i-th atom due to the clock is 
% the product between: the distance from the reference point mol.x(i),
% the value of the charge q*mol.espCharge(i) and the electric field
% module E.

% The electric field tends to push charges towards the -x direction then
% the larger is the charge, the higher is the pushing force (higher
% energy), the more positive is the distance from the reference point,
% the larger is the energy, the larger is the electric field, the larger
% is the pushing force
Wc = 0;
for i=1:N
    Wc = Wc - 1e-10*mol.x(i)*q*mol.espCharge(i)*1e9*Ex - 1e-10*mol.y(i)*q*mol.espCharge(i)*1e9*Ey - 1e-10*mol.z(i)*q*mol.espCharge(i)*1e9*Ez;
end

% collapse two energies in the total energy
W=Wc;

end


