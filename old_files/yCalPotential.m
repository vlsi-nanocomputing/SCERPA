function [V10_out]=yCalPotential(V10_in, ori_in, dest, CK)

[ P1, P2, P3, P4 ] = SearchValues( V10_in, ori_in.clock, CK );
[ dot1_q_in, dot2_q_in, dot3_q_in, dot4_q_in ] = Intersection( V10_in, ori_in.clock, P1, P2, P3, P4 );

ori_in.charge(1).q = dot1_q_in;
ori_in.charge(2).q = dot2_q_in;  
ori_in.charge(3).q = dot3_q_in;
ori_in.charge(4).q = dot4_q_in; 

V10_out = ChargeBased_CalPotential(ori_in, dest);
end
