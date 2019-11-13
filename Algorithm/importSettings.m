function scerpaSettings = importSettings(userSettings)%molecule
%   available molecules:
%       bisfe4_ox_counterionOnCarbazole
%       bisfe4_ox_counterionOnThiol
%       butane_ox_noCounterion
%       bisfe4_ox_noCounterion_TSA_2states
%       bisfe4_ox_noCounterion_TSA_3states
%       butane_ox_noCounterion
%       decatriene_ox_noCounterion
scerpaSettings.molecule='bisfe4_ox_counterionOnThiol';
scerpaSettings.Ncharges=4;

%topo integration
scerpaSettings.magcadImporter=0;
scerpaSettings.doubleMolDriverMode=0;

%Solver to be used for the calculation of charges (r/y/scfHTSA2/E)
scerpaSettings.solver='E';
scerpaSettings.energyEval=0;

%plot
scerpaSettings.plotActiveRegionWindow = 0;
scerpaSettings.plotIntermediateSteps = 0;
scerpaSettings.fig_saver = 'no';
scerpaSettings.pauseStep = 0;
scerpaSettings.verbosity = 0; %0 no data, 1 step number, 2 converge info
scerpaSettings.plot_3dfig = 1;
scerpaSettings.plot_voltage = 1;
scerpaSettings.plot_chargeFig = 1;
scerpaSettings.plot_logic = 0;
scerpaSettings.plot_molnum = 1;


%convergence settings
scerpaSettings.max_step = 1000;
scerpaSettings.immediateUpdate = 1;
scerpaSettings.damping = 0.0; %value must be in range [0 - 1) %hint: 0.2

%convergence accelerations
scerpaSettings.enableRefining = 1;
scerpaSettings.enableActiveRegion = 1;
scerpaSettings.activeRegionThreshold = 0.0001;
scerpaSettings.enableInteractionRadiusMode=1;
scerpaSettings.interactionRadius = 80;

%DEBUG informations
scerpaSettings.printConvergenceTable = 0;

%LP-LPP modes
scerpaSettings.LPmode = 200;
scerpaSettings.LPPmode = 300;
scerpaSettings.conv_threshold_HP  = 0.000005;
scerpaSettings.conv_threshold_LP  = 0.0005;
scerpaSettings.conv_threshold_LLP = 0.005;

%MATLAB optimizations
scerpaSettings.enableJit = 1;

%driver saturation
scerpaSettings.driverSaturation = 0;

%%%%%%%%%%% 

%topo integration
if isfield(userSettings,'magcadImporter')
    scerpaSettings.magcadImporter=userSettings.magcadImporter;
end

if isfield(userSettings,'doubleMolDriverMode')
    scerpaSettings.doubleMolDriverMode=userSettings.doubleMolDriverMode;
end

if isfield(userSettings,'molecule')
    scerpaSettings.molecule=userSettings.molecule;
end
if isfield(userSettings,'Ncharges')
    scerpaSettings.Ncharges=userSettings.Ncharges;
end
if isfield(userSettings,'solver')
    scerpaSettings.solver=userSettings.solver;
end
if isfield(userSettings,'energyEval')
    scerpaSettings.energyEval=userSettings.energyEval;
end

%output
if isfield(userSettings,'plotIntermediateSteps')
    scerpaSettings.plotIntermediateSteps=userSettings.plotIntermediateSteps;
end
if isfield(userSettings,'plotActiveRegionWindow')
    scerpaSettings.plotActiveRegionWindow = userSettings.plotActiveRegionWindow;
end
if isfield(userSettings,'plotIntermediateSteps')
    scerpaSettings.plotIntermediateSteps = userSettings.plotIntermediateSteps;
end

if isfield(userSettings,'plot_3dfig')
    scerpaSettings.plot_3dfig = userSettings.plot_3dfig;
end

if isfield(userSettings,'plot_voltage')
    scerpaSettings.plot_voltage = userSettings.plot_voltage;
end

if isfield(userSettings,'plot_chargeFig')
    scerpaSettings.plot_chargeFig = userSettings.plot_chargeFig;
end

if isfield(userSettings,'plot_logic')
    scerpaSettings.plot_logic = userSettings.plot_logic;
end

if isfield(userSettings,'plot_molnum')
    scerpaSettings.plot_molnum = userSettings.plot_molnum;
end


if isfield(userSettings,'verbosity')
    scerpaSettings.verbosity = userSettings.verbosity;
end
if isfield(userSettings,'pauseStep')
    scerpaSettings.pauseStep = userSettings.pauseStep;
end

if isfield(userSettings,'fig_saver')
    scerpaSettings.fig_saver = userSettings.fig_saver;
end

%convergence settings
if isfield(userSettings,'max_step')
    scerpaSettings.max_step = userSettings.max_step;
end
if isfield(userSettings,'immediateUpdate')
    scerpaSettings.immediateUpdate = userSettings.immediateUpdate;
end
if isfield(userSettings,'damping')
    scerpaSettings.damping = userSettings.damping;
end


%convergence accelerations
if isfield(userSettings,'enableRefining')
	scerpaSettings.enableRefining = userSettings.enableRefining;
end
if isfield(userSettings,'enableActiveRegion')
	scerpaSettings.enableActiveRegion = userSettings.enableActiveRegion;
end
if isfield(userSettings,'activeRegionThreshold')
    scerpaSettings.activeRegionThreshold = userSettings.activeRegionThreshold;
end
if isfield(userSettings,'enableInteractionRadiusMode')
    scerpaSettings.enableInteractionRadiusMode=userSettings.enableInteractionRadiusMode;
end
if isfield(userSettings,'interactionRadius')
    scerpaSettings.interactionRadius = userSettings.interactionRadius;
end

%DEBUG informations
if isfield(userSettings,'printConvergenceTable')
    scerpaSettings.printConvergenceTable = userSettings.printConvergenceTable;
end

%LP-LPP modes
if isfield(userSettings,'LPmode')
    scerpaSettings.LPmode = userSettings.LPmode;
end
if isfield(userSettings,'LPPmode')
    scerpaSettings.LPPmode = userSettings.LPPmode;
end
if isfield(userSettings,'conv_threshold_HP')
    scerpaSettings.conv_threshold_HP  = userSettings.conv_threshold_HP;
end
if isfield(userSettings,'conv_threshold_LP')
    scerpaSettings.conv_threshold_LP  = userSettings.conv_threshold_LP;
end
if isfield(userSettings,'conv_threshold_LLP')
    scerpaSettings.conv_threshold_LLP = userSettings.conv_threshold_LLP;
end

%MATLAB configurations
if isfield(userSettings,'enableJit')
    scerpaSettings.enableJit = userSettings.enableJit;
end

if isfield(userSettings,'driverSaturation')
    scerpaSettings.driverSaturation=userSettings.driverSaturation;
end


%compatibility
scerpaSettings.y.enable_escape = 1;
scerpaSettings.y.show_intermediate_steps = scerpaSettings.plotIntermediateSteps;
scerpaSettings.y.LPmode = scerpaSettings.LPmode;
scerpaSettings.y.LPPmode = scerpaSettings.LPPmode;
scerpaSettings.y.immediateUpdate = scerpaSettings.immediateUpdate;
scerpaSettings.y.damping =scerpaSettings.damping;

end