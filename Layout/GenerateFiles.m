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

% This function is used to generate the instruction set (at this moment is not necessary for generic purpose) and stack structures.

%%driver_stack & mol_stack
function [driver_stack, mol_stack]=GenerateFiles(QCA_circuit, dot_position, initial_charge)

    row = size(QCA_circuit.structure, 1);
    column = size(QCA_circuit.structure, 2);
    mol_stack.num = 0;
    driver_stack.num = 0;

    %%=====================Mol list=========================
    for i=1:row
        for l=1:column
            if (strncmp(QCA_circuit.structure(i,l),'Dr',2))
                [driver_stack] = GenerateDriverStack(QCA_circuit.dist_z, QCA_circuit.dist_y, i, l, driver_stack, dot_position, QCA_circuit.structure(i,l), QCA_circuit.rotation{i,l}, QCA_circuit.shift_x{i,l}, QCA_circuit.shift_y{i,l}, QCA_circuit.shift_z{i,l});
            elseif QCA_circuit.structure{i,l}~0 && ~(strncmp(QCA_circuit.structure(i,l),'Dr',2));
                [mol_stack] = GenerateMolStack(QCA_circuit.dist_z, QCA_circuit.dist_y, i, l, mol_stack, dot_position, QCA_circuit.structure{i,l}, QCA_circuit.rotation{i,l},QCA_circuit.shift_x{i,l},QCA_circuit.shift_y{i,l},QCA_circuit.shift_z{i,l}, initial_charge);
            end
        end
    end
end