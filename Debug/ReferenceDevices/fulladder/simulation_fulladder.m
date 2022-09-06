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
file = 'fulladder.qll';
settings.out_path = fullfile('/mnt/44CEE091CEE07D14/PhD/tmp','fulladder'); 
           
%circuit configuration
circuit.dist_z = 10;
circuit.magcadImporter = 1;
circuit.doubleMolDriverMode = 1; 
circuit.qllFile = fullfile(pwd,file);

%drivers and clock
circuit.Values_Dr = {
    'a'     D0{:} D1{:} D0{:} D1{:} D0{:} D1{:} D0{:} D1{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'a_c'   R0{:} R1{:} R0{:} R1{:} R0{:} R1{:} R0{:} R1{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} 'end'
    'b'     D0{:} D0{:} D1{:} D1{:} D0{:} D0{:} D1{:} D1{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'b_c'   R0{:} R0{:} R1{:} R1{:} R0{:} R0{:} R1{:} R1{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} 'end'
    'Cin'   D0{:} D0{:} D0{:} D0{:} D1{:} D1{:} D1{:} D1{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'Cin_c' R0{:} R0{:} R0{:} R0{:} R1{:} R1{:} R1{:} R1{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} R0{:} 'end'
};

%clock phase
circuit.stack_phase(1,:) = [    pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle,    pReset pReset pReset ];
circuit.stack_phase(2,:) = [pReset,    pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle,    pReset pReset];
circuit.stack_phase(3,:) = [pReset pReset,    pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle ,    pReset];
circuit.stack_phase(4,:) = [pReset pReset pReset,    pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle pCycle];

%SCERPA settings
settings.damping = 0.6;
settings.activeRegionThreshold=0.005;
settings.verbosity = 0;
settings.conv_threshold_HP = 0.005;
settings.enableRefining = 0;
settings.enableActiveRegion = 1;
settings.dumpDriver = 1;
settings.dumpOutput = 1;
settings.dumpClock = 1;
settings.dumpComputationTime = 1;

%PLOT settings
plotSettings.plot_3dfig = 0;
plotSettings.plot_logic = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 7;
plotSettings.plotList = [309:330];
plotSettings.plot_waveform = 1;
plotSettings.fig_saver = 0;

%copy outputh path from algorithm settings if specified by the user
if isfield(settings,'out_path') 
    plotSettings.out_path = settings.out_path;
end

%%%%
this_path = pwd;
scerpa_path = fullfile('/mnt/44CEE091CEE07D14','scerpa');
cd(scerpa_path)
% SCERPA('generateLaunchView', circuit, settings, plotSettings);
SCERPA('plotSteps', plotSettings);
cd(this_path)