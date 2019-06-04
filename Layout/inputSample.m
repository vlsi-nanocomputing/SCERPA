%distances
dist_z = 10;   

%molecule
molecule = 'bisfe_4';

%layout
QCA_circuit_layout = { 'Dr1' 'Dr2' '1' '1' '1' '1' ; 
                       'Dr1' 'Dr2' '1' '1' '1' '1'};     
%molecule rotation
QCA_circuit_rotation_x = { '0' '0' '0' '0' '0' '0' ; 
                           '0' '0' '0' '0' '0' '0' };    

%molecule shift on x
QCA_circuit_shift_x = { '0' '0' '0' '0' '0' '0' ; 
                           '0' '0' '0' '0' '0' '0' };                      

%molecule shift on y
QCA_circuit_shift_y = { '0' '0' '0' '0' '0' '0' ; 
                        '0' '0' '50' '0' '0' '0' };   

%molecule shift on z
QCA_circuit_shift_z = { '0' '0' '0' '0' '0' '0' ; 
                        '0' '0' '0' '0' '0' '0' };   
                    
%drivers and clock
Values_Dr = {
    'Dr1' -4.5 +4.5 'end';
    'Dr2' +4.5 -4.5 'end'};

%clock
stack_phase(1,:) = [2 2];


          

