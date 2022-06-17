clear variables
close all

%definitions
clock_low = -2;
clock_high = +2;
clock_step = 7;

%normal clock phases
pSwitch =  linspace(clock_low,clock_high,clock_step); 
pHold =   linspace(clock_high,clock_high,clock_step); 
pRelease =  linspace(clock_high,clock_low,clock_step); 
pReset =   linspace(clock_low,clock_low,clock_step); 
pCycle = [pSwitch pHold pRelease pReset];

%stable clock phases
pCycle1 = [pSwitch pHold pHold pHold pRelease pReset pReset];
pCycle2 = [pReset pReset pSwitch pHold pHold pHold pRelease];
pCycle3 = [pHold pRelease pReset pSwitch pHold pHold pHold];
pCycle4 = [pHold pRelease pReset pReset pReset pSwitch pHold];

%drivers
D0 = num2cell(+4.5*ones(1,clock_step*4));
D1 = num2cell(-4.5*ones(1,clock_step*4));
R0 = D1;
R1 = D0;

%layout (MagCAD)
% file = 'majority_voter.qll';
% settings.out_path = fullfile(pwd,'majority_voter'); 

% file = 'majority_voter_unbalanced.qll';
% settings.out_path = fullfile(pwd,'majority_voter_unbalanced'); 

% file = 'majority_voter_unbalanced_2.qll';
% settings.out_path = fullfile(pwd,'majority_voter_unbalanced_2'); 
          
file = 'majority_voter_large.qll';
settings.out_path = fullfile(pwd,'majority_voter_large'); 

%circuit configuration
circuit.dist_z = 10;
circuit.magcadImporter = 1;
circuit.doubleMolDriverMode = 1; 
circuit.qllFile = fullfile(pwd,file);

%drivers and clock
circuit.Values_Dr = {
    'Dr1'     D0{:} D1{:} D0{:} D1{:} D0{:} D1{:} D0{:} D1{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'Dr1_c'   R0{:} R1{:} R0{:} R1{:} R0{:} R1{:} R0{:} R1{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} 'end'
    'Dr2'     D0{:} D0{:} D1{:} D1{:} D0{:} D0{:} D1{:} D1{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'Dr2_c'   R0{:} R0{:} R1{:} R1{:} R0{:} R0{:} R1{:} R1{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} 'end'
    'Dr3'     D0{:} D0{:} D0{:} D0{:} D1{:} D1{:} D1{:} D1{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'Dr3_c'   R0{:} R0{:} R0{:} R0{:} R1{:} R1{:} R1{:} R1{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} 'end'
};

%clock phase
circuit.stack_phase(1,:) = [pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pReset pReset];
circuit.stack_phase(2,:) = [pReset pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pReset];
circuit.stack_phase(3,:) = [pReset pReset pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle];

%SCERPA settings
settings.damping = 0.6;
settings.verbosity = 2;
settings.dumpDriver = 1;
settings.dumpOutput = 1;
settings.dumpClock = 1;
settings.plotIntermediateSteps = 0;

%PLOT settings
plotSettings.plot_waveform = 1;
plotSettings.plot_logic = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 7;
plotSettings.fig_saver = 1;
plotSettings.plotList = 0;

%copy outputh path from algorithm settings if specified by the user
if isfield(settings,'out_path') 
    plotSettings.out_path = settings.out_path;
end

%%%%
this_path = pwd;
scerpa_path = fullfile('D:','SCERPA');
cd(scerpa_path)
generation_status = SCERPA('generateLaunch', circuit, settings);
                    SCERPA('plotSteps', plotSettings);
cd(this_path)