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
function ScerpaRun(settingsArg)

disp('Loading SCERPA')
if ~exist('settingsArg','var')
    settingsArg=0;
end

%Import SCERPA settings
settings = importSettings(settingsArg);

%delete old simulation files
filesDirectory = dir(settings.out_path);
filesDirectory([filesDirectory.isdir]) = [];
oldSims = fullfile(settings.out_path, {filesDirectory.name});
try
    delete( oldSims{:} )
catch
    disp('No previous simulation found')
end

%get simulation file name
layout_data_location = fullfile('..','Layout','Data');
filename_sim = fullfile(layout_data_location,'Simulation_filename.txt');
fileID = fopen(filename_sim,'r');
formatSpec = '%s';
simulation_file_name = fscanf(fileID,formatSpec);
fclose(fileID);

% Files to read cross-platform (mat data)
filename_mol = fullfile(layout_data_location,'Data_Molecule.mat');
filename_driv = fullfile(layout_data_location,'Data_Driver.mat');
filename_out = fullfile(layout_data_location,'Data_Output.mat');
filename_phase = fullfile(layout_data_location,'Fake_Phases.mat');
filename_values_dr =  fullfile(layout_data_location,'Values_Driver.mat');

%disable MATLAB optimization
if settings.enableJit == 0
    feature jit off
end

%import layout data (output are imported from QLL, not yet used in the
%algorithm, though, available for viewer)
disp('Importing Layout...')
[stack_mol,stack_driver,stack_output,stack_clock,driver_values] = Function_Reader(filename_mol,filename_driv,filename_out,filename_phase,filename_values_dr);

%Import molecule library data
disp('Importing Libraries...')

% create a list containing all the molecule type involved in the circuit
molTypeList = unique([[stack_mol.stack(:).molType]  [stack_driver.stack(:).molType]]);

for i = 1:length(molTypeList)
    transchar = Interp_coeff_bilinear(molTypeList(i)); %transchar
    
    %reshape transcharacteristics to avoid true interpolation
    CK.stack(molTypeList(i)+1) = reshapeTC(transchar); % put transchar in fixed position corresponding to molType number (+1 to start from 1 instead of 0)
end
CK.length = length(molTypeList);

disp('Loading Complete')

%create distance matrix
disp('Creating distance matrix...')
DIST_MATRIX = createDistanceMatrix(stack_mol);

%Create Additional_Information.txt
fileTable = Function_SaveTable(1,settings,stack_mol,stack_driver,stack_output);

% Run Scerpa solver E
run('solverE.m') 


fprintf('Total computation Time: %f s\n\n ',sum(timeComputation))

%%%%%%%% DEBUG: IMPORTANT: this code should not create dependances on the
%%%%%%%% rest of the code, if this part is erased the computaiton should
%%%%%%%% not be affected. ALl variables should start with DEBUG_



%%%%%%%% END DEBUG
fclose(fileTable);



%%
disp(' ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('%  Brave Yourself... The Operation is Completed %');
disp('%                  SCERPA                       %');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');

%save workspace for analysis
save(fullfile(settings.out_path,'simulation_output'));
end

