function [V10_out]=CalPotential(V10_in, pre_V10, ori_in, dest, CK)

ori_out=ori_in;

[ P1, P2, P3, P4 ] = SearchValues( V10_in+pre_V10, ori_out.clock, CK );
[ dot1_q_in, dot2_q_in, dot3_q_in, dot4_q_in ] = Intersection( V10_in+pre_V10, ori_out.clock, P1, P2, P3, P4 );

[ P1, P2, P3, P4 ] = SearchValues( pre_V10, ori_out.clock, CK );
[ dot1_q_pre, dot2_q_pre, dot3_q_pre, dot4_q_pre ] = Intersection( pre_V10, ori_out.clock, P1, P2, P3, P4 );

ori_out.charge(1).q = dot1_q_in - dot1_q_pre;
ori_out.charge(2).q = dot2_q_in - dot2_q_pre;  
ori_out.charge(3).q = dot3_q_in - dot3_q_pre;
ori_out.charge(4).q = dot4_q_in - dot4_q_pre; 

c1=ori_out.charge(1);
c2=ori_out.charge(2);
c3=ori_out.charge(3);
c4=ori_out.charge(4);

qe=1.6e-19;
e0=8.854e-12;

r_dot_11 = sqrt((ori_in.charge(1).x-dest.charge(1).x)^2+(ori_in.charge(1).y-dest.charge(1).y)^2+(ori_in.charge(1).z-dest.charge(1).z)^2)*1e-10;
r_dot_12 = sqrt((ori_in.charge(1).x-dest.charge(2).x)^2+(ori_in.charge(1).y-dest.charge(2).y)^2+(ori_in.charge(1).z-dest.charge(2).z)^2)*1e-10;
r_dot_21 = sqrt((ori_in.charge(2).x-dest.charge(1).x)^2+(ori_in.charge(2).y-dest.charge(1).y)^2+(ori_in.charge(2).z-dest.charge(1).z)^2)*1e-10;
r_dot_22 = sqrt((ori_in.charge(2).x-dest.charge(2).x)^2+(ori_in.charge(2).y-dest.charge(2).y)^2+(ori_in.charge(2).z-dest.charge(2).z)^2)*1e-10;
r_dot_31 = sqrt((ori_in.charge(3).x-dest.charge(1).x)^2+(ori_in.charge(3).y-dest.charge(1).y)^2+(ori_in.charge(3).z-dest.charge(1).z)^2)*1e-10;
r_dot_32 = sqrt((ori_in.charge(3).x-dest.charge(2).x)^2+(ori_in.charge(3).y-dest.charge(2).y)^2+(ori_in.charge(3).z-dest.charge(2).z)^2)*1e-10;
r_dot_41 = sqrt((ori_in.charge(4).x-dest.charge(1).x)^2+(ori_in.charge(4).y-dest.charge(1).y)^2+(ori_in.charge(4).z-dest.charge(1).z)^2)*1e-10;
r_dot_42 = sqrt((ori_in.charge(4).x-dest.charge(2).x)^2+(ori_in.charge(4).y-dest.charge(2).y)^2+(ori_in.charge(4).z-dest.charge(2).z)^2)*1e-10;

V_dot_1 = (1/(4*pi*e0))*((c1.q*qe)/r_dot_11) + (1/(4*pi*e0))*((c2.q*qe)/r_dot_21) + (1/(4*pi*e0))*((c3.q*qe)/r_dot_31) + (1/(4*pi*e0))*((c4.q*qe)/r_dot_41);
V_dot_2 = (1/(4*pi*e0))*((c1.q*qe)/r_dot_12) + (1/(4*pi*e0))*((c2.q*qe)/r_dot_22) + (1/(4*pi*e0))*((c3.q*qe)/r_dot_32) + (1/(4*pi*e0))*((c4.q*qe)/r_dot_42);

V10_out = V_dot_1 - V_dot_2;
end
