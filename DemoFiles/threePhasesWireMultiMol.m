clear variables
close all

%definitions
clock_low = -2;
clock_high = +2;
clock_step = 3;

%layout (MagCAD)
% file = 'threePhasesWireMultiMol.qll';
% circuit.qllFile = fullfile(pwd,file);
% circuit.doubleMolDriverMode = 1;   
% circuit.magcadImporter = 1;

%layout (Layout Generator)
circuit.structure = {'Dr1_c' 'Dr1' '1' '1' '1' '1' '1' '1' '1' '1' '2' '2' '2' '2' '2' '2' '2' '2' '3' '3' '3' '3' '3' '3' '3' '3'};
circuit.components = {'1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '7' '7' '7' '7' '7' '7' '7' '7'};
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
settings.damping = 0.6;
settings.verbosity = 2;

%PLOT settings
plotSettings.plot_3dfig = 1;
plotSettings.plot_logic = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 3;
plotSettings.plot_potential_tipHeight = -10;

%copy outputh path from algorithm settings if specified by the user
if isfield(settings,'out_path') 
    plotSettings.out_path = settings.out_path;
end

%%%%
diary on
this_path = pwd;
scerpa_path = fullfile('../');
cd(scerpa_path)
SCERPA('generateLaunchView', circuit, settings, plotSettings);
cd(this_path)
diary off
if isfield(settings,'out_path') 
    movefile('diary',fullfile(settings.out_path,'logfile.log'))
end