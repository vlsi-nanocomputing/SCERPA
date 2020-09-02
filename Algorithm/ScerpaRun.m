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

%prepare matlab
close all;
% clearvars -except n_tests testIndex elapsedTime;
clc; 
% feature jit off

%delete old simulation pictures
FigureDirectory = dir('FIGURE');
FigureDirectory([FigureDirectory.isdir]) = [];
oldPics = fullfile('FIGURE', {FigureDirectory.name});
try
    delete( oldPics{:} )
catch
    disp('No previous simulation found')
end

%delete old simulation files
filesDirectory = dir('OUTPUT_FILES');
filesDirectory([filesDirectory.isdir]) = [];
oldSims = fullfile('OUTPUT_FILES', {filesDirectory.name});
try
    delete( oldSims{:} )
catch
    disp('No previous simulation found')
end

% Import cicuit Layout
% % Files to read Windows (xlsx data)
% filename_mol = '..\Layout\Database\Data_Molecule_1.xlsx';
% filename_driv = '..\Layout\Database\Data_Driver.xlsx';
% filename_phase = '..\Layout\Database\Fake_Phases.xlsx';
% filename_values_dr =  '..\Layout\Database\Values_Driver.xlsx';

% Files to read cross-platform (mat data)
filename_mol = '../Layout/Database/Data_Molecule_1.mat';
filename_driv = '../Layout/Database/Data_Driver.mat';
filename_phase = '../Layout/Database/Fake_Phases.mat';
filename_values_dr =  '../Layout/Database/Values_Driver.mat';

% Output Files
%filename_out = '\OUTPUT_FILES\Simulation_Output.txt'; %09/10/2016 LP previous version, directory mismatch
filename_out = 'OUTPUT_FILES/Simulation_Output.log'; %09/10/2016 LP previous version, directory mismatch
fileID = fopen(filename_out,'wt');
fprintf(fileID,'%%%% Files Analysed:\n');
fprintf(fileID,'%%%%    %s\n', filename_mol);
fprintf(fileID,'%%%%    %s\n', filename_driv);
fprintf(fileID,'%%%%    %s\n', filename_phase);
fprintf(fileID,'%%%%    %s\n', filename_values_dr);


fprintf(fileID,'\n\n%%%%    Configuration of data output: \n');
fprintf(fileID,'%%%%    ID - Vin - Q1 ... QN: \n');

%Import SCERPA settings
settings = importSettings(settingsArg);

%disable MATLAB optimization
if settings.enableJit == 0
    feature jit off
end

%import layout data (output are imported from QLL, not yet used in the
%algorithm, though, available for viewer)

disp('Importing Layout...')
if settings.magcadImporter ==0
    run('Function_Reader.m');
    stack_output.num = 0; %no output
else
    [stack_mol,stack_driver,driver_values, stack_output] = importQLL(...
        settingsArg.circuit.qllFile,...
        settingsArg.circuit.Values_Dr,...
        settings);
    
    %clock management (Atm compatible only with QLL version, as it needs
    %the phase defined in stack_mol)
    if ~isfield(settingsArg.circuit,'clockMode')
        settingsArg.circuit.clockMode = 'phase';
    end
    
    stack_clock = createClockTable(stack_mol,settingsArg.circuit);
end
           
%roughness management
if isfield(settingsArg.circuit,'substrate')
    if isfield(settingsArg.circuit.substrate,'PVenable')
        if settingsArg.circuit.substrate.PVenable ==1
            [stack_mol,stack_driver] = applyRoughness(stack_mol,stack_driver,settingsArg);
        end    
    end
end


%Import molecule library data
disp('Importing Libraries...')

% create a list containing all the molecule type involved in the circuit
molTypeList = unique([cell2mat([stack_mol.stack(:).molType])  cell2mat([stack_driver.stack(:).molType])]);

for i = 1:length(molTypeList)
    transchar = Interp_coeff_bilinear(molTypeList(i)); %transchar
    
    %reshape transcharacteristics to avoid true interpolation
    CK.stack(i) = reshapeTC(transchar);
end
CK.length = length(molTypeList);

%create distance matrix
disp('Creating distance matrix...')
DIST_MATRIX = createDistanceMatrix(stack_mol);


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

% for MATLAB versions following 2019a
%writematrix(output_txt,'Additional_Information.txt','Delimiter','tab')

% for all MATLAB versions
formatSpec = '';
for ii = 1:2*stack_mol.num
   formatSpec = strcat(formatSpec, '\t%f');
end
formatSpec = strcat(formatSpec, '\n');
filename_out = './OUTPUT_FILES/Additional_Information.txt'; 
fileID = fopen(filename_out,'wt');
for jj = 1:n_times
    fprintf(fileID,formatSpec,output_txt(jj,:));
end
fclose(fileID);

myicon = imread('good.png');
h=msgbox('Brave Yourself... The Operation is Completed', 'Success!!!!', 'custom', myicon);
   
%save workspace for analysis
save('simulation_output');
end

