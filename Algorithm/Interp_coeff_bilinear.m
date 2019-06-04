function [CK] = Interp_coeff_bilinear(molecule)

formatSpec = '%f %f %f %f %f';
filename_setting = sprintf('Characteristics_Setting/%s/characteristics_data.xlsx',molecule);
[num_data,txt_data,raw_data] = xlsread(filename_setting);

for jj = 2:size(raw_data,1)
    filename = [sprintf('Characteristics_Setting/%s/%s', molecule, raw_data{jj,1})];
    fileID = fopen(filename,'r');
    sizeA = [5 raw_data{jj,3}];
    A = fscanf(fileID,formatSpec, sizeA);
    
    fclose(fileID);
    A=A';
    
    for t=1:raw_data{jj,3}
        M(raw_data{jj,3}-t+1,:) = A(t,:);  %the matrix rows are inverted to start from left saturation
    end
    
    CK.characteristic(jj-1).data(:,:,1) = M(1:raw_data{jj,3},:);   
    CK.characteristic(jj-1).value = raw_data{jj,2}
    CK.num = jj-1;
end

end
