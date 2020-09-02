function scerpaSettings = importSettings(userSettings)
% The function importSetting verifies if the user specified the settings:
% for those cases the function selects the proper userSettings field,
% otherwise it sets the default value.
% The function returns the complete set of settings (scerpaSettings).



% time definitions
if isfield(userSettings,'timestep') %not used!
    scerpaSettings.timestep=userSettings.timestep;
else
    scerpaSettings.timestep=1; % default value
end


% topo integration
if isfield(userSettings,'magcadImporter')
    scerpaSettings.magcadImporter=userSettings.magcadImporter;
else
    scerpaSettings.magcadImporter=0; % default value
end
if isfield(userSettings,'doubleMolDriverMode')
    scerpaSettings.doubleMolDriverMode=userSettings.doubleMolDriverMode;
else
    scerpaSettings.doubleMolDriverMode=0; % dafault value
end


% Energy
if isfield(userSettings,'energyEval')
    scerpaSettings.energyEval=userSettings.energyEval;
else
    scerpaSettings.energyEval=0; % dafault value
end


% output plot
if isfield(userSettings,'plot_plotAbsoluteCharge')
    scerpaSettings.plot_plotAbsoluteCharge=userSettings.plot_plotAbsoluteCharge;
else
    scerpaSettings.plot_plotAbsoluteCharge = 1; % default value
end
if isfield(userSettings,'plotIntermediateSteps')
    scerpaSettings.plotIntermediateSteps=userSettings.plotIntermediateSteps;
else
    scerpaSettings.plotIntermediateSteps = 0; % default value
end
if isfield(userSettings,'plotActiveRegionWindow')
    scerpaSettings.plotActiveRegionWindow = userSettings.plotActiveRegionWindow;
else
    scerpaSettings.plotActiveRegionWindow = 0; % default value
end
if isfield(userSettings,'plot_3dfig')
    scerpaSettings.plot_3dfig = userSettings.plot_3dfig;
else 
    scerpaSettings.plot_3dfig = 0; % default value
end
if isfield(userSettings,'plot_voltage')
    scerpaSettings.plot_voltage = userSettings.plot_voltage;
else
    scerpaSettings.plot_voltage = 0; % default value
end
if isfield(userSettings,'plot_chargeFig')
    scerpaSettings.plot_chargeFig = userSettings.plot_chargeFig;
else
    scerpaSettings.plot_chargeFig = 0; % default value
end
if isfield(userSettings,'plot_clock')
    scerpaSettings.plot_clock = userSettings.plot_clock;
else
    scerpaSettings.plot_clock = 0; % default value
end
if isfield(userSettings,'plot_molnum')
    scerpaSettings.plot_molnum = userSettings.plot_molnum;
else
    scerpaSettings.plot_molnum = 1; % default value
end
if isfield(userSettings,'verbosity')
    scerpaSettings.verbosity = userSettings.verbosity;
else
    scerpaSettings.verbosity = 0; % default value (0 no data, 1 step number, 2 converge info)
end
if isfield(userSettings,'pauseStep')
    scerpaSettings.pauseStep = userSettings.pauseStep;
else
    scerpaSettings.pauseStep = 0; % default value
end
if isfield(userSettings,'fig_saver')
    scerpaSettings.fig_saver = userSettings.fig_saver;
else
    scerpaSettings.fig_saver = 'no'; % default value
end


%convergence settings
if isfield(userSettings,'max_step')
    scerpaSettings.max_step = userSettings.max_step;
else
    scerpaSettings.max_step = 1000; % default value
end
if isfield(userSettings,'immediateUpdate')
    scerpaSettings.immediateUpdate = userSettings.immediateUpdate;
else
    scerpaSettings.immediateUpdate = 1; % default value
end
if isfield(userSettings,'damping')
    scerpaSettings.damping = userSettings.damping;
else
    scerpaSettings.damping = 0.0; % default value, value must be in range [0 - 1) %hint: 0.2
end


%convergence accelerations
if isfield(userSettings,'enableRefining')
	scerpaSettings.enableRefining = userSettings.enableRefining;
else
    scerpaSettings.enableRefining = 1; % default value
end
if isfield(userSettings,'enableActiveRegion')
	scerpaSettings.enableActiveRegion = userSettings.enableActiveRegion;
else
    scerpaSettings.enableActiveRegion = 1; % default value
end
if isfield(userSettings,'activeRegionThreshold')
    scerpaSettings.activeRegionThreshold = userSettings.activeRegionThreshold;
else
    scerpaSettings.activeRegionThreshold = 0.0015; % default value
end
if isfield(userSettings,'enableInteractionRadiusMode')
    scerpaSettings.enableInteractionRadiusMode=userSettings.enableInteractionRadiusMode;
else
    scerpaSettings.enableInteractionRadiusMode=1; % default value
end
if isfield(userSettings,'interactionRadius')
    scerpaSettings.interactionRadius = userSettings.interactionRadius;
else
    scerpaSettings.interactionRadius = 101; % default value
end


% DEBUG informations
if isfield(userSettings,'printConvergenceTable')
    scerpaSettings.printConvergenceTable = userSettings.printConvergenceTable;
else
    scerpaSettings.printConvergenceTable = 0; % default value
end


% LP-LPP modes
if isfield(userSettings,'LPmode')
    scerpaSettings.LPmode = userSettings.LPmode;
else
    scerpaSettings.LPmode = 200; % default value
end
if isfield(userSettings,'LPPmode')
    scerpaSettings.LPPmode = userSettings.LPPmode;
else
    scerpaSettings.LPPmode = 300; % default value
end
if isfield(userSettings,'conv_threshold_HP')
    scerpaSettings.conv_threshold_HP  = userSettings.conv_threshold_HP;
else
    scerpaSettings.conv_threshold_HP  = 0.000005; % default value
end
if isfield(userSettings,'conv_threshold_LP')
    scerpaSettings.conv_threshold_LP  = userSettings.conv_threshold_LP;
else
    scerpaSettings.conv_threshold_LP  = 0.0005; % default value
end
if isfield(userSettings,'conv_threshold_LLP')
    scerpaSettings.conv_threshold_LLP = userSettings.conv_threshold_LLP;
else
    scerpaSettings.conv_threshold_LLP = 0.005; % default value
end


% MATLAB optimizations
if isfield(userSettings,'enableJit')
    scerpaSettings.enableJit = userSettings.enableJit;
else
    scerpaSettings.enableJit = 1; % default value
end


% driver saturation
if isfield(userSettings,'driverSaturation')
    scerpaSettings.driverSaturation=userSettings.driverSaturation;
else
    scerpaSettings.driverSaturation = 0; % default value
end


%compatibility
scerpaSettings.y.enable_escape = 1;
scerpaSettings.y.show_intermediate_steps = scerpaSettings.plotIntermediateSteps;
scerpaSettings.y.LPmode = scerpaSettings.LPmode;
scerpaSettings.y.LPPmode = scerpaSettings.LPPmode;
scerpaSettings.y.immediateUpdate = scerpaSettings.immediateUpdate;
scerpaSettings.y.damping = scerpaSettings.damping;

end