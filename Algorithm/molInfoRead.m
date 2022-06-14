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
function molInfo = molInfoRead(filename)

in_str=fileread(filename); % convert QLL into a string

% read num of charges from database file
xpr = ['CLOCKDATA\s*([0-9]+)'];
nClockData_cell = regexp(in_str, xpr, 'tokens');
nClockData = str2double(cell2mat(nClockData_cell{1,1}));
molInfo.nClockData = nClockData;

abq = '([^"]+)';    % anything but quotation mark and space

for ii=1:nClockData
    xpr = sprintf('<%d>\\s*%s.txt\\s*%s\\s*V\\s*%s\\s*values\\s*</%d>',ii,abq,abq,abq,ii);
    clockInfo = regexp(in_str, xpr, 'tokens');
    scannedData = clockInfo{:};
%     obtain data
    molInfo.file{ii} = [char(scannedData{1}) '.txt'];
    molInfo.field(ii) = str2num(char(scannedData{2}));
    molInfo.values(ii) = str2num(char(scannedData{3}));
end
   

% %open file
% fileId = fopen(filename);
% 
% %loop on lines
% tline = fgetl(fileId);
% 
% while ischar(tline)
% 
%     % find clockdata section
%     if (regexp(tline, 'CLOCKDATA [0-9]+') == 1) 
%         
%         %get number of clockDataFile
%         scannedData = textscan(tline,'CLOCKDATA %d');
%         molInfo.nClockData = scannedData{1};
%         
%         for ii=1:molInfo.nClockData
%             
%             %get line
%             tline = fgetl(fileId);
%             
%             %scan line
%             scannedData = textscan(tline,'%s %f V %d values');
%             
%             %obtain data
%             molInfo.file{ii} = char(scannedData{1});
%             molInfo.field(ii) = scannedData{2};
%             molInfo.values(ii) = scannedData{3};
%             
%         end
%         
%     end
%   
%     %get new line
%     tline = fgetl(fileId);   
%     
% end
% 
% %close file
% fclose(fileId);




