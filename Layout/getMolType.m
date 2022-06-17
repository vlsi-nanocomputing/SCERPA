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
function molType = getMolType(QCA_circuit)

if ~isfield(QCA_circuit,'molecule')
    molType = '1'; % bisfe4_ox_counterionOnThiol
    warning('Default molecule 1.bisfe4_ox_counterionOnThiol');
else
    dirList = dir(fullfile('..','Database')); %get the list of molecules directories in the database
    dirNamesList = {dirList(:).name}; % extract the names of the directories
    if ~isempty(str2num(QCA_circuit.molecule)) % if the user specify a number
        index_2digit = strncmp(dirNamesList,[num2str(QCA_circuit.molecule) '.'],3); % get the index of the directory corresponding to the 2 digit number specified by the user
        index_1digit = strncmp(dirNamesList,[num2str(QCA_circuit.molecule) '.'],2); % get the index of the directory corresponding to the 1 digit number specified by the user
        if any(index_2digit) %if there is at least one directory corresponding to the 2 digit number specified by the user
            directoryName = dirNamesList{index_2digit};
            molType_cell = regexp(directoryName,'([0-9]+).','tokens');
            molType = cell2mat(molType_cell{1,1});
        elseif any(index_1digit) %if there is at least one directory corresponding to the 1 digit number specified by the user
            directoryName = dirNamesList{index_1digit};
            molType_cell = regexp(directoryName,'([0-9]+).','tokens');
            molType = cell2mat(molType_cell{1,1});
        else
            error('[ERROR][013] Unknown molecule (circuit.molecule)')
        end
    else
        error('[ERROR][014] Wrong molecule format, please write the corresponding number (circuit.molecule)')
    end
    
    
end    

% %Associate molType
% if ~isfield(QCA_circuit,'molecule')
%     molType = '1'; % bisfe4_ox_counterionOnThiol
%     warning('Default molecule 1.bisfe4_ox_counterionOnThiol');
% else
%     switch(QCA_circuit.molecule)
%         case 'bisfe4_ox_counterionOnCarbazole'
%             molType = '0';
%         case {'bisfe4_ox_counterionOnThiol','bisfe_4'} % backward compatibility
%             molType = '1';
%         case {'bisfe4_ox_counterionOnThiol_orca','bisfe_4_orca'} % backward compatibility
%             molType = '2';
%         case 'bisfe4_ox_noCounterion'
%             molType = '3';
%         case 'bisfe4_ox_noCounterion_TSA_2states'
%             molType = '4';
%         case 'bisfe4_ox_noCounterion_TSA_3states'
%             molType = '5';
%         case 'bisfe4_sym'
%             molType = '6';
%         case {'butane_ox_noCounterion','butane'} % backward compatibility
%             molType = '7';
%         case 'butane_ox_noCounterion_orca'
%             molType = '8';
%         case 'butaneCam' % backward compatibility
%             molType = '9';
%         case {'decatriene_ox_noCounterion','decatriene'} % backward compatibility
%             molType = '10';
%         case {'linear_mol_w7_a2000','linear_w7'} % backward compatibility
%             molType = '11';
%         case 'linear_mol_w7_a3000'
%             molType = '12';
%         case {'linear_mol_w9_a3000','linear_w9'} % backward compatibility
%             molType = '13';
%         case {'linear_mol_w95_a3000','linear_w95'} % backward compatibility
%             molType = '14';
%         case 'newMol_1'
%             molType = '15';
%         case 'newMol_2'
%             molType = '16';
%         case 'newMol_3'
%             molType = '17';
%         case 'newMol_4'
%             molType = '18';
%         case 'syntCrosswireDAC'
%             molType = '20';
%         otherwise
%             disp('[SCERPA ERROR] Unknown molecule (circuit.molecule)')
%             return
%     end
end


