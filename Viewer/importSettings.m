%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%       Self-Consistent Electrostatic Potential Algorithm (SCERPA)         %
%                                                                          %
%       VLSI Nanocomputing Research Group                                  %
%       Dept. of Electronics and Telecommunications                        %
%       Politecnico di Torino, Turin, Italy                                %
%       (https://www.vlsilab.polito.it/)                                   %
%                                                                          %
%       People [people you may contact for info]                           %
%         Yuri Ardesi (yuri.ardesi@polito.it)                              %
%         Giuliana Beretta (giuliana.beretta@polito.it)                    %
%                                                                          %
%       Supervision: Gianluca Piccinini, Mariagrazia Graziano              %
%                                                                          %
%       Relevant pubblications doi: 10.1109/TCAD.2019.2960360              %
%                                   10.1109/TVLSI.2020.3045198             %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function scerpaSettings = importSettings(userSettings)
% The function importSetting verifies if the user specified the settings:
% for those cases the function selects the proper userSettings field,
% otherwise it sets the default value.
% The function returns the complete set of settings (scerpaSettings).

% output path
if isfield(userSettings,'out_path') 
    % set by user
    scerpaSettings.out_path = strcat(userSettings.out_path,'/SCERPA_OUTPUT_FILES');
else
    % not set by the user!
    scerpaSettings.out_path = '../OUTPUT_FILES';
end

% general plot
scerpaSettings.fig_saver = setDefault(userSettings,'fig_saver',0);
scerpaSettings.plotSpan = setDefault(userSettings,'plotSpan',1);
scerpaSettings.plotList = setDefault(userSettings,'plotList',0);

% 3D Plot settings
scerpaSettings.plot_3dfig = setDefault(userSettings,'plot_3dfig',1);
scerpaSettings.plot_3dfig_plotAbsoluteCharge = setDefault(userSettings,'plot_3dfig_plotAbsoluteCharge',1);
scerpaSettings.plot_3dfig_molnum = setDefault(userSettings,'plot_3dfig_molnum',1);

% 1DCharge Plot settings
scerpaSettings.plot_1DCharge = setDefault(userSettings,'plot_1DCharge',0);

% Logic Plot settings
scerpaSettings.plot_logic = setDefault(userSettings,'plot_logic',0);

% Potential plot settings
scerpaSettings.plot_potential = setDefault(userSettings,'plot_potential',0);
scerpaSettings.plot_potential_padding = setDefault(userSettings,'plot_potential_padding',20);
scerpaSettings.plot_potential_saturationVoltage = setDefault(userSettings,'plot_potential_saturationVoltage',6);
scerpaSettings.plot_potential_tipHeight = setDefault(userSettings,'plot_potential_tipHeight',-3.5 -2);

% scerpaSettings.plot_clock = setDefault(userSettings,'plot_clock',0);

% Waveform Plot settings
scerpaSettings.plot_waveform = setDefault(userSettings,'plot_waveform',0);


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