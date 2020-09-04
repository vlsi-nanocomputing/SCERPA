function [stack_mol,stack_driver] = importQSS(stack_mol,stack_driver,qssFile)

qssID = fopen(qssFile,'r');

%skip preamble
tline = fgetl(qssID);
while strncmp(tline,'# Begin: data text',18)==0
    tline = fgetl(qssID);
end

%update stack
tline = fgetl(qssID);
while strncmp(tline,'# End: data text',16)==0
    
    %scan new line
    data = textscan(tline,"%s %f %f %f %f");
    entryName = char(data{1});
    Q1 = data{2};
    Q2 = data{3};
    Q3 = data{4};
    Q4 = data{5};
    
    %scan drivers
    for ii=1:stack_driver.num
       if strcmp(entryName,char(stack_driver.stack(ii).identifier_qll))
           stack_driver.stack(ii).charge(1).q = Q1;
           stack_driver.stack(ii).charge(2).q = Q2;
           stack_driver.stack(ii).charge(3).q = Q3;
           stack_driver.stack(ii).charge(4).q = Q4;
       end
    end
    
    %scan drivers
    for ii=1:stack_mol.num
       if strcmp(entryName,char(stack_mol.stack(ii).identifier_qll))
           stack_mol.stack(ii).charge(1).q = Q1;
           stack_mol.stack(ii).charge(2).q = Q2;
           stack_mol.stack(ii).charge(3).q = Q3;
           stack_mol.stack(ii).charge(4).q = Q4;
       end
    end
    
    %next line
    tline = fgetl(qssID);
end

%close file
fclose(qssID);

end