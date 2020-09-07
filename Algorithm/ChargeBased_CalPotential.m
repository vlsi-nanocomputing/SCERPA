function [V10_out]=ChargeBased_CalPotential(ori_in, dest)

driver_charge1=ori_in.charge(1);
driver_charge2=ori_in.charge(2);
driver_charge3=ori_in.charge(3);
driver_charge4=ori_in.charge(4);

dest_charge1=dest.charge(1);
dest_charge2=dest.charge(2);

%V = (1/(4*pi*e0))*((c1.q*qe)/r_dot_11)   = 
%  = (qe/(4*pi*e0))*((c1.q)/(r*1e-10)) =
%  = (qe/(4*pi*e0*1e-10))*(c1.q/r) =
%  = constant * (c1.q/r)

% qe=1.6e-19;
% e0=8.854e-12;
% constant = (1/(4*pi*e0)) * qe / 1e-10;
const = 14.380387900781148;
r_dot_11 = sqrt((driver_charge1.x-dest_charge1.x)^2+(driver_charge1.y-dest_charge1.y)^2+(driver_charge1.z-dest_charge1.z)^2);
r_dot_12 = sqrt((driver_charge1.x-dest_charge2.x)^2+(driver_charge1.y-dest_charge2.y)^2+(driver_charge1.z-dest_charge2.z)^2);
r_dot_21 = sqrt((driver_charge2.x-dest_charge1.x)^2+(driver_charge2.y-dest_charge1.y)^2+(driver_charge2.z-dest_charge1.z)^2);
r_dot_22 = sqrt((driver_charge2.x-dest_charge2.x)^2+(driver_charge2.y-dest_charge2.y)^2+(driver_charge2.z-dest_charge2.z)^2);
r_dot_31 = sqrt((driver_charge3.x-dest_charge1.x)^2+(driver_charge3.y-dest_charge1.y)^2+(driver_charge3.z-dest_charge1.z)^2);
r_dot_32 = sqrt((driver_charge3.x-dest_charge2.x)^2+(driver_charge3.y-dest_charge2.y)^2+(driver_charge3.z-dest_charge2.z)^2);
r_dot_41 = sqrt((driver_charge4.x-dest_charge1.x)^2+(driver_charge4.y-dest_charge1.y)^2+(driver_charge4.z-dest_charge1.z)^2);
r_dot_42 = sqrt((driver_charge4.x-dest_charge2.x)^2+(driver_charge4.y-dest_charge2.y)^2+(driver_charge4.z-dest_charge2.z)^2);

%V=V1-V2 = const*V1' + const V2' = const(V1'+V2')
% V_dot_1 = constant*(c1.q/r_dot_11 + c2.q/r_dot_21 + c3.q/r_dot_31 + c4.q/r_dot_41);
% V_dot_2 = constant*(c1.q/r_dot_12 + c2.q/r_dot_22 + c3.q/r_dot_32 + c4.q/r_dot_42);
V_dot_1 = driver_charge1.q/r_dot_11 + driver_charge2.q/r_dot_21 + driver_charge3.q/r_dot_31 + driver_charge4.q/r_dot_41;
V_dot_2 = driver_charge1.q/r_dot_12 + driver_charge2.q/r_dot_22 + driver_charge3.q/r_dot_32 + driver_charge4.q/r_dot_42;

% V10_out = V_dot_1 - V_dot_2;
V10_out = const*(V_dot_1 - V_dot_2);


end