%distances
%%%%%
clear all


%layout
file = 'bus_test.qll';
circuit.qllFile = sprintf('%s\\%s',pwd,file);
            

%drivers and clock
circuit.Values_Dr = {
    'Dr1' -4.5 +4.5 +4.5 +4.5 'end'
    'Dr1_c' +4.5 -4.5 -4.5 -4.5 'end'
};

% circuit.structure = { 'Dr1' 'Dr2' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1'};   %8 mols

%clock
circuit.stack_phase(1,:) = [2 +2 -2 +2];


%substrate
circuit.substrate.PVenable = 0;
circuit.substrate.mode = 'map';
circuit.substrate.averageRoughness = 10;
[circuit.substrate_mesh_y, circuit.substrate_mesh_z] = meshgrid([-25:125],[-25:175]);
% circuit.substrate_mesh_x = 5*sin(2*pi/100*circuit.substrate_mesh_y + 2*pi/100*circuit.substrate_mesh_z);
circuit.substrate_mesh_x = 5*sin(2*pi/100*circuit.substrate_mesh_y+3)+ 5*sin(2*pi/100*circuit.substrate_mesh_z - 12);

%clock
circuit.clockMode = 'phase';

%SCERPA settings
settings.plot_3dfig = 1;
settings.doubleMolDriverMode = 1;
settings.fig_saver='no';
settings.plot_voltage = 0;
settings.plot_chargeFig = 0;
settings.plot_logic = 1;
settings.plot_clock = 1;
settings.plot_molnum = 0;
settings.solver='E';
settings.immediateUpdate = 0;
settings.pauseStep = 0;
settings.damping = 0.6;
settings.verbosity = 2;
settings.conv_threshold_HP = 0.005;
settings.enableRefining = 1;
settings.enableActiveRegion = 1;
settings.plotIntermediateSteps = 0;
settings.plotActiveRegionWindow = 0;

%%%%
this_path = pwd;
scerpa_path = this_path;
cd(scerpa_path)
generation_status = SCERPA('topoLaunch', circuit, settings);
% generation_status = SCERPA('generateLaunch', circuit, settings);
cd(this_path)