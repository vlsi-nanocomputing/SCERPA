%distances
%%%%%
clear all

circuit.dist_z = 6;   

%molecule
circuit.molecule = 'butaneCam';

%layout
circuit.structure = { 'Dr1' 'Dr1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' }; 

circuit.shift_y = { '0' '0' '0' '0' '0' '0' '10' '0' '0' '0' '0' '0'}; 

circuit.shift_z = { '0' '0' '0' '0' '0' '0' '10' '0' '0' '0' '0' '0'}; 
                    
%drivers and clock
circuit.Values_Dr = {'Dr1'}
N=10;
values = linspace(-4.5,4.5,N);
for ii=1:N
    circuit.Values_Dr{ii+1} = values(ii);
    circuit.Values_Dr{ii+2} = 'end';
end

%clock
circuit.stack_phase(1,:) = [2*ones(1,N)];

%SCERPA settings
settings.solver='E';
settings.immediateUpdate = 0;
settings.plotIntermediateSteps = 0;
settings.pauseStep = 0;
settings.molecule = "butaneCam";
settings.damping = 0.4;

generation_status = SCERPA('generate', circuit, settings);

