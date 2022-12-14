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
function [stack_mol,stack_driver,stack_output,stack_clock,driver_values] = Function_Reader(filename_mol,filename_driv,filename_out,filename_phase,filename_values_dr)

% File to read
load(filename_mol);
load(filename_driv);
load(filename_out);
load(filename_phase);
load(filename_values_dr);

raw_mol = matrix_mol;
raw_dr = matrix_driv;
raw_out = matrix_out;
raw_phase = stack_clock;
raw_values = Values_Dr;

%  STACK_MOLECULE CREATOR 
k = 1;
for i=1:9:size(raw_mol,1)
    f = 0;
    for l=1:4
        stack_mol.stack(k).charge(l).x = raw_mol{i+4+f, 2}; 
        stack_mol.stack(k).charge(l).y = raw_mol{i+4+f, 3};
        stack_mol.stack(k).charge(l).z = raw_mol{i+4+f, 4};
        stack_mol.stack(k).charge(l).q = raw_mol{i+4+f, 5};
        f = f + 1;
    end    
        stack_mol.stack(k).identifier = char(raw_mol(i, 2));
        stack_mol.stack(k).position = char(raw_mol(i, 5));
        stack_mol.stack(k).molType = cell2mat(raw_mol(i+1,5));
        stack_mol.stack(k).Vext = cell2mat(raw_mol(i+2,2));
        stack_mol.stack(k).identifier_qll = char(raw_mol(i+2,5));
        stack_mol.stack(k).phase = cell2mat(raw_mol(i+1,2));
        stack_mol.num = k;
        k = k + 1;
end

%STACK_DRIVER CREATOR 
k = 1; 
for i=1:8:size(raw_dr,1)   
    f = 0;
    for l=1:4
        stack_driver.stack(k).charge(l).x = raw_dr{i+3+f, 2}; 
        stack_driver.stack(k).charge(l).y = raw_dr{i+3+f, 3};
        stack_driver.stack(k).charge(l).z = raw_dr{i+3+f, 4};
        stack_driver.stack(k).charge(l).q = raw_dr{i+3+f, 5};
        f = f + 1;
    end           
        stack_driver.stack(k).identifier = char(raw_dr(i, 2));
        stack_driver.stack(k).position = char(raw_dr(i, 5));
        stack_driver.stack(k).molType = cell2mat(raw_dr(i+1, 2));
        stack_driver.stack(k).identifier_qll = char(raw_dr(i+1,5)); 
        stack_driver.num = k;
        k = k + 1;
end

%STACK_OUTPUT CREATOR 
k = 1; 
if isempty(raw_out)
    stack_output.num = 0;
else
    for i=1:8:size(raw_out,1)   
        f = 0;
        for l=1:4
            stack_output.stack(k).charge(l).x = raw_out{i+3+f, 2}; 
            stack_output.stack(k).charge(l).y = raw_out{i+3+f, 3};
            stack_output.stack(k).charge(l).z = raw_out{i+3+f, 4};
            stack_output.stack(k).charge(l).q = 0;
            f = f + 1;
        end           
            stack_output.stack(k).identifier = char(raw_out(i, 2));
            stack_output.stack(k).position = char(raw_out(i, 4));
            stack_output.stack(k).molType = cell2mat(raw_out(i+1, 2));
            stack_output.stack(k).identifier_qll = char(raw_out(i+1,4)); 
            stack_output.num = k;
            k = k + 1;
    end
end

% STACK CLOCK CREATOR
stack_clock = raw_phase;

% DRIVER VALUES
driver_values = raw_values;

end


