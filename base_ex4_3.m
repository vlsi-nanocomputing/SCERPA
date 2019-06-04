%distances
%%%%%
clear all

circuit.dist_z = 10;   

%molecule
circuit.molecule = 'bisfe_4';

%layout
circuit.structure = { 'Dr1' 'Dr2' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1'};

%drivers and clock
circuit.Values_Dr = {
    'Dr1' -4.5 +4.5 'end';
    'Dr2' +4.5 -4.5 'end'};

%clock
circuit.stack_phase(1,:) = [2 2];

%settings
scerpaSettings.plotIntermediateSteps = 1;

%SCERPA settings
SCERPA('generate',circuit)
SCERPA('launch',scerpaSettings)

