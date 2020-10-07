clear all
close all

%definitions
clock_low = -2;
clock_high = +2;
clock_step = 3;

%molecule
circuit.molecule = 'bisfe_4';

%layout (MagCAD)
file = 'threePhasesWire.qll';
circuit.qllFile = sprintf('%s\\%s',pwd,file);

%layout (Layout Generator)
% circuit.structure = {'Dr1_c' 'Dr1' '1' '1' '1' '1' '1' '1' '1' '1' '2' '2' '2' '2' '2' '2' '2' '2' '3' '3' '3' '3' '3' '3' '3' '3'};
 
%drivers and clock
D0 = num2cell(-4.5*ones(1,clock_step*4));
D1 = num2cell(+4.5*ones(1,clock_step*4));
Dnone = num2cell(zeros(1,clock_step*4));

circuit.Values_Dr = {
    'Dr1'   D0{:} D1{:} Dnone{:} 'end'
    'Dr1_c' D1{:} D0{:} Dnone{:} 'end'
};

%clock
pSwitch =  linspace(clock_low,clock_high,clock_step); 
pHold =   linspace(clock_high,clock_high,clock_step); 
pRelease =  linspace(clock_high,clock_low,clock_step); 
pReset =   linspace(clock_low,clock_low,clock_step); 
pCycle = [pSwitch pHold pRelease pReset];

circuit.stack_phase(1,:) = [pCycle pCycle, pReset pReset];
circuit.stack_phase(2,:) = [pReset pCycle pCycle, pReset];
circuit.stack_phase(3,:) = [pReset pReset, pCycle pCycle];


%SCERPA settings
settings.doubleMolDriverMode = 1;
settings.damping = 0.6;
settings.verbosity = 2;

%RunTime Plot
settings.plotIntermediateSteps = 0;

%PLOT settings
plotSettings.plot_3dfig = 1;
plotSettings.plot_1DCharge = 1;
plotSettings.plot_logic = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 3;
plotSettings.fig_saver = 0;
plotSettings.plotList = 0;

%%%%
this_path = pwd;
scerpa_path = '..\';
cd(scerpa_path)
% generation_status = SCERPA('topoLaunch', circuit, settings);
% generation_status = SCERPA('generateLaunch', circuit, settings);
                    SCERPA('plotSteps', plotSettings);
cd(this_path)