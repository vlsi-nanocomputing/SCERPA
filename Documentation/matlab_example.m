%%%%%
clear all 

%distances
circuit.dist_z = 10;   

%molecule
circuit.molecule = 'bisfe_4';

circuit.components = {
      0   0   '0' '0'   0   0;
     '0' '0'  '0' '0'  '1' '1';
      0   0   '10' '10'   0   0
};

%layout
circuit.structure = {
     0 0         'Dr3' 'Dr4' 0 0;
     'Dr1' 'Dr2'  '1'   '1'  '2' '2';
     0 0         'Dr5' 'Dr6' 0 0
};   
                    
%drivers and clock
circuit.Values_Dr = {
    'Dr1' +4.5 +4.5 
    'Dr2' -4.5 -4.5
    'Dr3' +4.5 +4.5 
    'Dr4' -4.5 -4.5 
    'Dr5' +4.5 +4.5 
    'Dr6' -4.5 -4.5 
};

%clock
circuit.stack_phase(1,:) = [+2 2];
circuit.stack_phase(2,:) = [-2 2];


%SCERPA settings
settings.solver='E';
settings.driverSaturation=1;
settings.immediateUpdate = 0;
settings.pauseStep = 0;
settings.damping = 0.4;
settings.verbosity = 0;
settings.enableRefining = 1;
settings.enableActiveRegion = 1;
settings.plotIntermediateSteps = 0;
settings.plotActiveRegionWindow = 0;

%%%% Launch SCERPA
generation_status = SCERPA('generateLaunch', circuit, settings);
