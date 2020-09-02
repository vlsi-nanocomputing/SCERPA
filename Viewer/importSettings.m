function scerpaSettings = importSettings(userSettings)
% The function importSetting verifies if the user specified the settings:
% for those cases the function selects the proper userSettings field,
% otherwise it sets the default value.
% The function returns the complete set of settings (scerpaSettings).




% output plot
if isfield(userSettings,'plot_plotAbsoluteCharge')
    scerpaSettings.plot_plotAbsoluteCharge=userSettings.plot_plotAbsoluteCharge;
else
    scerpaSettings.plot_plotAbsoluteCharge = 1; % default value
end
% if isfield(userSettings,'plotIntermediateSteps')
%     scerpaSettings.plotIntermediateSteps=userSettings.plotIntermediateSteps;
% else
%     scerpaSettings.plotIntermediateSteps = 0; % default value
% end
% if isfield(userSettings,'plotActiveRegionWindow')
%     scerpaSettings.plotActiveRegionWindow = userSettings.plotActiveRegionWindow;
% else
%     scerpaSettings.plotActiveRegionWindow = 0; % default value
% end
if isfield(userSettings,'plot_3dfig')
    scerpaSettings.plot_3dfig = userSettings.plot_3dfig;
else 
    scerpaSettings.plot_3dfig = 1; % default value
end
% if isfield(userSettings,'plot_voltage')
%     scerpaSettings.plot_voltage = userSettings.plot_voltage;
% else
%     scerpaSettings.plot_voltage = 1; % default value
% end
% if isfield(userSettings,'plot_chargeFig')
%     scerpaSettings.plot_chargeFig = userSettings.plot_chargeFig;
% else
%     scerpaSettings.plot_chargeFig = 0; % default value
% end
if isfield(userSettings,'plot_logic')
    scerpaSettings.plot_logic = userSettings.plot_logic;
else
    scerpaSettings.plot_logic = 0; % default value
end
if isfield(userSettings,'plot_potential')
    scerpaSettings.plot_potential = userSettings.plot_potential;
else
    scerpaSettings.plot_potential = 0; % default value
end
% if isfield(userSettings,'plot_clock')
%     scerpaSettings.plot_clock = userSettings.plot_clock;
% else
%     scerpaSettings.plot_clock = 0; % default value
% end
if isfield(userSettings,'plot_molnum')
    scerpaSettings.plot_molnum = userSettings.plot_molnum;
else
    scerpaSettings.plot_molnum = 1; % default value
end
if isfield(userSettings,'fig_saver')
    scerpaSettings.fig_saver = userSettings.fig_saver;
else
    scerpaSettings.fig_saver = 0; % default value
end
if isfield(userSettings,'plotSpan')
    scerpaSettings.plotSpan = userSettings.plotSpan;
else
    scerpaSettings.plotSpan = 1; % default value
end
if isfield(userSettings,'plotList')
    scerpaSettings.plotList = userSettings.plotList;
else
    scerpaSettings.plotList = 0; % default value
end


end