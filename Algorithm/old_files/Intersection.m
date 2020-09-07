function [ dot1_q, dot2_q,  dot3_q, dot4_q ] = Intersection( Vin, ck, P1, P2, P3, P4 )

%%% DOT 1
I1 = ((P2.V-Vin)/(P2.V-P1.V))*P1.q1 + ((Vin-P1.V)/(P2.V-P1.V))*P2.q1;

if P3.empty ~= 1
    I2 = ((P2.V-Vin)/(P2.V-P1.V))*P3.q1 + ((Vin-P1.V)/(P2.V-P1.V))*P4.q1;
    I3 = ((P3.clk-ck)/(P3.clk-P1.clk))*I1 + ((ck-P2.clk)/(P4.clk-P2.clk))*I2; 
    dot1_q = I3;
else
    dot1_q = I1;
end


%%% DOT 2
I1 = ((P2.V-Vin)/(P2.V-P1.V))*P1.q2 + ((Vin-P1.V)/(P2.V-P1.V))*P2.q2;

if P3.empty ~= 1
    I2 = ((P2.V-Vin)/(P2.V-P1.V))*P3.q2 + ((Vin-P1.V)/(P2.V-P1.V))*P4.q2;
    I3 = ((P3.clk-ck)/(P3.clk-P1.clk))*I1 + ((ck-P2.clk)/(P4.clk-P2.clk))*I2; 
    dot2_q = I3;
else
    dot2_q = I1;
end

%%% DOT 3
I1 = ((P2.V-Vin)/(P2.V-P1.V))*P1.q3 + ((Vin-P1.V)/(P2.V-P1.V))*P2.q3;

if P3.empty ~= 1
    I2 = ((P2.V-Vin)/(P2.V-P1.V))*P3.q3 + ((Vin-P1.V)/(P2.V-P1.V))*P4.q3;
    I3 = ((P3.clk-ck)/(P3.clk-P1.clk))*I1 + ((ck-P2.clk)/(P4.clk-P2.clk))*I2; 
    dot3_q = I3;
else
    dot3_q = I1;
end

%%% DOT 2
I1 = ((P2.V-Vin)/(P2.V-P1.V))*P1.q4 + ((Vin-P1.V)/(P2.V-P1.V))*P2.q4;

if P3.empty ~= 1
    I2 = ((P2.V-Vin)/(P2.V-P1.V))*P3.q4 + ((Vin-P1.V)/(P2.V-P1.V))*P4.q4;
    I3 = ((P3.clk-ck)/(P3.clk-P1.clk))*I1 + ((ck-P2.clk)/(P4.clk-P2.clk))*I2; 
    dot4_q = I3;
else
    dot4_q = I1;
end


end

