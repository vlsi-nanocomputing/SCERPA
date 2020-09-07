function reshapeCK = reshapeTC(CK)

% preallocation of fields
reshapeCK.nVin = 100;
reshapeCK.Vin = linspace(-2,+2,reshapeCK.nVin);
reshapeCK.nClk = CK.num;
reshapeCK.molID = CK.molID;
reshapeCK.clkList = zeros(1,CK.num);

% loop on transcharacteristics
for tt = 1:CK.num 
    reshapeCK.clkList(tt) = CK.characteristic(tt).value;
    
    % loop on charges
    for cc = 1:4 
        reshapeCK.data(tt).tc(:,cc) = interp1(...
            CK.characteristic(tt).data(:,1),...
            CK.characteristic(tt).data(:,cc+1),...
            reshapeCK.Vin,...
            'linear','extrap');
    end
    
end

end