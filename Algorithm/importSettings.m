function scerpaSettings = importSettings(userSettings)
% The function importSetting verifies if the user specified the settings:
% for those cases the function selects the proper userSettings field,
% otherwise it sets the default value.
% The function returns the complete set of settings (scerpaSettings).

% time definition
scerpaSettings.timestep = setDefault(userSettings,'timestep',1);

% topo integration
% scerpaSettings.magcadImporter = setDefault(userSettings,'magcadImporter',0);
% scerpaSettings.doubleMolDriverMode = setDefault(userSettings,'doubleMolDriverMode',0);

% Energy
scerpaSettings.energyEval = setDefault(userSettings,'energyEval',0);

% output plot
if isfield(userSettings,'out_path') 
    % set by user
    scerpaSettings.out_path = strcat(userSettings.out_path,'/SCERPA_OUTPUT_FILES');
else
    % not set by the user!
    scerpaSettings.out_path = '../OUTPUT_FILES';
end
scerpaSettings.plot_plotAbsoluteCharge = setDefault(userSettings,'plot_plotAbsoluteCharge',1);
scerpaSettings.plotIntermediateSteps = setDefault(userSettings,'plotIntermediateSteps',0);
scerpaSettings.plotActiveRegionWindow = setDefault(userSettings,'plotActiveRegionWindow',0);
scerpaSettings.plot_3dfig = setDefault(userSettings,'plot_3dfig',0);
scerpaSettings.plot_voltage = setDefault(userSettings,'plot_voltage',0);
scerpaSettings.plot_chargeFig = setDefault(userSettings,'plot_chargeFig',0);
scerpaSettings.plot_clock = setDefault(userSettings,'plot_clock',0);
scerpaSettings.plot_molnum = setDefault(userSettings,'plot_molnum',1);
scerpaSettings.verbosity = setDefault(userSettings,'verbosity',0); % (0 no data, 1 step number, 2 converge info)
scerpaSettings.pauseStep = setDefault(userSettings,'pauseStep',0);
scerpaSettings.fig_saver = setDefault(userSettings,'fig_saver',0); % not working


%convergence settings
scerpaSettings.max_step = setDefault(userSettings,'max_step',1000);
scerpaSettings.immediateUpdate = setDefault(userSettings,'immediateUpdate',0);
scerpaSettings.damping = setDefault(userSettings,'damping',0.4); % value must be in range [0 - 1)
scerpaSettings.autodamping = setDefault(userSettings,'autodamping',0);

%convergence accelerations
scerpaSettings.enableRefining = setDefault(userSettings,'enableRefining',1); % value must be in range [0 - 1)
scerpaSettings.enableActiveRegion = setDefault(userSettings,'enableActiveRegion',1); 
scerpaSettings.activeRegionThreshold = setDefault(userSettings,'activeRegionThreshold',0.0015); 
scerpaSettings.enableInteractionRadiusMode = setDefault(userSettings,'enableInteractionRadiusMode',1); 
scerpaSettings.interactionRadius = setDefault(userSettings,'interactionRadius',101); 

% DEBUG informations
scerpaSettings.printConvergenceTable = setDefault(userSettings,'printConvergenceTable',0); 

% LP-LPP modes
scerpaSettings.LPmode = setDefault(userSettings,'LPmode',200); 
scerpaSettings.LPPmode = setDefault(userSettings,'LPPmode',300); 
scerpaSettings.conv_threshold_HP = setDefault(userSettings,'conv_threshold_HP',0.000005); 
scerpaSettings.conv_threshold_LP = setDefault(userSettings,'conv_threshold_LP',0.0005); 
scerpaSettings.conv_threshold_LLP = setDefault(userSettings,'conv_threshold_LLP',0.005); 

% MATLAB optimizations
scerpaSettings.enableJit = setDefault(userSettings,'enableJit',1); 

% driver saturation
scerpaSettings.driverSaturation = setDefault(userSettings,'driverSaturation',0); 

%dump information
scerpaSettings.dumpClock = setDefault(userSettings,'dumpClock',0);
scerpaSettings.dumpVout = setDefault(userSettings,'dumpVout',0);
scerpaSettings.dumpDriver = setDefault(userSettings,'dumpDriver',0);
scerpaSettings.dumpOutput = setDefault(userSettings,'dumpOutput',0);
scerpaSettings.dumpComputationTime = setDefault(userSettings,'dumpComputationTime',0);
scerpaSettings.dumpEnergy = setDefault(userSettings,'dumpEnergy',0);

% compatibility
scerpaSettings.y.enable_escape = 1;
scerpaSettings.y.show_intermediate_steps = scerpaSettings.plotIntermediateSteps;
scerpaSettings.y.LPmode = scerpaSettings.LPmode;
scerpaSettings.y.LPPmode = scerpaSettings.LPPmode;
scerpaSettings.y.immediateUpdate = scerpaSettings.immediateUpdate;
scerpaSettings.y.damping = scerpaSettings.damping;

end

% Function to substitute user value to default one (if user set a value)
function finalValue = setDefault(user,field,defaultValue)
    if isfield(user,field) 
        % set by user
        finalValue = user.(field);
    else
        % not set by the user!
        finalValue = defaultValue;
    end
end
