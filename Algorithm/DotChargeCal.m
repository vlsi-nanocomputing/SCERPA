function DotCharge=DotChargeCal(V_display,stack_mol, CK)

EquiVol=V_display(1,1:stack_mol.num);

DotCharge=zeros(stack_mol.num,4);
for ii=1:stack_mol.num
    DotCharge(ii,1)=ii;    
end

for ii=1:stack_mol.num
        
    [P1, P2, P3, P4] = SearchValues( EquiVol(1,ii), stack_mol.stack(ii).clock, CK );
   	[ DotCharge(ii,2), DotCharge(ii,3),  DotCharge(ii,4), DotCharge(ii,5) ] = Intersection( EquiVol(1,ii), stack_mol.stack(ii).clock, P1, P2, P3, P4 );
 
end

end