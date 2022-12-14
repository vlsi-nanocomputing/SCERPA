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
function fileTable = Function_SaveTable(constructMode,settings,stack_mol,stack_driver,stack_output,fileTable, time, Vout, driver_values,compTime,stack_energy)  

if constructMode ==1
    %create file
    add_info_path = fullfile(settings.out_path,'Additional_Information.txt');
    fileTable = fopen(add_info_path,'wt');
    fprintf(fileTable,'#time');
    
    %dump clock
    if settings.dumpClock == 1
        for ii=1:stack_mol.num
            fprintf(fileTable,",CK_%s",stack_mol.stack(ii).identifier_qll);
        end
    end

    %dump vout
    if settings.dumpVout == 1
        for ii=1:stack_mol.num
            try
                fprintf(fileTable,",Vout_%s",stack_mol.stack(ii).identifier_qll);
            catch
                fprintf(fileTable,",Vout_%s",char(stack_mol.stack(ii).identifier_qll));
            end
        end
    end
    
    %dump input
    if settings.dumpDriver == 1
        for ii=1:stack_driver.num
            fprintf(fileTable,",driver_%s",stack_driver.stack(ii).identifier_qll);
        end
    end
    
    %dump output
    if settings.dumpOutput == 1
        for ii=1:stack_output.num
            fprintf(fileTable,",out_%s",stack_output.stack(ii).identifier);
        end
    end
   
    %dump ComputationTime
    if settings.dumpComputationTime == 1
        fprintf(fileTable,',StepCompTime');
    end 
    
    %dump Energy
    if settings.dumpEnergy == 1
        fprintf(fileTable,",W_int,W_ex,W_clk,W_TOT");
    end

else
    
    
    %dump time
    fprintf(fileTable,"\n%d",time);

    %dump clock
    if settings.dumpClock == 1
        fprintf(fileTable,",%d",[stack_mol.stack.clock]);
    end

    %dump vout
    if settings.dumpVout == 1
        fprintf(fileTable,",%d", Vout);
    end
    
    %dump input
    if settings.dumpDriver == 1
        for ii=1:stack_driver.num
            fprintf(fileTable,",%d", (stack_driver.stack(ii).charge(1).q - stack_driver.stack(ii).charge(2).q));
        end
%         fprintf(fileTable," %d", cell2mat(driver_values(:,time+1))');
    end

    %dump output
    if settings.dumpOutput == 1
        for ii=1:stack_output.num
            fprintf(fileTable,",%d", stack_output.stack(ii).Vprobe);
        end
    end

    %dump ComputationTime
    if settings.dumpComputationTime == 1
        fprintf(fileTable,",%d", compTime);
    end
    
    %dump energy
    if settings.dumpEnergy == 1 
        if settings.energyEval == 1
            fprintf(fileTable,",%f,%f,%f,%f,%f",stack_energy(time).W_0_tot(end),stack_energy(time).W_int(end),stack_energy(time).W_ex(end),stack_energy(time).W_clk(end),stack_energy(time).W_tot(end));
        else
            warning('Enable the setting for energy evaluation (energyEval = 1)')
            fprintf(fileTable,",%f,%f,%f,%f,%f",0,0,0,0,0);
        end
    end
end
