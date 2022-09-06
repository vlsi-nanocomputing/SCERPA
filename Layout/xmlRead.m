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
function outStruct = xmlRead (inputQLL)

in_str=fileread(inputQLL); % convert QLL into a string

abq = '([^"]+)';    % anything but quotation mark

% extrac intermolecular distance
xpr = ['<property name="Intermolecular Distance" value="',abq,'"/>'];
intermolecular_distance = regexp(in_str, xpr, 'tokens');
outStruct.dist_z = str2double(cell2mat(intermolecular_distance{1,1}))/100; %convert pm to angstrom

% extract list of molecular types present in the layout
xpr = ['<item tech="MolQCA" name="',abq,'"/>'];
molecule = regexp(in_str, xpr, 'tokens');
molTypeList = zeros(1,length(molecule));
for ii=1:length(molecule)
    switch cell2mat(molecule{1,ii})
        case 'Bisferrocene'
            molTypeList(ii) = 1;
        case 'Butane'
            molTypeList(ii) = 7;
    end
end

% extract drivers list
xpr = ['\s*<pin tech="MolQCA" name="',abq,'" direction="0" id="',abq,'"( angle="',abq,'")? x="',abq,'" y="',abq,'" layer="0"/>\s*'];
tmp = regexp(in_str, xpr, 'tokens');
drivers = cell(5,length(tmp)); % preallocate drivers cell array, # of rows is fixed (it equals the number of fields for drivers)
for ii=1:length(tmp)
    drivers(:,ii) = tmp{1,ii};
end
outStruct.driver.name = drivers(1,:);
outStruct.driver.id = drivers(2,:);
for ii = 1:size(drivers,2)
    if isequal(drivers(3,ii),{''})
        outStruct.driver.angle(ii) = 0;
    else
        outStruct.driver.angle(ii) = str2double(cell2mat(regexp(cell2mat(drivers(3,ii)),'\d*','Match')));
    end
end
outStruct.driver.x = str2double(drivers(4,:));
outStruct.driver.y = str2double(drivers(5,:));
outStruct.driver.z = zeros(1,length(drivers)); % it would be "layer" in the future

% extract outputs list
xpr = ['\s*<pin tech="MolQCA" name="',abq,'" direction="1" id="',abq,'"( angle="',abq,'")? x="',abq,'" y="',abq,'" layer="0"/>\s*'];
tmp = regexp(in_str, xpr, 'tokens');
outputs = cell(5,length(tmp)); % preallocate output cell array, # of rows is fixed (it equals the number of fields for drivers)
for ii=1:length(tmp)
    outputs(:,ii) = tmp{1,ii};
end
outStruct.output.name = outputs(1,:);
outStruct.output.id = outputs(2,:);
for ii = 1:size(outputs,2)
    if isequal(outputs(3,ii),{''})
        outStruct.output.angle(ii) = 0;
    else
        outStruct.output.angle(ii) = str2double(cell2mat(regexp(cell2mat(outputs(3,ii)),'\d*','Match')));
    end
end
outStruct.output.x = str2double(outputs(4,:));
outStruct.output.y = str2double(outputs(5,:));
outStruct.output.z = zeros(1,size(outputs,2)); % it would be "layer" in the future

% extract molecules list
xpr = ['<item comp="',abq,'" id="',abq,'"( angle="',abq,'")? x="',abq,'" y="',abq,'" layer="0">(\s*<property name="',abq,'" value="',abq,'"/>)*'];
tmp = regexp(in_str, xpr, 'tokens');
mol_layout = cell(6,length(tmp)); % preallocate output cell array, # of rows is fixed (it equals the number of fields for drivers)
for ii = 1:length(tmp)
    str_test = tmp{1,ii}{1,6};
    express = ['\s*<property name="',abq,'" value="',abq,'"/>'];
    tmp{1,ii}{1,6} = regexp(str_test, express, 'tokens');
    mol_layout(:,ii) = tmp{1,ii};
    for jj = 1:size(mol_layout{6,ii},2)
         prop_name = mol_layout{6,ii}{1,jj}{1,1};
         prop_value = mol_layout{6,ii}{1,jj}{1,2};
         switch prop_name
             case 'phase'
                 outStruct.molecules(ii).phase = str2double(prop_value);
             case 'angle_a'
                 outStruct.molecules(ii).angle_a = str2double(prop_value);
             case 'angle_b'
                 outStruct.molecules(ii).angle_b = str2double(prop_value);
             case 'xshift_a'
                 outStruct.molecules(ii).xshift_a = str2double(prop_value)/100; % divided by 100 to pass from pm to angstrom
             case 'xshift_b'
                 outStruct.molecules(ii).xshift_b = str2double(prop_value)/100; % divided by 100 to pass from pm to angstrom
             case 'yshift_a'
                 outStruct.molecules(ii).yshift_a = str2double(prop_value)/100; % divided by 100 to pass from pm to angstrom
             case 'yshift_b'
                 outStruct.molecules(ii).yshift_b = str2double(prop_value)/100; % divided by 100 to pass from pm to angstrom
             case 'zshift_a'
                 outStruct.molecules(ii).zshift_a = str2double(prop_value)/100; % divided by 100 to pass from pm to angstrom
             case 'zshift_b'
                 outStruct.molecules(ii).zshift_b = str2double(prop_value)/100; % divided by 100 to pass from pm to angstrom
             case 'disabled_a'
                 outStruct.molecules(ii).disabled_a = 1;
             case 'disabled_b'
                 outStruct.molecules(ii).disabled_b = 1;
         end
    end
    outStruct.molecules(ii).molType =  molTypeList(str2double(mol_layout(1,ii))+1);
    outStruct.molecules(ii).id = mol_layout(2,ii);
    if isequal(mol_layout(3,ii),{''})
        outStruct.molecules(ii).angle = 0;
    else
        outStruct.molecules(ii).angle = str2double(cell2mat(regexp(cell2mat(outputs(3,ii)),'\d*','Match')));
    end
    outStruct.molecules(ii).x = str2double(mol_layout(4,ii));
    outStruct.molecules(ii).y = str2double(mol_layout(5,ii));
    outStruct.molecules(ii).z = 0; % it would be "layer" in the future
end

end