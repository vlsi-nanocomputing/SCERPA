function Function_SaveQSS(time, stack_mol, stack_driver)
    
header = [  '# Begin: Header\n',...
            '## this is a comment\n',...
            '## The files should be named like: 000001.qss, 000002.qss....\n',...
            '# Title: %s\n',...
            '#\n',...
            '# Desc: Optional description line.\n',...
            '# Desc: Total simulation time:  %d  s\n',...
            '# valuedim: %d    ## Value dimension: number of values per element\n',...
            '#\n',...
            '## Fundamental field value units, treated as labels (i.e., unparsed).\n',...
            '## In general, there should be one label for each value dimension.\n',...
            '# valueunits: a.u. a.u. a.u. a.u.\n',...
            '# valuelabels: "Q1 Aggregated Charge"  "Q2 Aggregated Charge" "Q3 Aggregated Charge" "Q4 Aggregated Charge"\n',...
            '#\n',...
            '# End: Header\n',...
            '#\n',...
            '## Each data records consists of N+1 values: the ID of the node,\n',...
            '## followed by the N value components.  In this example,\n',...
            '## N+1 = 4, the two value components are in units of a.u.,\n',...
            '## corresponding to the four aggregated charges.\n',...
            '#\n',...
            '# Begin: data text\n'];
        
        %variables of the header
        circuit_name = 'SCERPA simulation';
        total_time = length(time);
        valuedim = 4;
        
        %file management
        fileName = sprintf('OUTPUT_FILES/%.4d.qss',time);
        fileID = fopen(fileName,'wt');
        
        %insert header into qss file
        fprintf(fileID,header,circuit_name,total_time,valuedim);
        
        %insert drivers
        for kk=1:stack_driver.num
            fprintf(fileID,'%s   %.4f   %.4f   %.4f  %.4f\n',...
                char(stack_driver.stack(kk).identifier_qll),...
                stack_driver.stack(kk).charge(1).q,...
                stack_driver.stack(kk).charge(2).q,... 
                stack_driver.stack(kk).charge(3).q,... 
                stack_driver.stack(kk).charge(4).q);
        end
        
        %insert molecules
        for kk=1:stack_mol.num
            fprintf(fileID,'%s   %.4f   %.4f   %.4f  %.4f\n',...
                char(stack_mol.stack(kk).identifier_qll),...
                stack_mol.stack(kk).charge(1).q,...
                stack_mol.stack(kk).charge(2).q,... 
                stack_mol.stack(kk).charge(3).q,... 
                stack_mol.stack(kk).charge(4).q);
        end


        %insert final section
        fprintf(fileID,'# End: data text\n\n');
        
        %close file
        fclose(fileID);     
    

end

