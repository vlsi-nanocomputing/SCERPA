function [Q1, Q2, Q3, Q4] = applyTranschar(Vin,Vclk,datackopt)
% Evaluate charge on the molecule
%   Given the switching voltage, the clock voltage and the 
%   transcharacteristics, the function returns the aggregated charges of
%   the molecule.

%check boundary
if Vin<datackopt.Vin(1)
    Vin = datackopt.Vin(1);
elseif Vin>datackopt.Vin(end)
    Vin = datackopt.Vin(end); 
end

%determine clock factor
clkFactor = (datackopt.nClk-1)*(Vclk - datackopt.clkList(1)) / (datackopt.clkList(end) - datackopt.clkList(1)) + 1;
clkIndex = floor(clkFactor);
clkWeight = clkFactor - clkIndex;

%determine vin factor
vinFactor = (datackopt.nVin - 1)*( Vin - datackopt.Vin(1) ) / (datackopt.Vin(end) - datackopt.Vin(1)) + 1;
vinIndex = floor(vinFactor);
vinWeight = vinFactor - vinIndex;


%eval charge with the lowest clock and lowest vin
dataLowClock = datackopt.data(clkIndex).tc(:,:);
Q1 = dataLowClock(vinIndex,1);
Q2 = dataLowClock(vinIndex,2);
Q3 = dataLowClock(vinIndex,3);
Q4 = dataLowClock(vinIndex,4);
        
if vinWeight ~= 0
    %add contribution of vinweight on the lowest clock configuration
    Q1 = Q1 + vinWeight*( dataLowClock(vinIndex+1,1) -Q1);
    Q2 = Q2 + vinWeight*( dataLowClock(vinIndex+1,2) -Q2);
    Q3 = Q3 + vinWeight*( dataLowClock(vinIndex+1,3) -Q3);
    Q4 = Q4 + vinWeight*( dataLowClock(vinIndex+1,4) -Q4);
end

if clkWeight ~= 0
    dataHighClock = datackopt.data(clkIndex+1).tc(:,:);
    Q1h = dataHighClock(vinIndex,1);
    Q2h = dataHighClock(vinIndex,2);
    Q3h = dataHighClock(vinIndex,3);
    Q4h = dataHighClock(vinIndex,4);
    
    if vinWeight ~= 0
        Q1h = Q1h + vinWeight*(dataHighClock(vinIndex+1,1)-Q1h);
        Q2h = Q2h + vinWeight*(dataHighClock(vinIndex+1,2)-Q2h);
        Q3h = Q3h + vinWeight*(dataHighClock(vinIndex+1,3)-Q3h);
        Q4h = Q4h + vinWeight*(dataHighClock(vinIndex+1,4)-Q4h);
    end
    
    Q1 = Q1 + clkWeight*(Q1h - Q1);
    Q2 = Q2 + clkWeight*(Q2h - Q2);
    Q3 = Q3 + clkWeight*(Q3h - Q3);
    Q4 = Q4 + clkWeight*(Q4h - Q4);
    
end



end



