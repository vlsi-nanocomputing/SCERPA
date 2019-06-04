%distances
%%%%%
clear all

circuit.dist_z = 10;   

%molecule
circuit.molecule = 'bisfe_4';

%layout
circuit.structure = { 'Dr1' 'Dr2' '1' '1' '1' '1' '1' '1' '1' '1' };     

% circuit.rotation_x = { '0' '0' '0' '0' '0' '0' '0' '0'}; 
                    
%drivers and clock
circuit.Values_Dr = {
    'Dr1' -4.5 +4.5 'end';
    'Dr2' +4.5 -4.5 'end'};

%clock
circuit.stack_phase(1,:) = [2];

%SCERPA settings
settings.solver='E';
settings.immediateUpdate = 0;
settings.plotIntermediateSteps = 0;
settings.pauseStep = 0;
settings.damping = 0.2;

generation_status = SCERPA('generateLaunch', circuit, settings);

