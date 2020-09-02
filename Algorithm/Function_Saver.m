function Function_Saver(flag, ii, fileID, Vout, Charge_on_wire_done, stack_mol, stack_driver)
    
        fprintf(fileID,'\n%% TIME %i\n', ii);
        fprintf(fileID,'\n% Drivers Setting for time %i\n', ii);
        fprintf(fileID,'%% DOT1   -   DOT2   -   DOT3   -   DOT4\n');
        fprintf(fileID,'driver(:,:,%i) = [',ii);
        for kk=1:stack_driver.num
            fprintf(fileID,'%+i   %+i   %+i   %+i\n', stack_driver.stack(kk).charge(1).q, ...
            stack_driver.stack(kk).charge(2).q, stack_driver.stack(kk).charge(3).q, stack_driver.stack(kk).charge(4).q);
        end
        fprintf(fileID,'];\n\n');

        fprintf(fileID,'%% MOL   -   VOUT   -   DOT1   -   DOT2   -   DOT3   -   DOT4\n');
        fprintf(fileID,'conf(:,:,%i) = [',ii);
        for kk=1:stack_mol.num
            fprintf(fileID,' %i      %+1.5f   %+1.5f   %+1.5f  %+1.5f   %+1.5f\n', kk, Vout(kk),...
            Charge_on_wire_done(kk,2), Charge_on_wire_done(kk,3), Charge_on_wire_done(kk,4), Charge_on_wire_done(kk,5));
        end
        fprintf(fileID,'];\n');
%         filename_1 = [sprintf('\OUTPUT_FILES\Active_dots\dot_1_%i.txt', ii)];
%         filename_2 = [sprintf('\OUTPUT_FILES\Active_dots\dot_2_%i.txt', ii)];
%         fileID_1 = fopen(filename_1,'wt');
%         fileID_2 = fopen(filename_2,'wt');
%         for kk=1:stack_mol.num
%             fprintf(fileID_1,'%i %+1.5f\n', kk, Charge_on_wire_done(kk,2));
%             fprintf(fileID_2,'%i %+1.5f\n', kk, Charge_on_wire_done(kk,3));
%         end
%         fclose(fileID_1);
%         fclose(fileID_2);

        
        
    

end

