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