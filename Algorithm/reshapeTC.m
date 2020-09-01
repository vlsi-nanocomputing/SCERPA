function reshapeCK = reshapeTC(CK)

reshapeCK.nVin = 100;
reshapeCK.Vin = linspace(-2,+2,reshapeCK.nVin);
reshapeCK.nClk = CK.num;
reshapeCK.molID = CK.molID;

reshapeCK.clkList = zeros(1,CK.num); %preallocate
for tt = 1:CK.num %%loop on transcharacteristics
    reshapeCK.clkList(tt) = CK.characteristic(tt).value;
    
   
    for cc = 1:4 %% loop on charges
        reshapeCK.data(tt).tc(:,cc) = interp1(...
            CK.characteristic(tt).data(:,1),...
            CK.characteristic(tt).data(:,cc+1),...
            reshapeCK.Vin,...
            'linear','extrap');
    end
    
end

end