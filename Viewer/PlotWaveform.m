function out_fig = PlotWaveform(stack_mol, stack_driver, stack_output, settings)


% files
disp('Loading geometry')
fileName = '../full_adder/garbage/normal.mat';

disp('Loading sim data')
run('../full_adder/garbage/normal.m')
plotListDriver = [10 2 18 ];
plotListOutputs = [2 3];
V_th=0.1;
out_rules = [35 95];


%import variables
load(fileName,'stack_mol') 
load(fileName,'stack_driver') 
load(fileName,'stack_output') 

%size
Ndrivers = stack_driver.num;
[Nmolecules, Ncharges, Nconf] = size(conf);
Ncharges = Ncharges - 2; %eliminate id and vin columns of conf array
Noutputs = stack_output.num;

%in-out tables (TIME x DRIVERS)
in_table = zeros(Nconf,Ndrivers);
out_table = zeros(Nconf,Noutputs);

disp('Evaluating logic')
for cc=2:Nconf
    
   
    %create structure of molecules
    for ii = 1:Nmolecules
        for jj = 1:Ncharges
            mol.x(jj) = stack_mol.stack(ii).charge(jj).x;
            mol.y(jj) = stack_mol.stack(ii).charge(jj).y;
            mol.z(jj) = stack_mol.stack(ii).charge(jj).z;
            mol.espCharge(jj)=conf(ii,jj+2,cc);
        end
        mol.n_atoms = Ncharges;
        mol.totalCharge = 1;
        mol.element = {'DOT1','DOT2','DOT3','DOT4'};

        %assemble in a system
        if ii ==1
            systemMol = mol;
        else
            systemMol = AssembleMols(mol,systemMol,0,0,0);
        end

    end

    %create system with drivers
    for ii = 1:Ndrivers
        for jj = 1:Ncharges
            driverMol.x(jj) = stack_driver.stack(ii).charge(jj).x;
            driverMol.y(jj) = stack_driver.stack(ii).charge(jj).y;
            driverMol.z(jj) = stack_driver.stack(ii).charge(jj).z;
            driverMol.espCharge(jj)=driver(ii,jj,cc);
        end
        driverMol.n_atoms = Ncharges;
        driverMol.totalCharge = 1;
        driverMol.element = {'DOT1','DOT2','DOT3','DOT4'};

        %add to system
        systemMol=AssembleMols(systemMol,driverMol,0,0,0);
        
        %evaluate input value
        in_table(cc,ii) = (driverMol.espCharge(1) - driverMol.espCharge(2))/2+0.5;
    end


    %evaluate output
    for ii = 1:Noutputs

        pos1.x = stack_output.stack(ii).charge(1).x;
        pos1.y = stack_output.stack(ii).charge(1).y;
        pos1.z = stack_output.stack(ii).charge(1).z;

        pos2.x = stack_output.stack(ii).charge(2).x;
        pos2.y = stack_output.stack(ii).charge(2).y;
        pos2.z = stack_output.stack(ii).charge(2).z;
        
        %evaluate input value
        out_table(cc,ii) = 0.5*max(min((EvaluatePotential(systemMol,pos1) - EvaluatePotential(systemMol,pos2)),V_th),-V_th)/V_th + 0.5;
        
    end
    
    
 
    
    

    
    
end

disp('Plotting drivers')
N_subplot = length(plotListDriver) + length(plotListOutputs) ;

figure(1),clc

%plot drivers
row = 1;
for dd = plotListDriver
     
    subplot(N_subplot,1,row), hold on
    plot(in_table(:,dd),'-k','LineWidth',1, 'MarkerSize',10)
    ylabel(stack_driver.stack(dd).identifier)
    xticklabels('')
    xticks([])
    ylim([-0.1 1.1])
%     grid on, grid minor
	 ax = gca;
    ax.BoxStyle = 'full';
    
    row = row+1;
    
end

disp('Plotting outputs')
%plot outputs
for oo = plotListOutputs
    
    subplot(N_subplot,1,row), hold on
    plot(out_table(:,oo),'-k','LineWidth',1, 'MarkerSize',10)
    ylabel(stack_output.stack(oo).identifier)
    xticklabels('')
    xticks([])
    ax = gca;
    ax.BoxStyle = 'full';
    ylim([-0.1 1.1])
%     grid on, grid minor
    
    %plot lines
    for ll = out_rules
        plot([ll ll],[-1 2],'--k')
    end

    row = row+1;
end


end

function [ newmol ] = AssembleMols(mol1,mol2,Dx,Dy,Dz)
%This function groups two molecule mol1 and mol2, mol1 is kept at the
%original position while mol2 is positioned at a distance (Dx,Dy,Dz) from
%mol1
%   mol1: molecule number 1
%   mol2: molecule number 2 
%   Dx,Dy,Dz: distances
%   newmol: strucuture containing the two molecules grouped

%evaluate the number of atoms in the molecules
N1 = length(mol1.x);
N2 = length(mol2.x);

% copy molecule 1
newmol = mol1;

%insert molecule 2
try
    newmol.totalCharge = newmol.totalCharge + mol2.totalCharge;
catch
    try
        newmol.totalCharge = sum(mol1.espCharge) + sum(mol2.espCharge);
        warning('Total charge reconstructed form charges!');
    catch
        warning('No total charge!');
    end
    
end

% newmol.multeplicity = newmol.multeplicity + mol2.multeplicity;
try
    newmol.n_atoms = newmol.n_atoms + mol2.n_atoms;
catch
    try
        newmol.n_atoms = length(mol1.espCharge) + length(mol2.espCharge);
        warning('Number of atoms reconstructed form charges!');
    catch
        warning('No number of atoms!');
    end
end

% newmol.ID(N1+1:N1+N2) = N1+1:N1+N2;
% newmol.atomicNumber(N1+1:N1+N2) = mol2.atomicNumber;
% newmol.atomicType(N1+1:N1+N2) = mol2.atomicType;
newmol.x(N1+1:N1+N2) = mol2.x+Dx*1e10;
newmol.y(N1+1:N1+N2) = mol2.y+Dy*1e10;
newmol.z(N1+1:N1+N2) = mol2.z+Dz*1e10;
% newmol.mullikenCharge(N1+1:N1+N2) = mol2.mullikenCharge;
try 
    newmol.element(N1+1:N1+N2) = mol2.element;
catch
    warning('No elements!');
end
% newmol.radius(N1+1:N1+N2) = mol2.radius;
newmol.espCharge(N1+1:N1+N2) = mol2.espCharge;
% newmol.potential(N1+1:N1+N2) = mol2.potential;

end

function [ voltage ] = EvaluatePotential(mol,pos)
%Evaluate the voltage generated by molecule between two points (DOTs)
%   voltage: is the output voltage VDOT2-VDOT1
%   pos: position to evaluate the potential
%       -> pos.x - pos.y - pos.z in ANGSTRONG

    %constants
    q = 1.60217662e-19;
    e0 = 8.854187817e-12;
    k = 1/(4*pi*e0);

    %number of charges
    N=mol.n_atoms;

    %contribution to the potential due to i-th charge is: k*qi/|r-ri|

    %evaluate voltage
    voltage = 0;
    for ii=1:N
        %evaluate distance
        xdist = 1e-10*(pos.x - mol.x(ii));
        ydist = 1e-10*(pos.y - mol.y(ii));
        zdist = 1e-10*(pos.z - mol.z(ii));
        dist = sqrt(xdist^2 + ydist^2 + zdist^2);

        %sumpotential contribution
        voltage = voltage + k*(q*mol.espCharge(ii))/dist;
    end
end

