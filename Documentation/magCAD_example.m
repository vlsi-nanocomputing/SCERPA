%%%%%
clear all

%molecule
circuit.molecule = 'bisfe_4';

%layout
file = 'diffMolTest.qll';
circuit.qllFile = sprintf('%s/%s',pwd,file);
            
circuit.clockMode = 'phase';

 %drivers and clock
 circuit.Values_Dr = {
     'Dr'     -4 -4 'end'
 };
 
 %clock phase
 circuit.stack_phase(1,:) = [+2 +2];
 circuit.stack_phase(2,:) = [-2 +2];

%SCERPA settings
settings.plot_3dfig = 1;
settings.doubleMolDriverMode = 0;
settings.fig_saver='no';
settings.plot_voltage = 0;
settings.plot_chargeFig = 0;
settings.plot_logic = 0;
settings.plot_molnum = 0;
settings.solver='E';
settings.immediateUpdate = 0;
settings.pauseStep = 0;
settings.damping = 0.6;
settings.activeRegionThreshold=0.02;
settings.verbosity = 2;
settings.conv_threshold_HP = 0.005;
settings.enableRefining = 0;
settings.enableActiveRegion = 0;
settings.plotIntermediateSteps = 0;
settings.plotActiveRegionWindow = 0;

%%%% Launch SCERPA
generation_status = SCERPA('topoLaunch', circuit, settings);
