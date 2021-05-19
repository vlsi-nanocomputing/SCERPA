% function [CK] = Interp_coeff_bilinear(molecule)
% 
% formatSpec = '%f %f %f %f %f'; % file format for reading
% 
% % get the directory name of the molecule
% % cd Characteristics_Setting
% dirList = dir('Characteristics_Setting');
% dirNamesList = {dirList(:).name};
% molIdentifier = sprintf('%d.',molecule);
% index = strncmp(dirNamesList,molIdentifier,2);
% directoryName = dirNamesList{index};
% 
% % filename_setting = sprintf('%s/characteristics_data.xlsx',directoryName);
% % [num_data,txt_data,raw_data] = xlsread(filename_setting);
% 
% filename_setting = sprintf('Characteristics_Setting/%s/info.txt',directoryName);
% molInfo = molInfoRead(filename_setting);
% 
% for jj = 1:molInfo.nClockData
%     filename = sprintf('Characteristics_Setting/%s/%s', directoryName, molInfo.file{jj});
%     fileID = fopen(filename,'r');
%     sizeA = [5 molInfo.values(jj)];
%     A = fscanf(fileID,formatSpec, sizeA);
%     
%     fclose(fileID);
%     A=A';
%     
%     for t=1:molInfo.values(jj)
%         M(molInfo.values(jj)-t+1,:) = A(t,:);  %the matrix rows are inverted to start from left saturation
%     end
%     
%     CK.characteristic(jj).data(:,:,1) = M(1:molInfo.values(jj),:);   
%     CK.characteristic(jj).value = molInfo.field(jj);
%     CK.num = jj;
%     CK.molID = molecule; 
% end
% 
% end

function [CK] = Interp_coeff_bilinear(molecule)

formatSpec = '%f %f %f %f %f'; % file format for reading

% get the directory name of the molecule
cd Characteristics_Setting
dirList = dir;
dirNamesList = {dirList(:).name};
molIdentifier = sprintf('%d.',molecule);
index = strncmp(dirNamesList,molIdentifier,2);
directoryName = dirNamesList{index};

filename_setting = sprintf('%s/characteristics_data.xlsx',directoryName);
[~,~,raw_data] = xlsread(filename_setting);

for jj = 2:size(raw_data,1)
    filename = sprintf('%s/%s', directoryName, raw_data{jj,1});
    fileID = fopen(filename,'r');
    sizeA = [5 raw_data{jj,3}];
    A = fscanf(fileID,formatSpec, sizeA);
    
    fclose(fileID);
    A=A';
    
    for t=1:raw_data{jj,3}
        M(raw_data{jj,3}-t+1,:) = A(t,:);  %the matrix rows are inverted to start from left saturation
    end
    
    CK.characteristic(jj-1).data(:,:,1) = M(1:raw_data{jj,3},:);   
    CK.characteristic(jj-1).value = raw_data{jj,2};
    CK.num = jj-1;
    CK.molID = molecule; 
end
cd ..
end
