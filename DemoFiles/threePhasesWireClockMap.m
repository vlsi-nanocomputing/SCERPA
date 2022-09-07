clear variables
close all

%clock values definitions
clock_low = -2;
clock_high = +2;
clock_step = 3;

% %layout (MagCAD)
% file = 'threePhasesWire.qll';
% circuit.qllFile = fullfile(pwd,file);
% circuit.doubleMolDriverMode = 1;
% circuit.magcadImporter = 1;


%layout (MATLAB)
circuit.structure = {'Dr1_c' 'Dr1' '1' '1' '1' '1' '1' '1' '1' '1' '2' '2' '2' '2' '2' '2' '2' '2' '3' '3' '3' '3' '3' '3' '3' '3'  'Out_y'};
circuit.magcadImporter = 0;
circuit.molecule = '1';
 
%drivers and clock
D0 = num2cell(-4.5*ones(1,clock_step*4));
D1 = num2cell(+4.5*ones(1,clock_step*4));
Dnone = num2cell(zeros(1,clock_step*4));

circuit.Values_Dr = {
    'Dr1'   D0{:} D1{:} Dnone{:}
    'Dr1_c' D1{:} D0{:} Dnone{:}
};

%clock
circuit.clockMode='map';

%defined here (can be obtained by a csv file)
z = 400*rand(1000,1)-20;
y = 100*rand(1000,1)-20;
Eclock1 = 4*exp((-z.^2-y.^2)/3000) - 2;
Eclock2 = 4*exp((-(z-100).^2-y.^2)/3000) - 2;
Eclock3 = 4*exp((-(z-200).^2-y.^2)/3000) - 2;

circuit.ckmap.coords = [z y];
circuit.ckmap.field = [Eclock1 Eclock2 Eclock3];

%SCERPA settings
settings.damping = 0.6;
settings.verbosity = 2;
settings.plot_clock = 1;

%PLOT settings
plotSettings.plot_1DCharge = 1;
plotSettings.plot_potential = 1;
plotSettings.plotSpan = 1;

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