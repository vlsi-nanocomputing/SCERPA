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
function [ output_args ] = PlotElectrode( starting_point, electrode_width, electrode_height, test_lenght, color )



X(1,:) = [starting_point(1)                     starting_point(1)+test_lenght            starting_point(1)+test_lenght                       starting_point(1)];
Y(1,:) = [starting_point(2)                     starting_point(2)                        starting_point(2)+electrode_width                   starting_point(2)+electrode_width];
Z(1,:) = [starting_point(3)                     starting_point(3)                        starting_point(3)                                   starting_point(3)];

X(2,:) = [starting_point(1)                     starting_point(1)+test_lenght            starting_point(1)+test_lenght                       starting_point(1)];
Y(2,:) = [starting_point(2)                     starting_point(2)                        starting_point(2)+electrode_width                   starting_point(2)+electrode_width];
Z(2,:) = [starting_point(3)+electrode_height    starting_point(3)+electrode_height       starting_point(3)+electrode_height                  starting_point(3)+electrode_height];

X(3,:) = [starting_point(1)                     starting_point(1)+test_lenght            starting_point(1)+test_lenght                       starting_point(1)];
Y(3,:) = [starting_point(2)                     starting_point(2)                        starting_point(2)                                   starting_point(2)];
Z(3,:) = [starting_point(3)                     starting_point(3)                        starting_point(3)+electrode_height                  starting_point(3)+electrode_height];

X(4,:) = [starting_point(1)                     starting_point(1)+test_lenght            starting_point(1)+test_lenght                        starting_point(1)];
Y(4,:) = [starting_point(2)+electrode_width     starting_point(2)+electrode_width        starting_point(2)+electrode_width                    starting_point(2)+electrode_width];
Z(4,:) = [starting_point(3)                     starting_point(3)                        starting_point(3)+electrode_height                   starting_point(3)+electrode_height];

X(5,:) = [starting_point(1)                     starting_point(1)                        starting_point(1)                                    starting_point(1)];
Y(5,:) = [starting_point(2)                     starting_point(2)                        starting_point(2)+electrode_width                    starting_point(2)+electrode_width];
Z(5,:) = [starting_point(3)                     starting_point(3)+electrode_height       starting_point(3)+electrode_height                   starting_point(3)];

X(6,:) = [starting_point(1)+test_lenght         starting_point(1)+test_lenght            starting_point(1)+test_lenght                        starting_point(1)+test_lenght];
Y(6,:) = [starting_point(2)                     starting_point(2)                        starting_point(2)+electrode_width                    starting_point(2)+electrode_width];
Z(6,:) = [starting_point(3)                     starting_point(3)+electrode_height       starting_point(3)+electrode_height                   starting_point(3)];

C = [0.5000 2.0000 1.0000 0.5000];

C= [color color color color];
%figure
for i=1:6
fill3(X(i,:),Y(i,:),Z(i,:),C)
axis('equal');
hold on
end


output_args='true';
end

