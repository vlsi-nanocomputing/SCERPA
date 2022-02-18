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
function [driver_stack, mol_stack, out_stack] = GenerateStacks(QCA_circuit)
    % The function GenerateStacks analyses each position in the layout
    % matrix and, according to the element type in the position under test,
    % selects the correct function to create the <<driver_stack>> and the
    % <<mol_stack>>. The input is the circuit provided in the input file by
    % the user.
    
    % determine size of layout
    [row, column] = size(QCA_circuit.structure);
    
    % initialization
    mol_stack.num = 0;
    driver_stack.num = 0;
    out_stack.num = 0;

    %=====================Mol list=========================
    for i=1:row
        for l=1:column
            if (strncmp(QCA_circuit.structure(i,l),'Dr',2)) % if there is a driver
                [nCharges,dot_position, draw_association] = GetMoleculeData(QCA_circuit.components{i,l});
                [driver_stack] = GenerateDriverStack(QCA_circuit, i, l, driver_stack, dot_position, draw_association,nCharges);
            elseif (strncmp(QCA_circuit.structure(i,l),'out',3)) % if there is an output
                [nCharges,dot_position, draw_association] = GetMoleculeData(QCA_circuit.components{i,l});
                [out_stack] = GenerateOutputStack(QCA_circuit, i, l, out_stack, dot_position, draw_association,nCharges);
            elseif QCA_circuit.structure{i,l}~=0 % if there is a molecule
                [nCharges,dot_position, draw_association] = GetMoleculeData(QCA_circuit.components{i,l});
                [mol_stack] = GenerateMolStack(QCA_circuit, i, l, mol_stack, dot_position, draw_association,nCharges);
            end
        end
    end
end