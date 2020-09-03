function scerpaSettings = importSettings(userSettings)
% The function importSetting verifies if the user specified the settings:
% for those cases the function selects the proper userSettings field,
% otherwise it sets the default value.
% The function returns the complete set of settings (scerpaSettings).


% general plot
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

% 3d Plot settings
if isfield(userSettings,'plot_3dfig')
    scerpaSettings.plot_3dfig = userSettings.plot_3dfig;
else 
    scerpaSettings.plot_3dfig = 1; % default value
end

if isfield(userSettings,'plot_3dfig_plotAbsoluteCharge')
    scerpaSettings.plot_3dfig_plotAbsoluteCharge=userSettings.plot_3dfig_plotAbsoluteCharge;
else
    scerpaSettings.plot_3dfig_plotAbsoluteCharge = 1; % default value
end

if isfield(userSettings,'plot_3dfig_molnum')
    scerpaSettings.plot_3dfig_molnum = userSettings.plot_3dfig_molnum;
else
    scerpaSettings.plot_3dfig_molnum = 1; % default value
end

% 1DCharge Plot settings
if isfield(userSettings,'plot_1DCharge')
    scerpaSettings.plot_1DCharge = userSettings.plot_1DCharge;
else 
    scerpaSettings.plot_1DCharge = 0; % default value
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

% Logic Plot settings
if isfield(userSettings,'plot_logic')
    scerpaSettings.plot_logic = userSettings.plot_logic;
else
    scerpaSettings.plot_logic = 0; % default value
end

% Potential plot settings
if isfield(userSettings,'plot_potential')
    scerpaSettings.plot_potential = userSettings.plot_potential;
else
    scerpaSettings.plot_potential = 0; % default value
end

if isfield(userSettings,'plot_potential_padding')
    scerpaSettings.plot_potential_padding = userSettings.plot_potential_padding;
else
    scerpaSettings.plot_potential_padding = 20; % default value
end

if isfield(userSettings,'plot_potential_saturationVoltage')
    scerpaSettings.plot_potential_saturationVoltage = userSettings.plot_potential_saturationVoltage;
else
    scerpaSettings.plot_potential_saturationVoltage = 6; % default value
end

if isfield(userSettings,'plot_potential_tipHeight')
    scerpaSettings.plot_potential_tipHeight = userSettings.plot_potential_tipHeight;
else
    scerpaSettings.plot_potential_tipHeight = -3.5 -2; % default value
end



% if isfield(userSettings,'plot_clock')
%     scerpaSettings.plot_clock = userSettings.plot_clock;
% else
%     scerpaSettings.plot_clock = 0; % default value
% end




end