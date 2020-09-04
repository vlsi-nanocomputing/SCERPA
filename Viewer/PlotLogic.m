 function out_fig = PlotLogic(stack_mol, stack_driver, stack_output, settings)
 
 P_map = 0;
        
%consider molecules 2-by-2
for ii=1:2:stack_mol.num
    
    %evaluate polarization
    P = (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q - stack_mol.stack(ii).charge(2).q - stack_mol.stack(ii+1).charge(1).q)/...
        (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q + stack_mol.stack(ii).charge(2).q + stack_mol.stack(ii+1).charge(1).q);

    [p1] = sscanf(char(stack_mol.stack(ii).position),'[%d %d %d]');
    [p2] = sscanf(char(stack_mol.stack(ii+1).position),'[%d %d %d]');
    
    %add offset (for white)
    P_map(p1(2)+1,p1(3)+1) = P+2;
    P_map(p2(2)+1,p2(3)+1) = P+2;

end

%colormap
map = [1 1 1; 1 1 1; 1 0 0; 0.5 0 0; 0 0 0; 0 0 0.5; 0 0 1];

%create figure
out_fig = figure('visible','off');
hold on
imagesc(P_map)
colormap(map)
colorbar('XTickLabel',{'P = -1','P = 1'},'XTick',[1 3])
caxis([0 3])
axis equal
xlabel('z [nm]'); ylabel('y [nm]');
%         set(gca,'zdir','reverse') 
set(gca,'ydir','reverse') 
title('Logic Polarization')

 end