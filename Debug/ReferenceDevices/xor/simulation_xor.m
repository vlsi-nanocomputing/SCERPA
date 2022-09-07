clear variables
close all

%definitions
clock_low = -2;
clock_high = +2;
clock_step = 7;
clock_phases = 4;

%normal clock phases
pSwitch =  linspace(clock_low,clock_high,clock_step); 
pHold =    linspace(clock_high,clock_high,clock_step); 
pRelease = linspace(clock_high,clock_low,clock_step); 
pReset =   linspace(clock_low,clock_low,clock_step); 
pCycle = [pSwitch pHold pRelease pReset];

%drivers
D0 = num2cell(+4.5*ones(1,clock_step*4));
D1 = num2cell(-4.5*ones(1,clock_step*4));
R0 = D1;
R1 = D0;

%layout (MagCAD)
file = 'xor.qll';
settings.out_path = fullfile(pwd,'xor'); 
            
%circuit configuration
circuit.dist_z = 10;
circuit.magcadImporter = 1;
circuit.doubleMolDriverMode = 1; 
circuit.qllFile = fullfile(pwd,file);

%drivers
circuit.Values_Dr = {
    'Dr1'       D0{:} D1{:} D0{:} D1{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'Dr1_c'     D1{:} D0{:} D1{:} D0{:} D1{:} D1{:} D1{:} D1{:} 'end'
    'Dr2'       D0{:} D0{:} D1{:} D1{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'Dr2_c'     D1{:} D1{:} D0{:} D0{:} D1{:} D1{:} D1{:} D1{:} 'end'
    'DrC1'      D1{:} D1{:} D1{:} D1{:} D1{:} D1{:} D1{:} D1{:} 'end'
    'DrC1_c'    D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'DrC0'      D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} D0{:} 'end'
    'DrC0_c'    D1{:} D1{:} D1{:} D1{:} D1{:} D1{:} D1{:} D1{:} 'end'    
};

%clock
circuit.stack_phase(1,:) = [pCycle pCycle pCycle pCycle pCycle pCycle pReset pReset pReset];
circuit.stack_phase(2,:) = [pReset pCycle pCycle pCycle pCycle pCycle pCycle pReset pReset];
circuit.stack_phase(3,:) = [pReset pReset pCycle pCycle pCycle pCycle pCycle pCycle pReset];
circuit.stack_phase(4,:) = [pReset pReset pReset pCycle pCycle pCycle pCycle pCycle pCycle];

%SCERPA settings
settings.doubleMolDriverMode = 1;
settings.damping = 0.6;
settings.activeRegionThreshold=0.005;
settings.verbosity = 1;
settings.conv_threshold_HP = 0.005;
settings.enableRefining = 0;
settings.enableActiveRegion = 1;
settings.dumpDriver = 1;
settings.dumpOutput = 1;
settings.dumpClock = 1;
settings.dumpComputationTime = 1;

%PLOT settings
plotSettings.plot_3dfig = 0;
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
scerpa_path = fullfile('SCERPA');
cd(scerpa_path)
generation_status = SCERPA('generateLaunch', circuit, settings);
                    SCERPA('plotSteps', plotSettings);
cd(this_path)
