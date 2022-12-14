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
function out_fig = PlotPotential(stack_mol, stack_driver, stack_output, settings)

%WARNING: x-z axis are swapped
pos.x = settings.plot_potential_tipHeight;


%evaluation
Nmolecules = stack_mol.num;
Ndrivers = stack_driver.num;
Ncharges = 4;

%create structure of molecules
for ii = 1:Nmolecules
    for jj = 1:Ncharges
        mol.x(jj) = stack_mol.stack(ii).charge(jj).x;
        mol.y(jj) = stack_mol.stack(ii).charge(jj).y;
        mol.z(jj) = stack_mol.stack(ii).charge(jj).z;
        mol.charge(jj)=stack_mol.stack(ii).charge(jj).q;
    end
    mol.n_atoms = Ncharges;
    mol.element = {'DOT1','DOT2','DOT3','DOT4'};

    %assemble in a system
    if ii ==1
        systemMol = mol;
    else
        systemMol = assemble(mol,systemMol);
    end

end

%create system with drivers
for ii = 1:Ndrivers
    for jj = 1:Ncharges
        driverMol.x(jj) = stack_driver.stack(ii).charge(jj).x;
        driverMol.y(jj) = stack_driver.stack(ii).charge(jj).y;
        driverMol.z(jj) = stack_driver.stack(ii).charge(jj).z;
        driverMol.charge(jj)=stack_driver.stack(ii).charge(jj).q;
    end
    driverMol.n_atoms = Ncharges;
    driverMol.totalCharge = 1;
    driverMol.element = {'DOT1','DOT2','DOT3','DOT4'};

    %add to system
    systemMol=assemble(systemMol,driverMol);
end


%create potential grid
grid_points = 200;
y_min = min(systemMol.y) - settings.plot_potential_padding;
y_max = max(systemMol.y) + settings.plot_potential_padding;
z_min = min(systemMol.z) - settings.plot_potential_padding; %-3 for deca, -5 for bisfe
z_max = max(systemMol.z) + settings.plot_potential_padding; %2 for deca, 1.5 for bisfe
yspan = linspace(y_min,y_max,grid_points);
zspan = linspace(z_min,z_max,grid_points);
[y,z] = meshgrid(yspan,zspan);

%evaluate voltage
voltage = zeros(grid_points,grid_points);
for ii=1:grid_points
    for jj=1:grid_points
        pos.y = y(ii,jj);
        pos.z = z(ii,jj);
        voltage(ii,jj) = min(EvaluatePotential(systemMol,pos),settings.plot_potential_saturationVoltage);
    end
end

   
%figure creation
if settings.HQimage
    dpi = 150;            % Resolution
    sz = [0 0 2880 1800]; % Image size in pixels
    out_fig = figure('visible','off','PaperUnits','inches','PaperPosition', sz/dpi,'PaperPositionMode','manual','position',[0 0  1920 1080]);
    ha = gca;
    uistack(ha,'bottom');
    ha2=axes('OuterPosition',[0,0, 1,1],'Position',[0,0, 0.14,0.14]);
    hIm = imshow(fullfile('..','Documentation','scerpa_logo.png'));
    set(ha2,'handlevisibility','off','visible','off')
else
    out_fig = figure('visible','off');
    ha = gca;
    uistack(ha,'bottom');
    ha2=axes('OuterPosition',[0,0, 1,1],'Position',[0,0, 0.14,0.14]);
    [LogoImage, mapImage] = imread(fullfile('..','Documentation','scerpa_logo.png'));
    image(LogoImage)
    colormap (mapImage)
    set(ha2,'handlevisibility','off','visible','off')
end

surf(z/10,y/10,voltage,'EdgeColor','none')
set(gcf,'PaperPositionMode','auto')
set(out_fig, 'Position', [100 100 500 400])
ylabel('y [nm]'),view([0 90])
xlabel('z [nm]')
box on
axis([z_min z_max y_min y_max ]/10)
axis equal
set(gca,'Ydir','reverse')
title('Voltage [V]')
colorbar

%AFM colors
map(:,1) = [linspace(0,0.8,60) linspace(0.8,1,40)];
map(:,2) = [linspace(0,0,20) linspace(0,1,80)];
map(:,3) = [linspace(0,0.1,70) linspace(0.1,1,30)];
colormap(map);

shading interp






end


function [ newmol ] = assemble(mol1,mol2)
%This function groups two molecule mol1 and mol2, mol1 is kept at the
%original position while mol2 is positioned at a distance (Dx,Dy,Dz) from
%mol1
%   mol1: molecule number 1
%   mol2: molecule number 2 
%   newmol: strucuture containing the two molecules grouped

%evaluate the number of atoms in the molecules
N1 = length(mol1.x);
N2 = length(mol2.x);

% copy molecule 1
newmol = mol1;

%insert molecule 2
newmol.n_atoms = newmol.n_atoms + mol2.n_atoms;
newmol.x(N1+1:N1+N2) = mol2.x;
newmol.y(N1+1:N1+N2) = mol2.y;
newmol.z(N1+1:N1+N2) = mol2.z;
newmol.charge(N1+1:N1+N2) = mol2.charge;
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
%     N=mol.n_atoms;

    %contribution to the potential due to i-th charge is: k*qi/|r-ri|

    %evaluate voltage
%     voltage = 0;
%     for ii=1:N
%         %evaluate distance
%         xdist = 1e-10*(pos.x - mol.x(ii));
%         ydist = 1e-10*(pos.y - mol.y(ii));
%         zdist = 1e-10*(pos.z - mol.z(ii));
%         dist = sqrt(xdist^2 + ydist^2 + zdist^2);
% 
%         %sumpotential contribution
%         voltage = voltage + k*(q*mol.charge(ii))/dist;
%     end
    %evaluate distance
    xdist = (pos.x - mol.x);
    ydist = (pos.y - mol.y);
    zdist = (pos.z - mol.z);
    dist = 1e-10*sqrt(xdist.^2 + ydist.^2 + zdist.^2);

    %sumpotential contribution
    voltage = sum(k*(q*mol.charge)./dist);
end

    

