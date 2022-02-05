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
function Function_Saver(flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver)
    %Log file updater
   
    %time header
    fprintf(fileID,'\n%% TIME %i\n', ii);
    
    %driver info
    fprintf(fileID,'\n% Drivers Setting for time %i\n', ii);
    fprintf(fileID,'%% DOT1   -   DOT2   -   DOT3   -   DOT4\n');
    fprintf(fileID,'driver(:,:,%i) = [',ii);
    for kk=1:stack_driver.num
        fprintf(fileID,'%+i   %+i   %+i   %+i\n', stack_driver.stack(kk).charge(1).q, ...
        stack_driver.stack(kk).charge(2).q, stack_driver.stack(kk).charge(3).q, stack_driver.stack(kk).charge(4).q);
    end
    fprintf(fileID,'];\n\n');
    
    %molecule info
    fprintf(fileID,'%% MOL   -   VOUT   -   DOT1   -   DOT2   -   DOT3   -   DOT4\n');
    fprintf(fileID,'conf(:,:,%i) = [',ii);
    for kk=1:stack_mol.num
        fprintf(fileID,' %i      %+1.5f   %+1.5f   %+1.5f  %+1.5f   %+1.5f\n', kk, Vout(kk),...
        Charge_on_wire_done(kk,2), Charge_on_wire_done(kk,3), Charge_on_wire_done(kk,4), Charge_on_wire_done(kk,5));
    end
    fprintf(fileID,'];\n');
      
        
    

end

