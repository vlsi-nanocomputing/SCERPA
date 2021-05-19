function ScerpaRun(settingsArg)
%============================================================================================================================================%
%/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\%
%\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/%
%============================================================================================================================================%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   INITIALIZATION   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
filename_sim = '../Layout/Database/Simulation_filename.txt';
fileID = fopen(filename_sim,'r');
formatSpec = '%s';
simulation_file_name = fscanf(fileID,formatSpec);
fclose(fileID);

% Files to read cross-platform (mat data)
filename_mol = '../Layout/Database/Data_Molecule.mat';
filename_driv = '../Layout/Database/Data_Driver.mat';
filename_out = '../Layout/Database/Data_Output.mat';
filename_phase = '../Layout/Database/Fake_Phases.mat';
filename_values_dr =  '../Layout/Database/Values_Driver.mat';

% Output Files
Sim_Output_file = '../OUTPUT_FILES/Simulation_Output.log';
fileID = fopen(Sim_Output_file,'wt');
fprintf(fileID,'%%%% Files Analysed:\n');
fprintf(fileID,'%%%%    %s\n', filename_mol);
fprintf(fileID,'%%%%    %s\n', filename_driv);
fprintf(fileID,'%%%%    %s\n', filename_out);
fprintf(fileID,'%%%%    %s\n', filename_phase);
fprintf(fileID,'%%%%    %s\n', filename_values_dr);


fprintf(fileID,'\n\n%%%%    Configuration of data output: \n');
fprintf(fileID,'%%%%    ID - Vin - Q1 ... QN: \n');


%disable MATLAB optimization
if settings.enableJit == 0
    feature jit off
end

%import layout data (output are imported from QLL, not yet used in the
%algorithm, though, available for viewer)
disp('Importing Layout...')
run('Function_Reader.m');


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

%create distance matrix
disp('Creating distance matrix...')
DIST_MATRIX = createDistanceMatrix(stack_mol);

%Create Additional_Information.txt
fileTable = Function_SaveTable(1,settings,stack_mol,stack_driver,stack_output);

% Run Scerpa solver E
run('solverE.m') 


%%

%%%%%%%% DEBUG: IMPORTANT: this code should not create dependances on the
%%%%%%%% rest of the code, if this part is erased the computaiton should
%%%%%%%% not be affected. ALl variables should start with DEBUG_


%run('yfullEnergy.m')

% run('ConvergenceTable.m')



%%%%%%%% END DEBUG

fclose(fileID);
fclose(fileTable);

% for MATLAB versions following 2019a
%writematrix(output_txt,'Additional_Information.txt','Delimiter','tab')

% for all MATLAB versions




%%
% myicon = imread('good.png');
% h=msgbox('Brave Yourself... The Operation is Completed', 'Success!!!!', 'custom', myicon);
disp(' ');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('%  Brave Yourself... The Operation is Completed %');
disp('%                  SCERPA                       %');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');

%save workspace for analysis
save('../OUTPUT_FILES/simulation_output');
end

