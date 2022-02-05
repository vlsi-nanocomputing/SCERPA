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
function [total_dissipated_energy,dissipated_power] = EvaluateClockingPower(stack_mol,stack_clock,settings)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
technology.plateDistance = 3e-9;
technology.plateSection = 1e-9*2e-9;
technology.epsilon_r = 1;

number_times = size(stack_clock,2)-1;

% energy evaluation
DeltaStoredEnergy_table = zeros(stack_mol.num,number_times);
preStoredEnergy = zeros(stack_mol.num,1);
total_time = number_times*settings.timestep;
singleMolCapacitance = 8.854187e-12*...
    technology.epsilon_r*...
    technology.plateSection/technology.plateDistance;

for ii=1:number_times
    %MA LA TENSIONE È GIUSTA? SE QUELLO é IL CAMPO BISOGNA RICAVARE LA
    %TENSIONE DI ELETTRODO, CHE DOBREVVE ESSERE V*h
    electrodeVoltage = technology.plateDistance*(1e9*cell2mat(stack_clock(:,ii+1)));
    newStoredEnergy = 0.5*singleMolCapacitance*electrodeVoltage.^2;
    DeltaStoredEnergy_table(:,ii) = newStoredEnergy-preStoredEnergy;
    preStoredEnergy = newStoredEnergy;
end

% total dissipated energy is the sum of the negative energy variations (i.e. dissipated in the environment)
total_dissipated_energy = abs(sum(...
        DeltaStoredEnergy_table(DeltaStoredEnergy_table<=0)...
    ));


% total power is the energy in the time period
dissipated_power=total_dissipated_energy/total_time;

% electrode power density
total_electrodeArea=technology.plateSection*stack_mol.num;
dissipated_electrodePowerDensity = dissipated_power/total_electrodeArea;

% % substrate power density
% total_substrateArea=
% dissipated_substratePowerDensity =

% report
disp(' | POWER REPORT (drivers are not yet considered in the evaluation)');
fprintf(' |  ~ Total run time: %.1f ps (%d timesteps, dT = %.2f ps)\n',total_time/1e-12,number_times,settings.timestep*1e12)
fprintf(' |  ~ Total dissipated energy: %.2f eV (%.4f fJ) \n',total_dissipated_energy/1.6e-19, total_dissipated_energy/1e-15); 
fprintf(' |  ~ Total power dissipation: %.2f nW, (1/dT=%.1f GHz) \n',dissipated_power/1e-9,1/settings.timestep/1e12); 
fprintf(' |  ~ Total power density on electrodes: %.2f W/nm, (Electrode area %.2f nm^2) \n',dissipated_electrodePowerDensity/1e9,total_electrodeArea/1e-18); 
% fprintf(' |  ~ Total power density on substrate: %.2f W/nm, (Substrate area %.2f nm^2) \n',dissipated_electrodePowerDensity/1e9,total_electrodeArea/1e-18);
end

