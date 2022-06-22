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
    %retain available molecules
    dirList = dir(fullfile('..','Database')); %get the list of molecules directories in the database
    dirNamesList = {dirList(:).name}; % extract the names of the directories
    
    %read molecule type
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

end


