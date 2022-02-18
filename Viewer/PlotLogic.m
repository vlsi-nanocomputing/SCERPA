%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%       Self-Consistent Electrostatic Potential Algorithm (SCERPA)         %
%                                                                          %
%       VLSI Nanocomputing Research Group                                  %
%       Dept. of Electronics and Telecommunications                        %
%       Politecnico di Torino, Turin, Italy                                %
%       (https://www.vlsilab.polito.it/)                                   %
%                                                                          %
%       People [people you may contact for info]                           %
%         Yuri Ardesi (yuri.ardesi@polito.it)                              %
%         Giuliana Beretta (giuliana.beretta@polito.it)                    %
%                                                                          %
%       Supervision: Gianluca Piccinini, Mariagrazia Graziano              %
%                                                                          %
%       Relevant pubblications doi: 10.1109/TCAD.2019.2960360              %
%                                   10.1109/TVLSI.2020.3045198             %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function out_fig = PlotLogic(stack_mol, stack_driver, stack_output, settings)
 
 P_map = 0;
       
%  charges = [stack_mol.stack.charge];
 
% y_min = min([charges.y]);% - settings.plot_potential_padding;
% y_max = max([charges.y]);% + settings.plot_potential_padding;
% z_min = min([charges.z]);% - settings.plot_potential_padding; %-3 for deca, -5 for bisfe
% z_max = max([charges.z]);% + settings.plot_potential_padding; 

%consider molecules 2-by-2
for ii=1:2:stack_mol.num
    % check mol order because in magcad they are reversed
    [p1] = sscanf(char(stack_mol.stack(ii).position),'[%d %d %d]');
    [p2] = sscanf(char(stack_mol.stack(ii+1).position),'[%d %d %d]');
    
    if(p1(3) < p2(3)) %check on z coordinates
        %evaluate polarization
        P = (stack_mol.stack(ii).charge(2).q + stack_mol.stack(ii+1).charge(1).q - stack_mol.stack(ii).charge(1).q - stack_mol.stack(ii+1).charge(2).q)/...
            (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q + stack_mol.stack(ii).charge(2).q + stack_mol.stack(ii+1).charge(1).q);
    else
        %evaluate polarization
        P = (stack_mol.stack(ii+1).charge(2).q + stack_mol.stack(ii).charge(1).q - stack_mol.stack(ii+1).charge(1).q - stack_mol.stack(ii).charge(2).q)/...
            (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q + stack_mol.stack(ii).charge(2).q + stack_mol.stack(ii+1).charge(1).q);
        [p1] = sscanf(char(stack_mol.stack(ii+1).position),'[%d %d %d]');
        [p2] = sscanf(char(stack_mol.stack(ii).position),'[%d %d %d]');
    end
    
    %add offset (for white)
    P_map(p1(2)+1,p1(3)+1) = P+2;
    P_map(p2(2)+1,p2(3)+1) = P+2;

end

%consider drivers 2-by-2

for ii=1:2:stack_driver.num
    % check driver order because in magcad they are reversed
    [p1] = sscanf(char(stack_driver.stack(ii).position),'[%d %d %d]');
    [p2] = sscanf(char(stack_driver.stack(ii+1).position),'[%d %d %d]');
    
    if(p1(3) < p2(3)) %check on z coordinates
        %evaluate polarization
        P = (stack_driver.stack(ii).charge(2).q + stack_driver.stack(ii+1).charge(1).q - stack_driver.stack(ii).charge(1).q - stack_driver.stack(ii+1).charge(2).q)/...
            (stack_driver.stack(ii).charge(1).q + stack_driver.stack(ii+1).charge(2).q + stack_driver.stack(ii).charge(2).q + stack_driver.stack(ii+1).charge(1).q);
    else
        %evaluate polarization
        P = (stack_driver.stack(ii+1).charge(2).q + stack_driver.stack(ii).charge(1).q - stack_driver.stack(ii+1).charge(1).q - stack_driver.stack(ii).charge(2).q)/...
            (stack_driver.stack(ii).charge(1).q + stack_driver.stack(ii+1).charge(2).q + stack_driver.stack(ii).charge(2).q + stack_driver.stack(ii+1).charge(1).q);
        [p1] = sscanf(char(stack_driver.stack(ii+1).position),'[%d %d %d]');
        [p2] = sscanf(char(stack_driver.stack(ii).position),'[%d %d %d]');
    end
    
    %add offset (for white)
    P_map(p1(2)+1,p1(3)+1) = P+2;
    P_map(p2(2)+1,p2(3)+1) = P+2;

end

%colormap
blue = [42 56 163]/255;
red = [240 80 62]/255;
neutral = [0 0 0]/255;%= [170 240 74]/255;
nocircuit = [255 255 255]/255;
% map = [nocircuit; nocircuit; red; (red+neutral)/2; neutral; (blue+neutral)/2; blue;];
map = [nocircuit; 
    nocircuit; 
    red; 
%     (0.75*red+0.25*neutral); 
%     (0.66*red+0.33*neutral); 
    (0.5*red+0.5*neutral); 
%     (0.33*red+0.66*neutral); 
%     (0.25*red+0.75*neutral); 
    neutral; 
%     (0.75*neutral+0.25*blue); 
%     (0.66*neutral+0.33*blue); 
    (0.5*neutral+0.5*blue); 
%     (0.33*neutral+0.66*blue); 
%     (0.25*neutral+0.75*blue); 

    blue];

%create figure
out_fig = figure('visible','off');
ha = gca;
uistack(ha,'bottom');
ha2=axes('position',[0,0, 0.1,0.12]);
[x, imageMap]=imread(fullfile('../Documentation/','scerpa_logo.png'));
image(x)
colormap (imageMap)
set(ha2,'handlevisibility','off','visible','off')
hold on
imagesc(P_map)
colormap(map)
colorbar('XTickLabel',{'P = -1','P = 1'},'XTick',[1 3])
caxis([0 3])
xlabel('z'); ylabel('y');
%         set(gca,'zdir','reverse') 
set(gca,'ydir','reverse') 
title('Logic Polarization')
set(gca,'Yticklabel',[]) 
set(gca,'Xticklabel',[]) %to just get rid of the numbers but leave the ticks.
% axis([z_min z_max y_min y_max ]/10)
% axis equal

 end