function molType = getMolType(QCA_circuit)
%Associate molType
if ~isfield(QCA_circuit,'molecule')
    molType = '1'; % bisfe4_ox_counterionOnThiol
else
    switch(QCA_circuit.molecule)
        case 'bisfe4_ox_counterionOnCarbazole'
            molType = '0';
        case {'bisfe4_ox_counterionOnThiol','bisfe_4'} % backward compatibility
            molType = '1';
        case {'bisfe4_ox_counterionOnThiol_orca','bisfe_4_orca'} % backward compatibility
            molType = '2';
        case 'bisfe4_ox_noCounterion'
            molType = '3';
        case 'bisfe4_ox_noCounterion_TSA_2states'
            molType = '4';
        case 'bisfe4_ox_noCounterion_TSA_3states'
            molType = '5';
        case 'bisfe4_sym'
            molType = '6';
        case {'butane_ox_noCounterion','butane'} % backward compatibility
            molType = '7';
        case 'butane_ox_noCounterion_orca'
            molType = '8';
        case 'butaneCam' % backward compatibility
            molType = '9';
        case {'decatriene_ox_noCounterion','decatriene'} % backward compatibility
            molType = '10';
        case {'linear_mol_w7_a2000','linear_w7'} % backward compatibility
            molType = '11';
        case 'linear_mol_w7_a3000'
            molType = '12';
        case {'linear_mol_w9_a3000','linear_w9'} % backward compatibility
            molType = '13';
        case {'linear_mol_w95_a3000','linear_w95'} % backward compatibility
            molType = '14';
        case 'newMol_1'
            molType = '15';
        case 'newMol_2'
            molType = '16';
        case 'newMol_3'
            molType = '17';
        case 'newMol_4'
            molType = '18';
        case 'syntCrosswireDAC'
            molType = '20';
        otherwise
            disp('[SCERPA ERROR] Unknown molecule (circuit.molecule)')
            return
    end
end

end

