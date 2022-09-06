function molCitation(molList)

% get the directory name of the molecule
dirList = dir(fullfile('..','Database'));
dirNamesList = {dirList(:).name};
for ii = 1:length(molList)
    molIdentifier = sprintf('%d.',molList(ii));
    index = strncmp(dirNamesList,molIdentifier,2);
    directoryName = dirNamesList{index};
    filename = fullfile('..','Database',directoryName,'cite.txt');
    if isfile(filename)
        in_str=fileread(filename); % string to analyze
        disp(in_str)
    else
        fprintf('No citation file for molecule %s\n', molIdentifier)
    end
   
end

end