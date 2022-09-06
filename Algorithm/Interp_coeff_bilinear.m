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
function [CK] = Interp_coeff_bilinear(molecule)

formatSpec = '%f %f %f %f %f'; % file format for reading

% get the directory name of the molecule
dirList = dir(fullfile('..','Database'));
dirNamesList = {dirList(:).name};
molIdentifier = sprintf('%d.',molecule);
index = strncmp(dirNamesList,molIdentifier,2);
directoryName = dirNamesList{index};


filename_setting = fullfile('..','Database',directoryName,'info.txt');
molInfo = molInfoRead(filename_setting);

for jj = 1:double(molInfo.nClockData)
    filename = fullfile('..','Database',directoryName,molInfo.file{jj});
    fileID = fopen(filename,'r');
    sizeA = [5 molInfo.values(jj)];
    A = fscanf(fileID,formatSpec, sizeA);
    
    fclose(fileID);
    A=A';
    
    for t=1:molInfo.values(jj)
        M(molInfo.values(jj)-t+1,:) = A(t,:);  %the matrix rows are inverted to start from left saturation
    end
    
    CK.characteristic(jj).data(:,:,1) = M(1:molInfo.values(jj),:);   
    CK.characteristic(jj).value = molInfo.field(jj);
    CK.num = jj;
    CK.molID = molecule; 
end

end
