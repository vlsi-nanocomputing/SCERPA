% clc;
% close all;
% clear all;

%windows
% File to read
% filename_mol = 'Data_Molecule_1.xlsx';
% filename_driv = 'Data_Driver.xlsx';
% filename_phase = 'Fake_Phases.xlsx';
% finename_values_dr =  'Values_Driver.xlsx';

% [num_mol,txt_mol,raw_mol] = xlsread(filename_mol);
% [num_dr,txt_dr,raw_dr] = xlsread(filename_driv);
% [num_phase,txt_phase,raw_phase] = xlsread(filename_phase);
% [num_values,txt_values,raw_values] = xlsread(filename_values_dr);

%crossplatform
% File to read
load(filename_mol);
load(filename_driv);
load(filename_phase);
load(filename_values_dr);

raw_mol = matrix_mol;
raw_dr= matrix_driv;
raw_phase = matrix_phase;
raw_values = Values_Dr;

%  STACK_MOLECULE CREATOR 
k = 1;
for i=1:12:size(raw_mol,1)
    f = 0;
    for l=1:4
        stack_mol.stack(k).charge(l).x = raw_mol{i+7+f, 2}; 
        stack_mol.stack(k).charge(l).y = raw_mol{i+7+f, 3};
        stack_mol.stack(k).charge(l).z = raw_mol{i+7+f, 4};
        stack_mol.stack(k).charge(l).q = raw_mol{i+7+f, 5};
        f = f + 1;
    end    
        stack_mol.stack(k).identifier = raw_mol(i, 2);
        stack_mol.stack(k).position = raw_mol(i+1, 4);
        stack_mol.num = k;
        
        k = k + 1;
end

%STACK_DRIVER CREATOR 
k = 1; 
for i=1:7:size(raw_dr,1)   
    f = 0;
    for l=1:4
        stack_driver.stack(k).charge(l).x = raw_dr{i+2+f, 2}; 
        stack_driver.stack(k).charge(l).y = raw_dr{i+2+f, 3};
        stack_driver.stack(k).charge(l).z = raw_dr{i+2+f, 4};
        stack_driver.stack(k).charge(l).q = raw_dr{i+2+f, 5};
        f = f + 1;
    end           
        stack_driver.stack(k).identifier = raw_dr(i, 2);
        stack_driver.stack(k).position = raw_mol(i+1, 5);
        stack_driver.num = k;
        k = k + 1;
end

% STACK CLOCK CREATOR
stack_clock = raw_phase;

% DRIVER VALUES
driver_values = raw_values;

disp('Loading Complete')




