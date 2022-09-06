function stack_potential = TakeOut_Driver(V_display,Charge_on_wire_done,stack_mol, CK)
    
    stack_potential = zeros(1, stack_mol.num);
    
    for ii=1:stack_mol.num 
        
        [P1, P2, P3, P4] = SearchValues( V_display(1,ii), stack_mol.stack(ii).clock, CK );
       	[ dot1_q, dot2_q, dot3_q, dot4_q ] = Intersection( V_display(1,ii), stack_mol.stack(ii).clock, P1, P2, P3, P4 );
 
     	stack_mol.stack(ii).charge(1).q = dot1_q - Charge_on_wire_done(ii,2);
       	stack_mol.stack(ii).charge(2).q = dot2_q - Charge_on_wire_done(ii,3);
     	stack_mol.stack(ii).charge(3).q = dot3_q - Charge_on_wire_done(ii,4);
       	stack_mol.stack(ii).charge(4).q = dot4_q - Charge_on_wire_done(ii,5);    

      	for jj=1:stack_mol.num
            if ii==jj
             	continue;
            else
             	[V10]=ChargeBased_CalPotential(stack_mol.stack(ii),stack_mol.stack(jj));                        
              	stack_potential(1,jj) = stack_potential(1,jj)+V10;
            end 
        end
    end        
end