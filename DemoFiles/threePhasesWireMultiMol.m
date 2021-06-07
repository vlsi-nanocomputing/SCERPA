clear all
close all

%definitions
clock_low = -2;
clock_high = +2;
clock_step = 3;

%layout (MagCAD)
% file = 'threePhasesWireMultiMol.qll';
% circuit.qllFile = sprintf('%s\\%s',pwd,file);
% circuit.doubleMolDriverMode = 1;   
% circuit.magcadImporter = 1;

%layout (Layout Generator)
circuit.structure = {'Dr1_c' 'Dr1' '1' '1' '1' '1' '1' '1' '1' '1' '2' '2' '2' '2' '2' '2' '2' '2' '3' '3' '3' '3' '3' '3' '3' '3'};
circuit.components = {'0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '7' '7' '7' '7' '7' '7' '7' '7'};
circuit.magcadImporter = 0;
 
%drivers and clock
D0 = num2cell(-4.5*ones(1,clock_step*4));
D1 = num2cell(+4.5*ones(1,clock_step*4));
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

circuit.stack_phase(1,:) = [pCycle pCycle, pReset pReset];
circuit.stack_phase(2,:) = [pReset pCycle pCycle, pReset];
circuit.stack_phase(3,:) = [pReset pReset, pCycle pCycle];


%SCERPA settings
settings.doubleMolDriverMode = 1;
settings.damping = 0.6;
settings.verbosity = 2;

%PLOT settings
plotSettings.plot_3dfig = 1;
plotSettings.plot_logic = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 3;
plotSettings.fig_saver = 1;
plotSettings.plotList = 0;
plotSettings.plot_potential_tipHeight = -10;

%%%%
this_path = pwd;
scerpa_path = '..\';
cd(scerpa_path)
generation_status = SCERPA('generateLaunch', circuit, settings);
                    SCERPA('plotSteps', plotSettings);
cd(this_path)