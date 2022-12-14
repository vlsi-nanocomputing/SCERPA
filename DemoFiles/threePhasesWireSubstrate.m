clear variables
close all

%clock values definitions
clock_low = -2;
clock_high = +2;
clock_step = 3;

% %layout (MagCAD)
% file = 'threePhasesWire.qll';
% circuit.qllFile = fullfile(pwd,file);
% circuit.doubleMolDriverMode = 1;  
% circuit.magcadImporter = 1;


% layout (MATLAB)
circuit.structure = {'Dr1_c' 'Dr1' '1' '1' '1' '1' '1' '1' '1' '1' '2' '2' '2' '2' '2' '2' '2' '2' '3' '3' '3' '3' '3' '3' '3' '3' 'Out_y'};
circuit.magcadImporter = 0;
circuit.molecule = '9';
 
%drivers and clock
D0 = num2cell(+4.5*ones(1,clock_step*4));
D1 = num2cell(-4.5*ones(1,clock_step*4));
Dnone = num2cell(zeros(1,clock_step*4));

circuit.Values_Dr = {
    'Dr1'   D0{:} D1{:} Dnone{:} 
    'Dr1_c' D1{:} D0{:} Dnone{:} 
};

%clock
pSwitch =  linspace(clock_low,clock_high,clock_step); 
pHold =   linspace(clock_high,clock_high,clock_step); 
pRelease =  linspace(clock_high,clock_low,clock_step); 
pReset =   linspace(clock_low,clock_low,clock_step); 
pCycle = [pSwitch pHold pRelease pReset];

circuit.stack_phase(1,:) = [pCycle pCycle, pReset pReset ];
circuit.stack_phase(2,:) = [pReset pCycle pCycle, pReset ];
circuit.stack_phase(3,:) = [pReset pReset, pCycle pCycle ];

circuit.substrate.PVenable=1;
circuit.substrate.mode='random';
circuit.substrate.averageRoughness=2;

% circuit.substrate.mode='map';
% [circuit.substrate.map_MeshY, circuit.substrate.map_MeshZ]=meshgrid(linspace(0,400),linspace(0,400));
% circuit.substrate.map_MeshX = circuit.substrate.map_MeshZ.^2/3000;
    
%SCERPA settings
settings.out_path = pwd;
settings.damping = 0.6;
settings.verbosity = 0;
settings.dumpDriver = 1;
settings.dumpOutput = 1;
settings.dumpClock = 1;
settings.dumpEnergy = 1;
settings.evalConformationEnergy = 1;
settings.evalIntermolecularEnergy = 1;
settings.evalPolarizationEnergy = 1;
settings.evalFieldEnergy = 1;
settings.energyEval = 1;


%PLOT settings
plotSettings.plot_waveform = 1;
plotSettings.plot_3dfig = 1;
plotSettings.plot_1DCharge = 1;
plotSettings.plot_logic = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 3;
plotSettings.fig_saver = 1;
plotSettings.HQimage = 1;

%copy outputh path from algorithm settings if specified by the user
if isfield(settings,'out_path') 
    plotSettings.out_path = settings.out_path;
end

%%%%
diary on
this_path = pwd;
scerpa_path = fullfile('../');
cd(scerpa_path)
SCERPA('generateLaunchView', circuit, settings, plotSettings);
cd(this_path)
diary off
if isfield(settings,'out_path') 
    movefile('diary',fullfile(settings.out_path,'logfile.log'))
end
