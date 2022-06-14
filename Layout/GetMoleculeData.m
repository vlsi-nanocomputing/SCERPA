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
    dirList = dir(fullfile('..','Database'));
    dirNamesList = {dirList(:).name};
    molIdentifier = sprintf('%d.',str2double(molType));
    index = strncmp(dirNamesList,molIdentifier,2);
    directoryName = dirNamesList{index};
    filename = fullfile('..','Database',directoryName,'info.txt');
    

    in_str=fileread(filename); % string to analyze

    % read num of charges from database file
    xpr = ['CHARGES (\d)\n'];
    nCharges = regexp(in_str, xpr, 'tokens');
    chargeNum = str2double(cell2mat(nCharges{1,1}));

    % read dots coordinates from database file
    xcoo_expr = '(?<x>[-+]?\d*\.?\d+)[ ]{1,}';
    ycoo_expr = '(?<y>[-+]?\d*\.?\d+)[ ]{1,}';
    zcoo_expr = '(?<z>[-+]?\d*\.?\d+)\n';
    coo_xpr = [ xcoo_expr ycoo_expr zcoo_expr];
    coo = regexp(in_str,coo_xpr,'names');
    
    dot_position(:,1) = str2num(char({coo.x})); %assign x coordinates to first column
    dot_position(:,2) = str2num(char({coo.y})); %assign y coordinates to second column
    dot_position(:,3) = str2num(char({coo.z})); %assign z coordinates to third column

    % read dots associations from database file
    xpr = ['ASSOCIATION\s*(\d)\n'];
    num_associations_cell = regexp(in_str,xpr,'tokens');
    num_associations = str2double(cell2mat(num_associations_cell{1,1}));
    
    xpr = ['ASSOCIATION\s*\d\n[\d\s*\d\s*\n]+'];
    match_str = regexp(in_str, xpr, 'match');
    associations_cell = regexp(char(match_str),'(\d)\s*(\d)\s*\n+','tokens');
    
    draw_association = zeros(num_associations,2);
    for ii=1:num_associations
        draw_association(ii,:) = str2num(char(associations_cell{1,ii}))';
    end
    
  
    

%     %open file
%     fileId = fopen(filename);
%     
%     %loop on lines
%     tline = fgetl(fileId);
%  
%     while ischar(tline)
% 
%         % find charges section
%         if (regexp(tline, 'CHARGES [0-9]+') == 1) 
%             
%             %get number of charges
%             nCharges = textscan(tline,'CHARGES %d');
%             chargeNum = nCharges{1};
%             for ii=1:chargeNum
%                 
%                 %get line
%                 tline = fgetl(fileId);
%                 
%                 %scan line
%                 scannedData = textscan(tline,'%f %f %f');
%                 
%                 %obtain data
%                 dot_position(ii,1) = scannedData{1};
%                 dot_position(ii,2) = scannedData{2};
%                 dot_position(ii,3) = scannedData{3};
%                 
%             end
%             
%         end
% 
%         % find associations section
%         if (regexp(tline, 'ASSOCIATION [0-9]+') == 1) 
%             
%             %get number of charges
%             nAssociations = textscan(tline,'ASSOCIATION %d');
%             
%             for ii=1:nAssociations{1}
%                 
%                 %get line
%                 tline = fgetl(fileId);
%                 
%                 %scan line
%                 scannedData = textscan(tline,'%f %f');
%                 
%                 %obtain data
%                 draw_association(ii,1) = scannedData{1};
%                 draw_association(ii,2) = scannedData{2};
%                 
%             end
%             
%         end
%       
%         %get new line
%         tline = fgetl(fileId);   
%         
%     end
%     
%     %close file
%     fclose(fileId);

end
    
