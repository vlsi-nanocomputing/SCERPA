clear variables
close all

%clock values definition
clock_low = -2;
clock_high = +2;
clock_step = 3;


%layout (MagCAD)
% file = 'threePhasesWire.qll';
% circuit.qllFile = fullfile(pwd,file);
% circuit.doubleMolDriverMode = 1;   
% circuit.magcadImporter = 1;

%molecule
% circuit.molecule = 'bisfe_4';

%layout (MATLAB)
circuit.structure = {'Dr1_c' 'Dr1' '1' '1' '1' '1' '1' '1' '1' '1' '2' '2' '2' '2' '2' '2' '2' '2' '3' '3' '3' '3' '3' '3' '3' '3' 'out_1'};
circuit.magcadImporter = 0;

circuit.plotLayout = 1;
circuit.dist_x = 10;
circuit.dist_y = 2 * circuit.dist_x;
circuit.shift_x = zeros(1,27);
circuit.shift_y = zeros(1,27);
circuit.shift_z = zeros(1,27);
circuit.rotation_x = zeros(1,27);
circuit.rotation_y = zeros(1,27);
circuit.rotation_z = zeros(1,27);



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
settings.out_path = fullfile('/mnt/44CEE091CEE07D14/PhD/tmp','/threePhaseWire'); 
settings.damping = 0.6;
settings.verbosity = 2;
settings.dumpDriver = 1;
settings.dumpOutput = 1;
settings.dumpClock = 1;
settings.plotIntermediateSteps = 0;

%PLOT settings
plotSettings.plot_waveform = 1;
plotSettings.plot_3dfig = 1;
plotSettings.plot_1DCharge = 1;
plotSettings.plot_logic = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 3;
plotSettings.fig_saver = 1;
plotSettings.plotList = 0;

%copy outputh path from algorithm settings if specified by the user
if isfield(settings,'out_path') 
    plotSettings.out_path = settings.out_path;
end


%%%%
this_path = pwd;
scerpa_path = fullfile('../');
cd(scerpa_path)
%
generation_status = SCERPA('generateLaunch', circuit, settings);
                    SCERPA('plotSteps', plotSettings);

cd(this_path)