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
function [W_0_TOT,W_mu,W_ex,W_clk,W_tot] = EvaluateEnergy(settings, stack_driver, stack_mol, Vout, CK)
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
% get the directory name of the molecule
dirList = dir(fullfile('..','Database'));
dirNamesList = {dirList(:).name};
molIdentifier = sprintf('%d.',stack_mol.stack(1).molType);
index = strncmp(dirNamesList,molIdentifier,2);
directoryName = dirNamesList{index};
filename = fullfile('..','Database',directoryName,'info.txt');
in_str=fileread(filename); % string to analyze
  
xpr = 'ENERGY\n';
energy_data = regexp(in_str, xpr, 'match');

if isempty(energy_data)
    warning('No information on energy in the info.txt file, energy evaluation disabled!')
    W_int = 0;
    W_ex = 0;
    W_clk = 0;
    W_tot = 0;
else
    abq = '([^"]+)'; 
    xpr = ['W_0\s*=\s*([-+]?\d*\.?\d+)\s*a.u.\n'];
    conformationEnergy = regexp(in_str, xpr, 'tokens');
    W_0_hartree = str2double(char(conformationEnergy{:}));
    W_0 = W_0_hartree*4.359748199e-18; %conformation energy from Hartree to Joule

    xpr = ['mu_0\s*=\s*(?<x>[-+]?\d*\.?\d+e[-+]?\d)\s*;\s*(?<y>[-+]?\d*\.?\d+e[-+]?\d)\s*;\s*(?<z>[-+]?\d*\.?\d+e[-+]?\d)\s*D\n'];
    dipole = regexp(in_str,xpr,'names');
    mu0(1) = str2double(char(dipole.x))*3.33564e-30; %conversion from Debye to SI
    mu0(2) = str2double(char(dipole.y))*3.33564e-30; %conversion from Debye to SI
    mu0(3) = str2double(char(dipole.z))*3.33564e-30; %conversion from Debye to SI
    
    xpr = ['alpha_xx\s*=\s*"([^"]+)"\s*a.u.\s*'];
    alpha_xx = regexp(in_str, xpr, 'tokens');
    Px = str2double(char(alpha_xx{1}))*1.648777273798380e-41; %conversion from a.u. to SI

    xpr = ['alpha_yy\s*=\s*"([^"]+)"\s*a.u.'];
    alpha_yy = regexp(in_str, xpr, 'tokens');
    Py = str2double(char(alpha_yy{1}))*1.648777273798380e-41; %conversion from a.u. to SI

    xpr = ['alpha_zz\s*=\s*"([^"]+)"\s*a.u.'];
    alpha_zz = regexp(in_str, xpr, 'tokens');
    Pz = str2double(char(alpha_zz{1}))*1.648777273798380e-41; %conversion from a.u. to SI

    %evalute total conformation energy
    W_0_TOT = 0;
    if settings.evalConformationEnergy==1
        W_0_TOT = length(mol)*W_0;
    end
    
    %evaluate polarization energy
    W_mu = zeros(1,length(mol));
    if settings.evalPolarizationEnergy==1
        for ii_mol = 1:length(mol)
             W_mu(ii_mol) = EvaluatePolarizationEnergy( mol(ii_mol), Px, Py, Pz, mu0);
        end
    end
    W_mu_sum = sum(W_mu);
    
    %evaluate exchange energy
    W_ex = 0;
    if settings.evalIntermolecularEnergy==1
        for ii_mol = 1:length(mol)
            for jj_mol = (ii_mol+1):length(mol)
                W_ex = W_ex + EvaluateIntermolecularEnergy( mol(ii_mol), mol(jj_mol));
            end
        end
    end
    
    %evaluate clock energy
    W_clk = 0;
    if settings.evaluateFieldEnergy==1
        for ii_mol = 1:length(mol)
             W_clk = W_clk + EvaluateFieldEnergy( mol(ii_mol), -clock, 0, 0);
        end
    end
    
    %evaluate total energy
    W_tot = W_0_TOT + W_mu_sum + W_ex + W_clk;
    
    %convert energies to eV
    qq=1.6e-19;
    W_ex = W_ex/qq;
    W_mu = W_mu_sum/qq;
    W_tot = W_tot/qq;
end

end

