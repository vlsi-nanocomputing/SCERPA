function molCitation(molList)

disp(' ')
disp('############################################################################')
disp('RELATED WORKS FOR THE USED MOLECULE(S)')
disp(' ')

if length(molList) > 1
    disp('More than one molecule used')
    disp('  + Beretta G., Ardesi Y., Graziano M., and Piccinini G., "Multi-Molecule Field-Coupled Nanocomputing for the Implementation of a Neuron," in IEEE Transactions on Nanotechnology, vol. 21, pp. 52-59, 2022, doi: 10.1109/TNANO.2022.3143720')
end
           
for ii = 1:length(molList)

    switch molList(ii)
        case 1
            disp('1.bisfe4_ox_counterionOnThiol')
            disp('  + Arima V., et al. "Toward quantum-dot cellular automata units: thiolated-carbazole linked bisferrocenes." Nanoscale 4.3 (2012): 813-823')
        case 3
            disp('3.bisfe4_ox_noCounterion')
            disp('  + Arima V., et al. "Toward quantum-dot cellular automata units: thiolated-carbazole linked bisferrocenes." Nanoscale 4.3 (2012): 813-823')
            disp('  + Ardesi Y., Pulimeno A., Graziano M., Riente F., and Piccinini G., "Effectiveness of Molecules for Quantum Cellular Automata as Computing Devices." J. Low Power Electron. Appl. 2018, 8, 24. https://doi.org/10.3390/jlpea8030024')
        case 7
            disp('7.butane_ox_noCounterion')
            disp('  + Craig S. L., Isaksen B., and Lieberman M., "Molecular quantum-dot cellular automata." Journal of the American Chemical Society 125.4 (2003): 1056-1063')
            disp('  + Ardesi Y., Pulimeno A., Graziano M., Riente F., and Piccinini G., "Effectiveness of Molecules for Quantum Cellular Automata as Computing Devices." J. Low Power Electron. Appl. 2018, 8, 24. https://doi.org/10.3390/jlpea8030024')
        case 9
            disp('9.butaneCam')
            disp('  + ENERGIA')
        case 10
            disp('10.decatriene_ox_noCounterion')
            disp('  + Ardesi Y., Pulimeno A., Graziano M., Riente F., and Piccinini G., "Effectiveness of Molecules for Quantum Cellular Automata as Computing Devices." J. Low Power Electron. Appl. 2018, 8, 24. https://doi.org/10.3390/jlpea8030024')
        case 15
            disp('15.ideal_neutral')
            disp('  + Ardesi Y., Beretta G., Vacca M., Piccinini G., and Graziano M., "Impact of Molecular Electrostatics on Field-Coupled Nanocomputing and Quantum-Dot Cellular Automata Circuits." Electronics 2022, 11, 276. https://doi.org/10.3390/electronics11020276')
        case 16
            disp('16.ideal_oxidized')
            disp('  + Ardesi Y., Beretta G., Vacca M., Piccinini G., and Graziano M., "Impact of Molecular Electrostatics on Field-Coupled Nanocomputing and Quantum-Dot Cellular Automata Circuits." Electronics 2022, 11, 276. https://doi.org/10.3390/electronics11020276')
        case 17
            disp('17.ideal_zwitterionic')
            disp('  + Ardesi Y., Beretta G., Vacca M., Piccinini G., and Graziano M., "Impact of Molecular Electrostatics on Field-Coupled Nanocomputing and Quantum-Dot Cellular Automata Circuits." Electronics 2022, 11, 276. https://doi.org/10.3390/electronics11020276')
        case 20
            disp('20.syntCrosswireDAC')
            disp('  + JETC')
    end
end

disp('############################################################################')
disp(' ')
end