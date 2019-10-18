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

%delete old simulation files
FigureDirectory = dir('FIGURE');
FigureDirectory([FigureDirectory.isdir]) = [];
oldPics = fullfile('FIGURE', {FigureDirectory.name});
try
    delete( oldPics{:} )
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
filename_out = 'Simulation_Output.log'; %09/10/2016 LP previous version, directory mismatch
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

%import layout data
if settings.magcadImporter ==0
    run('Function_Reader.m');
else
    [stack_mol,stack_driver,stack_clock,driver_values] = importQLL(...
        settingsArg.circuit.qllFile,...
        settingsArg.circuit.Values_Dr,...
        settingsArg.circuit.stack_phase);
end

[CK] = Interp_coeff_bilinear(settings.molecule);

switch  settings.solver
    case char('r')
        run('solverR.m')
    case char('y')
        run('solverY.m')
    case char('E')
        run('solverE.m')
    case char('yv2')
        run('solverYv2.m')
    case char('scfHTSA2')
        run('solverH.m')
    otherwise
        myicon = imread('good.png');
        h=msgbox('Solver has not been found!', 'SCERPA Error 101', 'custom', myicon); 
end

%%

%%%%%%%% DEBUG: IMPORTANT: this code should not create dependances on the
%%%%%%%% rest of the code, if this part is erased the computaiton should
%%%%%%%% not be affected. ALl variables should start with DEBUG_



%run('yfullEnergy.m')

% run('ConvergenceTable.m')



%%%%%%%% END DEBUG

fclose(fileID);
myicon = imread('good.png');
h=msgbox('Brave Yourself... The Operation is Completed', 'Success!!!!', 'custom', myicon);
   
%save workspace for analysis
save('simulation_output');
end

