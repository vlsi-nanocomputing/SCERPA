clear variables
close all

%clock values definition
clock_low = -2;
clock_high = +2;
clock_step = 5;

%layout (MagCAD)
% file = 'L.qll';
% settings.out_path = fullfile(pwd,'connection_L'); 

% file = 'Lcorr.qll';
% settings.out_path = fullfile(pwd,'connection_Lcorr'); 

% file = 'Llarge.qll';
% settings.out_path = fullfile(pwd,'connection_Llarge'); 

% file = 'T.qll';
% settings.out_path = fullfile(pwd,'connection_T'); 

% file = 'Tcorr.qll';
% settings.out_path = fullfile(pwd,'connection_Tcorr'); 

file = 'Tlarge.qll';
settings.out_path = fullfile(pwd,'connection_Tlarge'); 

%circuit configuration
circuit.dist_z = 10;
circuit.magcadImporter = 1;
circuit.doubleMolDriverMode = 1; 
circuit.qllFile = fullfile(pwd,file);
 
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

circuit.stack_phase(1,:) = [pCycle pCycle pSwitch];
circuit.stack_phase(2,:) = [pReset pCycle pCycle];


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
plotSettings.plotSpan = 3;
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