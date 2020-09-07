%BIAS EVAL
function stack_potential = Clock_Change(V_display,Charge_on_wire_done,stack_mol,CK) 
    stack_potential = zeros(1, stack_mol.num);

    for ii=1:stack_mol.num 
%         if stack_mol.stack(ii).clock==stack_mol.stack(ii).pre_clock
%             continue;
%         else
            
%             [P1, P2, P3, P4] = SearchValues( 0, stack_mol.stack(ii).clock, CK );
%             [ dot1_equil, dot2_equil, dot3_equil, dot4_equil ] = Intersection( 0, stack_mol.stack(ii).clock, P1, P2, P3, P4 );

            [P1, P2, P3, P4] = SearchValues( V_display(1,ii), stack_mol.stack(ii).clock, CK );
            [ dot1_q, dot2_q, dot3_q, dot4_q ] = Intersection( V_display(1,ii), stack_mol.stack(ii).clock, P1, P2, P3, P4 );
            
            stack_mol.stack(ii).charge(1).q = dot1_q;% - Charge_on_wire_done(ii,2);
            stack_mol.stack(ii).charge(2).q = dot2_q;%- Charge_on_wire_done(ii,3);
            stack_mol.stack(ii).charge(3).q = dot3_q;% - Charge_on_wire_done(ii,4);
            stack_mol.stack(ii).charge(4).q = dot4_q;% - Charge_on_wire_done(ii,5);
            
            

            for jj=1:stack_mol.num
                if ii==jj
                    continue;
                else
                    [V10]=ChargeBased_CalPotential(stack_mol.stack(ii),stack_mol.stack(jj));                        
                    stack_potential(1,jj) = stack_potential(1,jj)+V10;
                end 
            end
%         end
    end      
end

%old version below
% function stack_potential = Clock_Change(V_display,Charge_on_wire_done,stack_mol,CK)
%     pre_stack_potential = zeros(1, stack_mol.num);
%     now_stack_potential = zeros(1, stack_mol.num);
%     
%     for ii=1:stack_mol.num 
%         if stack_mol.stack(ii).clock==stack_mol.stack(ii).pre_clock
%             continue;
%         else
%             
%             [P1, P2, P3, P4] = SearchValues( V_display, stack_mol.stack(ii).clock, CK );
%             [ dot1_now, dot2_now, dot3_now, dot4_now ] = Intersection( V_display(1,ii), stack_mol.stack(ii).clock, P1, P2, P3, P4 );
%             
%             %evaluate with preclock            
%             stack_mol.stack(ii).charge(1).q = Charge_on_wire_done(ii,2);
%             stack_mol.stack(ii).charge(2).q = Charge_on_wire_done(ii,3);
%             stack_mol.stack(ii).charge(3).q = Charge_on_wire_done(ii,4);
%             stack_mol.stack(ii).charge(4).q = Charge_on_wire_done(ii,5);
% 
%             for jj=1:stack_mol.num
%                 if ii==jj
%                     continue;
%                 else
%                     [V10_pre]=ChargeBased_CalPotential(stack_mol.stack(ii),stack_mol.stack(jj));                        
%                     pre_stack_potential(1,jj) = pre_stack_potential(1,jj)+V10_pre;
%                 end 
%             end
%             
%             %evaluate with new clock            
%             stack_mol.stack(ii).charge(1).q = dot1_now;
%             stack_mol.stack(ii).charge(2).q = dot2_now;
%             stack_mol.stack(ii).charge(3).q = dot3_now;
%             stack_mol.stack(ii).charge(4).q = dot4_now;
% 
%             for jj=1:stack_mol.num
%                 if ii==jj
%                     continue;
%                 else
%                     [V10_now]=ChargeBased_CalPotential(stack_mol.stack(ii),stack_mol.stack(jj));                        
%                     now_stack_potential(1,jj) = now_stack_potential(1,jj)+V10_now;
%                 end 
%             end
%         end
%     end
%     
%      stack_potential = -pre_stack_potential + now_stack_potential;
%     
%     
% end

% function stack_potential = Clock_Change(V_display,Charge_on_wire_done,stack_mol,CK) 
%     stack_potential = zeros(1, stack_mol.num);
% 
%     for ii=1:stack_mol.num 
%         if stack_mol.stack(ii).clock==stack_mol.stack(ii).pre_clock
%             continue;
%         else
%             
%             [P1, P2, P3, P4] = SearchValues( 0, stack_mol.stack(ii).clock, CK );
%             [ dot1_equil, dot2_equil, dot3_equil, dot4_equil ] = Intersection( 0, stack_mol.stack(ii).clock, P1, P2, P3, P4 );
% 
%             [P1, P2, P3, P4] = SearchValues( V_display(1,ii), stack_mol.stack(ii).clock, CK );
%             [ dot1_q, dot2_q, dot3_q, dot4_q ] = Intersection( V_display(1,ii), stack_mol.stack(ii).clock, P1, P2, P3, P4 );
%             
%             stack_mol.stack(ii).charge(1).q = dot1_q - Charge_on_wire_done(ii,2);
%             stack_mol.stack(ii).charge(2).q = dot2_q - Charge_on_wire_done(ii,3);
%             stack_mol.stack(ii).charge(3).q = dot3_q - Charge_on_wire_done(ii,4);
%             stack_mol.stack(ii).charge(4).q = dot4_q - Charge_on_wire_done(ii,5);
%             
%             
% 
%             for jj=1:stack_mol.num
%                 if ii==jj
%                     continue;
%                 else
%                     [V10]=ChargeBased_CalPotential(stack_mol.stack(ii),stack_mol.stack(jj));                        
%                     stack_potential(1,jj) = stack_potential(1,jj)+V10;
%                 end 
%             end
%         end
%     end      
% end