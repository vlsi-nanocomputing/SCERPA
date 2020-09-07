function [P1_out, P2_out, P3_out, P4_out] = SearchValues( Vin, ck, CK )

for ii=1:CK.num-1
    
    %%% CASE 1) The characteristic is present
    if ck == CK.characteristic(ii).value || ck == CK.characteristic(ii+1).value
        if ck == CK.characteristic(ii).value
            tt = ii;
        else
            tt = ii+1;
        end
        
        %%% CASE 1.1) Find "Vin_max" and "Vin_min" in the characteristic "ck"
        for jj=1:size(CK.characteristic(tt).data,1)-1
            if find(CK.characteristic(tt).data(jj,1) <= Vin & CK.characteristic(tt).data(jj+1,1) >= Vin);
               
                P1.clk = CK.characteristic(tt).value;
                P1.V   = CK.characteristic(tt).data(jj,1);
                P1.q1  = CK.characteristic(tt).data(jj,2);
                P1.q2  = CK.characteristic(tt).data(jj,3);
                P1.q3  = CK.characteristic(tt).data(jj,4);
                P1.q4  = CK.characteristic(tt).data(jj,5);
                P1.empty = 0;
                
                P2.clk = CK.characteristic(tt).value;
                P2.V   = CK.characteristic(tt).data(jj+1,1);
                P2.q1  = CK.characteristic(tt).data(jj+1,2);
                P2.q2  = CK.characteristic(tt).data(jj+1,3);
                P2.q3  = CK.characteristic(tt).data(jj+1,4);
                P2.q4  = CK.characteristic(tt).data(jj+1,5);
                P2.empty = 0;

                P3.empty = 1;
                P4.empty = 1;
            end
        end
        
    %%% CASE 2) Find "ck_max" and "ck_min" where ck = [ck_max, ck_min]     
    elseif find(CK.characteristic(ii).value <= ck & CK.characteristic(ii+1).value >= ck);
        
        %%% CASE 2.1) Find "Vin_max" and "Vin_min" in the characteristic "ck_min"
        for jj=1:size(CK.characteristic(ii).data,1)-1
            if find(CK.characteristic(ii).data(jj,1) <= Vin & CK.characteristic(ii).data(jj+1,1) >= Vin); 
                
                P1.clk = CK.characteristic(ii).value;
                P1.V   = CK.characteristic(ii).data(jj,1);
                P1.q1  = CK.characteristic(ii).data(jj,2);
                P1.q2  = CK.characteristic(ii).data(jj,3);
                P1.q3  = CK.characteristic(ii).data(jj,4);
                P1.q4  = CK.characteristic(ii).data(jj,5);
                P1.empty = 0;                 
                
                P2.clk = CK.characteristic(ii).value;
                P2.V   = CK.characteristic(ii).data(jj+1,1);
                P2.q1  = CK.characteristic(ii).data(jj+1,2);
                P2.q2  = CK.characteristic(ii).data(jj+1,3);
                P2.q3  = CK.characteristic(ii).data(jj+1,4);
                P2.q4  = CK.characteristic(ii).data(jj+1,5);
                P2.empty = 0;
            end
        end
        
        %%% CASE 2.1) Find "Vin_max" and "Vin_min" in the characteristic "ck_max"
        for jj=1:size(CK.characteristic(ii+1).data,1)-1
            if find(CK.characteristic(ii+1).data(jj,1) <= Vin & CK.characteristic(ii+1).data(jj+1,1) >= Vin);
                
                P3.clk = CK.characteristic(ii+1).value;
                P3.V   = CK.characteristic(ii+1).data(jj,1);
                P3.q1  = CK.characteristic(ii+1).data(jj,2);
                P3.q2  = CK.characteristic(ii+1).data(jj,3);
                P3.q3  = CK.characteristic(ii+1).data(jj,4);
                P3.q4  = CK.characteristic(ii+1).data(jj,5);
                P3.empty = 0;
                 
                P4.clk = CK.characteristic(ii+1).value;
                P4.V   = CK.characteristic(ii+1).data(jj+1,1);
                P4.q1  = CK.characteristic(ii+1).data(jj+1,2);
                P4.q2  = CK.characteristic(ii+1).data(jj+1,3);
                P4.q3  = CK.characteristic(ii+1).data(jj+1,4);
                P4.q4  = CK.characteristic(ii+1).data(jj+1,5);
                P4.empty = 0;
            end
        end
    end
end

P1_out = P1;
P2_out = P2;
P3_out = P3;
P4_out = P4;

if P2.V ~= max(P1.V, P2.V)
   P1_out = P2;
   P2_out = P1;
end

if P3.empty ~= 1
    if P4.V ~= max(P3.V, P4.V)
       P3_out = P4;
       P4_out = P3;
    end
end



end

