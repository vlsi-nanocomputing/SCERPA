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
function [chargeNum, dot_position, draw_association] = GetMoleculeData(molType) 
    % The function GetMoleculeData is used to get geometry information 
    % about the molecule type specified by <<molType>>. 
    % The input should be a string containing the number associated to the
    % molecule under test.
    % The function returns two informations:
    %   dot_position -> is a matrix containing the xyz coordinates for each
    %                   dot (1st row <-> 1st dot, 2nd row <-> 2nd dot, ...)
    %   draw_association -> is a matrix containing the couple of dots which
    %                       are connected
    
    

    % get the directory name of the molecule
    dirList = dir('../Database');
    dirNamesList = {dirList(:).name};
    molIdentifier = sprintf('%d.',str2double(molType));
    index = strncmp(dirNamesList,molIdentifier,2);
    directoryName = dirNamesList{index};
    filename = fullfile('..','Database',directoryName,'info.txt');
    
    %open file
    fileId = fopen(filename);
    
    %loop on lines
    tline = fgetl(fileId);
 
    while ischar(tline)

        % find charges section
        if (regexp(tline, 'CHARGES [0-9]+') == 1) 
            
            %get number of charges
            nCharges = textscan(tline,'CHARGES %d');
            chargeNum = nCharges{1};
            for ii=1:chargeNum
                
                %get line
                tline = fgetl(fileId);
                
                %scan line
                scannedData = textscan(tline,'%f %f %f');
                
                %obtain data
                dot_position(ii,1) = scannedData{1};
                dot_position(ii,2) = scannedData{2};
                dot_position(ii,3) = scannedData{3};
                
            end
            
        end

        % find associations section
        if (regexp(tline, 'ASSOCIATION [0-9]+') == 1) 
            
            %get number of charges
            nAssociations = textscan(tline,'ASSOCIATION %d');
            
            for ii=1:nAssociations{1}
                
                %get line
                tline = fgetl(fileId);
                
                %scan line
                scannedData = textscan(tline,'%f %f');
                
                %obtain data
                draw_association(ii,1) = scannedData{1};
                draw_association(ii,2) = scannedData{2};
                
            end
            
        end
      
        %get new line
        tline = fgetl(fileId);   
        
    end
    
    %close file
    fclose(fileId);

end
    
