function fileTable = Function_SaveTable(constructMode,settings,stack_mol,stack_driver,stack_output,fileTable, time, Vout, driver_values,compTime)  

if constructMode ==1
    %create file
    fileTable = fopen('../OUTPUT_FILES/Additional_Information.txt','wt');
    fprintf(fileTable,'Time');
    
    %dump clock
    if settings.dumpClock == 1
        for ii=1:stack_mol.num
            fprintf(fileTable," CK_%s",stack_mol.stack(ii).identifier_qll);
        end
    end

    %dump vout
    if settings.dumpVout == 1
        for ii=1:stack_mol.num
            fprintf(fileTable," Vout_%s",stack_mol.stack(ii).identifier_qll);
        end
    end
    
    %dump input
    if settings.dumpDriver == 1
        for ii=1:stack_driver.num
            fprintf(fileTable," driver_%s",char(stack_driver.stack(ii).identifier_qll));
        end
    end
    
     %dump output
    if settings.dumpOutput == 1
        for ii=1:stack_output.num
            fprintf(fileTable," out_%s",char(stack_output.stack(ii).identifier));
        end
    end
   
    %dump ComputationTime
    if settings.dumpComputationTime == 1
	fprintf(fileTable,' StepCompTime');
    end 

else
    
    
    %dump time
    fprintf(fileTable,"\n%d",time);

    %dump clock
    if settings.dumpClock == 1
        fprintf(fileTable," %d",[stack_mol.stack.clock]);
    end

    %dump vout
    if settings.dumpVout == 1
        fprintf(fileTable," %d", Vout);
    end
    
    %dump input
    if settings.dumpDriver == 1
        for ii=1:stack_driver.num
            fprintf(fileTable," %d", (stack_driver.stack(ii).charge(1).q - stack_driver.stack(ii).charge(2).q));
        end
%         fprintf(fileTable," %d", cell2mat(driver_values(:,time+1))');
    end

    %dump output
    if settings.dumpOutput == 1
        for ii=1:stack_output.num
            fprintf(fileTable," %d", stack_output.stack(ii).Vprobe);
        end
    end

    %dump ComputationTime
    if settings.dumpComputationTime == 1
        fprintf(fileTable," %d", compTime);
    end
end
end
