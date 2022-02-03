function [initial_charge, dot_position, draw_association] = GetMoleculeData(molType) 
    % The function GetMoleculeData is used to get geometry information 
    % about the molecule type specified by <<molType>>. 
    % The input should be a string containing the number associated to the
    % molecule under test.
    % The function returns three informations:
    %   initial_charge -> is a matrix containing the initial charge on each
    %                     dot
    %   dot_position -> is a matrix containing the xyz coordinates for each
    %                   dot (1st row <-> 1st dot, 2nd row <-> 2nd dot, ...)
    %   draw_association -> is a matrix containing the couple of dots which
    %                       are connected
    
    switch(molType)
        case {'0','1','3','4','5','6','20'} % 'bisfe_4' -> Bisferrocene with 4 charges
            %initial_charge   = [0.475, 0.471, -0.223, 0.277];  % charge ck=+2V
            initial_charge   = [0.370, 0.352, -0.023, 0.307];  % charge ck=+0V              
            %initial_charge   = [0.027, 0.026,  0.141, 0.806];  % charge ck=-2V
            dot_position =  [ -3.622      -5.062,    -0.094;  %[dot1_x, dot1_y, dot1_z]
                              -3.588      +5.083,    -0.094;  %[dot2_x, dot2_y, dot2_z]
                              +3.133515   -0.011731, -0.755;  %[dot3_x, dot3_y, dot3_z]
                              +11.776298  -0.053777, +0.409]; %[dot4_x, dot4_y, dot4_z]
            draw_association =[1 3; 2 3; 3 4];
            
        case '2' % 'bisfe_4_orca' -> Bisferrocene with 4 charges
            initial_charge   = [0.475, 0.471, -0.223, 0.277];  % charge ck=+2V
            %initial_charge   = [0.370, 0.352, -0.023, 0.307];  % charge ck=+0V              
            %initial_charge   = [0.027, 0.026,  0.141, 0.806];  % charge ck=-2V
            dot_position =  [ -3.621776   -5.061555   -0.093920;  %[dot1_x, dot1_y, dot1_z]
                              -3.588201    5.082574   -0.093538;  %[dot2_x, dot2_y, dot2_z]
                              3.133515   -0.011731   -0.755438;  %[dot3_x, dot3_y, dot3_z]
                              11.776298   -0.053777    0.409313]; %[dot4_x, dot4_y, dot4_z]
            draw_association =[1 3; 2 3; 3 4];
            
        case '10' % 'decatriene' -> Decatriene
            initial_charge   = [-0.041 -0.025 0.574 0];  % charge ck=+0V 
            dot_position =  [ -2.8      -2.8,    0;  %[dot1_x, dot1_y, dot1_z]
                              -2.8      +2.8,    0;  %[dot2_x, dot2_y, dot2_z]
                              +0         0,      0;  %[dot3_x, dot3_y, dot3_z]
                              +0         0,      0]; %[dot4_x, dot4_y, dot4_z]
            draw_association =[1 3; 2 3];
            
        case {'7','8'} % 'butane' -> Butane
            initial_charge   = [0.526 0.509 -0.036 0];  % charge ck=+0V 
            dot_position =  [ -5      -3.5,    0;  %[dot1_x, dot1_y, dot1_z]
                              -5      +3.5,    0;  %[dot2_x, dot2_y, dot2_z]
                              -5         0,    0;  %[dot3_x, dot3_y, dot3_z]
                              -5         0,    0]; %[dot4_x, dot4_y, dot4_z]
            draw_association =[1 2];
            
        case '9' % 'butaneCam' -> Butane
            initial_charge   = [0.296967000000000   0.703032000000000 0 0];  % charge ck=+0V 
            dot_position = [ 0.000098442895707  -3.167642443146320  -0.138914848936393
                            -0.000106442860152   3.167642445754046   0.138913848655400
                             0                   0                   0
                             0                   0                   0];            
            draw_association =[1 2];
            
        case {'11','12'} % 'linear_w7' -> Butane
            initial_charge   = [0.5 0.5 0 0];  % charge ck=+0V 
            dot_position =  [ -5,      -3.5,    0;
                              -5,      +3.5,    0;
                               0,       0,      0;
                               1,       0,      0];                     
            draw_association =[1 2];
            
        case '13' % 'linear_w9' -> Butane
            initial_charge   = [0.5 0.5 0 0];  % charge ck=+0V 
            dot_position =  [  -5,      -4.5,    0;
                               -5,      +4.5,    0;
                                0,       0,      0;
                                1,       0,      0];                    
            draw_association =[1 2];
            
        case '14' % 'linear_w95' -> Butane
            initial_charge   = [0.5 0.5 0 0];  % charge ck=+0V 
            dot_position =  [ -5,      -4.25,    0;
                              -5,      +4.25,    0;
                               0,       0,       0;
                               1,       0,       0];                     
            draw_association =[1 2];
        
        case {'15'} % Neutra -> paper neutre
            initial_charge   = [0, 0, 0,  0];  % charge ck=+2V              
            dot_position =  [ -5      -5           0;  %[dot1_x, dot1_y, dot1_z]
                              -5      +5           0;  %[dot2_x, dot2_y, dot2_z]
                              0         0           0;  %[dot3_x, dot3_y, dot3_z]
                              +10       0           0]; %[dot4_x, dot4_y, dot4_z]
            draw_association =[1 3; 2 3];
            
        case '16' % Ossidata -> paper neutre
            initial_charge   = [0.5, 0.5, 0, 0];  % charge ck=+2V              
            dot_position =  [ -5      -5           0;  %[dot1_x, dot1_y, dot1_z]
                              -5      +5           0;  %[dot2_x, dot2_y, dot2_z]
                              0         0           0;  %[dot3_x, dot3_y, dot3_z]
                              +10       0           0];  %[dot4_x, dot4_y, dot4_z]
            draw_association =[1 3; 2 3];
        
        case '17' % Zwitter -> paper neutre
            initial_charge   = [0.5, 0.5, -1, 0];  % charge ck=+2V              
            dot_position =  [ -5      -5           0;  %[dot1_x, dot1_y, dot1_z]
                              -5      +5           0;  %[dot2_x, dot2_y, dot2_z]
<<<<<<< HEAD
                              0      0           0;  %[dot3_x, dot3_y, dot3_z]
                              +10       0           0]; %[dot4_x, dot4_y, dot4_z]
=======
                              +10        0           0;  %[dot3_x, dot3_y, dot3_z]
                              0      0           0]; %[dot4_x, dot4_y, dot4_z]
>>>>>>> fae5c81b8661739025820afa2db8bdd9e38de560
            draw_association =[1 3; 2 3];
        case '18' % oxidized counterion -> paper neutre
            initial_charge   = [0.5, 0.5, 0, -1];  % charge ck=+2V              
            dot_position =  [ -5      -5           0;  %[dot1_x, dot1_y, dot1_z]
                              -5      +5           0;  %[dot2_x, dot2_y, dot2_z]
                              0      0           0;  %[dot3_x, dot3_y, dot3_z]
                              +10       0           0]; %[dot4_x, dot4_y, dot4_z]
            
%             dot_position =  [ -5      -5           0;  %[dot1_x, dot1_y, dot1_z]
%                               -5      +5           0;  %[dot2_x, dot2_y, dot2_z]
%                               0         0           0;  %[dot3_x, dot3_y, dot3_z]
%                               +1       0           0];  %[dot4_x, dot4_y, dot4_z]
            draw_association =[1 3; 2 3];
             
    end
    
end