function [] = Function_Plotting(Vout, Charge_on_wire_done_set, stack_mol, stack_driver,settings, ii)

disable=0;

if disable==0
    if settings.plot_logic ==1
        P_map = 0;
        
        %consider molecules 2-by-2
        for ii=1:2:stack_mol.num
            %evaluate polarization
            
            P = (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q - stack_mol.stack(ii).charge(2).q - stack_mol.stack(ii+1).charge(1).q)/...
                (stack_mol.stack(ii).charge(1).q + stack_mol.stack(ii+1).charge(2).q + stack_mol.stack(ii).charge(2).q + stack_mol.stack(ii+1).charge(1).q);
            
            
            [p1] = sscanf(stack_mol.stack(ii).position,'[%d %d %d]');
            [p2] = sscanf(stack_mol.stack(ii+1).position,'[%d %d %d]');
            P_map(p1(2)+1,p1(3)+1) = P;
            P_map(p2(2)+1,p2(3)+1) = P;
            
            
        end
        
        map = [1 0 0; 0.5 0 0; 0 0 0; 0 0 0.5; 0 0 1];
        fig_3 = figure(3*ii-3), hold on
        imagesc(P_map)
        colorbar
        colormap(map)
        caxis([-1 1])
        axis equal
        
    end
    
    if settings.plot_3dfig ==1
            %WARNING: x-z axis are swapped
            
        %charge plot function
        [c_x,c_y,c_z] = sphere();
        plotCharge = @(q,x,y,z,col) surface(2*c_z*abs(q) + z,2*c_y*abs(q) + y,2*c_x*abs(q) + x,'FaceColor',col, 'EdgeColor', 'none');

        %Offset for displaying text on plots
        textOffset = 2;

        %Figure definition
        fig_2 = figure(3*ii-1), hold on, grid on
        set(gca, 'Projection','perspective'), view(-45,25)
        axis equal, axis vis3d, view(-40,50)
        xlabel('Z direction'); ylabel('Y direction'); zlabel('X direction');
        set(gca,'zdir','reverse') 
        set(gca,'ydir','reverse') 

        draw_association = [1 3; 2 3; 3 4];%debug

        %base sphere

        
        %plot molecules
        for ii=1:stack_mol.num

            %plot connections
            n_connections = length(draw_association(:,1));
            for cncn =1:n_connections
                plot3([stack_mol.stack(ii).charge(draw_association(cncn,1)).z stack_mol.stack(ii).charge(draw_association(cncn,2)).z],...
                    [stack_mol.stack(ii).charge(draw_association(cncn,1)).y stack_mol.stack(ii).charge(draw_association(cncn,2)).y],...
                    [stack_mol.stack(ii).charge(draw_association(cncn,1)).x stack_mol.stack(ii).charge(draw_association(cncn,2)).x],...
                    'k','LineWidth',3);
            end

            %plot charges
            n_charge = length(stack_mol.stack(ii).charge);
            for cc=1:n_charge
                if cc==1
                    plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'r');
                elseif cc==2
                    plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'g');
                else
                    plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'k');
                end
            end

            %plot names
            if settings.plot_molnum==1
                text(stack_mol.stack(ii).charge(n_charge).z-textOffset,...
                    stack_mol.stack(ii).charge(n_charge).y-textOffset,...
                    stack_mol.stack(ii).charge(n_charge).x-textOffset,stack_mol.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10); 
            end

        end

        %plot drivers
        for ii=1:stack_driver.num

            %plot connections
            n_connections = length(draw_association(:,1));
            for cncn =1:n_connections
                plot3([stack_driver.stack(ii).charge(draw_association(cncn,1)).z stack_driver.stack(ii).charge(draw_association(cncn,2)).z],...
                    [stack_driver.stack(ii).charge(draw_association(cncn,1)).y stack_driver.stack(ii).charge(draw_association(cncn,2)).y],...
                    [stack_driver.stack(ii).charge(draw_association(cncn,1)).x stack_driver.stack(ii).charge(draw_association(cncn,2)).x],...
                    'b','LineWidth',3);
            end

            %plot charges
            n_charge = length(stack_driver.stack(ii).charge);
            for cc=1:n_charge
                if cc==1
                    plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'r');
                elseif cc==2
                    plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'g');
                else
                    plotCharge(stack_mol.stack(ii).charge(cc).q,stack_mol.stack(ii).charge(cc).x,stack_mol.stack(ii).charge(cc).y,stack_mol.stack(ii).charge(cc).z,'k');
                end
            end

            %plot names
            if settings.plot_molnum==1
                text(stack_driver.stack(ii).charge(n_charge).z-textOffset,...
                    stack_driver.stack(ii).charge(n_charge).y-textOffset,...
                    stack_driver.stack(ii).charge(n_charge).x-textOffset,stack_driver.stack(ii).identifier,'HorizontalAlignment','center','FontSize',10); 
            end

        end

    end
% % %     
% % %     %%%%%%%%%%%
% % % Charge_on_wire_done = Charge_on_wire_done_set;
% % % 
% % % 
    if settings.plot_chargeFig==1

        fig_1 = figure(3*ii-2);
        plot(Charge_on_wire_done_set(:,1)',Charge_on_wire_done_set(:,2)','b--*',Charge_on_wire_done_set(:,1)',Charge_on_wire_done_set(:,3),'r--*','Linewidth',4,'MarkerSize',10);
        grid on;
        axis([0 stack_mol.num+1 -0.2 1.2])
        legend('Dot1','Dot2');
        title('Charge distribution along wire for static clock assignment');
        xlabel('Molecule number along the wire');
        ylabel('Aggregated charge distribution Dot1 & Dot2'); 

    end
% % % 
% % % 
% % % 
% % % %fprintf('Step %i : Interaction 1.\n',step)
% % % % 
% % % for i=1:stack_mol.num
% % %    charge_mol(i).molecule=[stack_mol.stack(i).charge(1).x, stack_mol.stack(i).charge(1).y, stack_mol.stack(i).charge(1).z, Charge_on_wire_done(i,2);
% % %                            stack_mol.stack(i).charge(2).x, stack_mol.stack(i).charge(2).y, stack_mol.stack(i).charge(2).z, Charge_on_wire_done(i,3);
% % %                            stack_mol.stack(i).charge(3).x, stack_mol.stack(i).charge(3).y, stack_mol.stack(i).charge(3).z, Charge_on_wire_done(i,4);
% % %                            stack_mol.stack(i).charge(4).x, stack_mol.stack(i).charge(4).y, stack_mol.stack(i).charge(4).z, Charge_on_wire_done(i,5)];
% % %    charge_mol(i).name = stack_mol.stack(i).identifier;
% % % end
% % % for i=1:stack_driver.num
% % %    charge_dr(i).driver = [stack_driver.stack(i).charge(1).x, stack_driver.stack(i).charge(1).y, stack_driver.stack(i).charge(1).z, stack_driver.stack(i).charge(1).q;
% % %                           stack_driver.stack(i).charge(2).x, stack_driver.stack(i).charge(2).y, stack_driver.stack(i).charge(2).z, stack_driver.stack(i).charge(2).q;
% % %                           stack_driver.stack(i).charge(3).x, stack_driver.stack(i).charge(3).y, stack_driver.stack(i).charge(3).z, stack_driver.stack(i).charge(3).q;
% % %                           stack_driver.stack(i).charge(4).x, stack_driver.stack(i).charge(4).y, stack_driver.stack(i).charge(4).z, stack_driver.stack(i).charge(4).q];
% % % 
% % %    charge_dr(i).name = stack_driver.stack(i).identifier;
% % % end
% % % 
% % % [x,y,z] = sphere;  %# Coordinate data for sphere
% % % 
% % % fig_2 = figure(3*ii-1)
% % % for i = 1:size(charge_mol,2)
% % %     for l = 1:4
% % %           c = 2*charge_mol(i).molecule(l,4);	%# Scale factor for sphere
% % %           Z = z.*c+charge_mol(i).molecule(l,3);     %# New Z coordinates for sphere
% % %           X = x.*c+charge_mol(i).molecule(l,1);     %# New X coordinates for sphere
% % %           Y = y.*c+charge_mol(i).molecule(l,2);     %# New Y coordinates for sphere
% % % 
% % %           dot1_2 = [charge_mol(i).molecule(1,1), charge_mol(i).molecule(1,2), charge_mol(i).molecule(1,3);
% % %                     charge_mol(i).molecule(2,1), charge_mol(i).molecule(2,2), charge_mol(i).molecule(2,3)];
% % %           dot3_4 =  [charge_mol(i).molecule(3,1), charge_mol(i).molecule(3,2), charge_mol(i).molecule(3,3);
% % %                      charge_mol(i).molecule(4,1), charge_mol(i).molecule(4,2), charge_mol(i).molecule(4,3)];
% % %           plot3(dot1_2(:,3), dot1_2(:,2), -dot1_2(:,1),'Color', 'k','LineWidth',2);
% % %           plot3(dot3_4(:,3), dot3_4(:,2), -dot3_4(:,1),'Color', 'k','LineWidth',2);
% % %           x_average = (dot1_2(1,1)+dot1_2(2,1))/2;
% % %           y_average = (dot1_2(1,2)+dot1_2(2,2))/2;
% % %           z_average = (dot1_2(1,3)+dot1_2(2,3))/2;
% % %           dot12_3 = [x_average, y_average, z_average;
% % %                      charge_mol(i).molecule(3,1), charge_mol(i).molecule(3,2), charge_mol(i).molecule(3,3)];
% % %           plot3(dot12_3(:,3), dot12_3(:,2), -dot12_3(:,1),'Color', 'k','LineWidth',2);
% % %            
% % % %            txt = charge_mol(i).name;
% % % %            text(dot12_3(1,1)-1,dot12_3(1,2),dot12_3(1,3),strcat('Mol',int2str(txt)),'HorizontalAlignment','center','FontSize',10);
% % % %           
% % %           if(l==1)
% % %                 surface(Z,Y,-X,'FaceColor','r', 'EdgeColor', 'none');  %# Plot sphere
% % %           elseif(l==2)
% % %                 surface(Z,Y,-X,'FaceColor','g', 'EdgeColor', 'none');  %# Plot sphere
% % %           elseif (l==3)
% % %                 surface(Z,Y,-X,'FaceColor','y', 'EdgeColor', 'none');  %# Plot sphere
% % %           else
% % %                surface(Z,Y,-X,'FaceColor','b', 'EdgeColor', 'none');  %# Plot sphere
% % %                if settings.plot_molnum==1
% % %                 text(mean(mean(Z)),mean(mean(Y)),mean(mean(-X)),strcat('Mol: ',int2str(i)),'HorizontalAlignment','center','FontSize',10);
% % %                end
% % %           end
% % %           hold on;
% % %     end 
% % % end
% % % 
% % % for i = 1:size(charge_dr,2)
% % %     for l = 1:4
% % %           c = 2*charge_dr(i).driver(l,4);	%# Scale factor for sphere
% % %           Z = z.*c+charge_dr(i).driver(l,3);     %# New Z coordinates for sphere
% % %           X = x.*c+charge_dr(i).driver(l,1);     %# New X coordinates for sphere
% % %           Y = y.*c+charge_dr(i).driver(l,2);     %# New Y coordinates for sphere 
% % %           surface(Z,Y,-X,'FaceColor','k', 'EdgeColor', 'none');  %# Plot sphere
% % % 
% % %           dot1_2 = [charge_dr(i).driver(1,1), charge_dr(i).driver(1,2), charge_dr(i).driver(1,3); 
% % %                     charge_dr(i).driver(2,1), charge_dr(i).driver(2,2), charge_dr(i).driver(2,3)];
% % %           dot3_4 = [charge_dr(i).driver(3,1), charge_dr(i).driver(3,2), charge_dr(i).driver(3,3); 
% % %                     charge_dr(i).driver(4,1), charge_dr(i).driver(4,2), charge_dr(i).driver(4,3)];
% % %           plot3(dot1_2(:,3), dot1_2(:,2), -dot1_2(:,1),'Color', 'k','LineWidth',2);
% % %           plot3(dot3_4(:,3), dot3_4(:,2), -dot3_4(:,1),'Color', 'k','LineWidth',2);
% % %           x_average = (dot1_2(1,1)+dot1_2(2,1))/2;
% % %           y_average = (dot1_2(1,2)+dot1_2(2,2))/2;
% % %           z_average = (dot1_2(1,3)+dot1_2(2,3))/2;
% % %           dot12_3 = [x_average, y_average, z_average;
% % %                      charge_dr(i).driver(3,1), charge_dr(i).driver(3,2), charge_dr(i).driver(3,3)];
% % %           plot3(dot12_3(:,3), dot12_3(:,2), -dot12_3(:,1),'Color', 'k','LineWidth',2);
% % %           hold on  
% % % %           txt = charge_dr(i).name;
% % % %           text(dot12_3(1,1)-1,dot12_3(1,2),dot12_3(1,3),txt,'HorizontalAlignment','center','FontSize',10);
% % %     end
% % %    
% % % end
% % % grid on
% % % axis equal
% % % zlim([-14 8])
% % % zoom off
% % % xlabel('Z direction');
% % % ylabel('Y direction');
% % % zlabel('-X direction');
% % % 
% % % 
% % % % fig_3 = figure(3*ii)
% % % % for i = 1:size(charge_mol,2)
% % % %     for l =1:4
% % % %         c = charge_mol(i).molecule(l,4);	%# Scale factor for sphere
% % % %         Z = charge_mol(i).molecule(l,3);     %# New Z coordinates for sphere
% % % %         X = charge_mol(i).molecule(l,1);     %# New X coordinates for sphere
% % % %         Y = charge_mol(i).molecule(l,2);     %# New Y coordinates for sphere
% % % %         
% % % %         dot1_2 = [charge_mol(i).molecule(1,1), charge_mol(i).molecule(1,2), charge_mol(i).molecule(1,3);
% % % %                   charge_mol(i).molecule(2,1), charge_mol(i).molecule(2,2), charge_mol(i).molecule(2,3)];   
% % % %         if(l==1)
% % % %             plot(Z, Y, '.r', 'MarkerSize',c*40);
% % % %             if ii == 5000
% % % %                 tmp = strsplit(charge_mol(i).name{1},'_');
% % % %                 space = '\_';
% % % %                 txt = strcat(tmp(1),space,tmp(2));
% % % %                 num = str2num(tmp{2});
% % % %                 if num==1 || num==2 || num==3 || num==4 || num==5 || num==6 || num==23 || num==24 || num==25 || num==26 || num==22 || num==21
% % % %                     text(Z-3.3, Y ,tmp(2),'HorizontalAlignment','center','FontSize',10);
% % % %                 else
% % % %                     text(Z, Y-2.5 ,tmp(2),'HorizontalAlignment','center','FontSize',10);
% % % %                 end
% % % %             end
% % % %         elseif(l==2)
% % % %             plot(Z, Y, '.g', 'MarkerSize',c*40);
% % % %         elseif (l==4)
% % % %             plot(Z, Y, '.b', 'MarkerSize',c*40);
% % % %         end
% % % %         line([dot1_2(1,3), dot1_2(2,3)],[dot1_2(1,2), dot1_2(2,2)], 'Color', 'k', 'LineWidth', 2)  
% % % %         hold on;
% % % %     end         
% % % % end
% % % % 
% % % % for i = 1:size(charge_dr,2)
% % % %     for l =1:4
% % % %         c = charge_dr(i).driver(l,4);	%# Scale factor for sphere
% % % %         Z = charge_dr(i).driver(l,3);     %# New Z coordinates for sphere
% % % %         X = charge_dr(i).driver(l,1);     %# New X coordinates for sphere
% % % %         Y = charge_dr(i).driver(l,2);     %# New Y coordinates for sphere
% % % %         
% % % %         dot1_2 = [charge_dr(i).driver(1,1), charge_dr(i).driver(1,2), charge_dr(i).driver(1,3);
% % % %                   charge_dr(i).driver(2,1), charge_dr(i).driver(2,2), charge_dr(i).driver(2,3)];
% % % %         if c~=0
% % % %             if(l==1)
% % % %                 plot(Z, Y, '.k', 'MarkerSize',c*40);
% % % %             elseif(l==2)
% % % %                 plot(Z, Y, '.k', 'MarkerSize',c*40);
% % % %             elseif (l==4)
% % % %                 plot(Z, Y, '.k', 'MarkerSize',c*40);
% % % %             end
% % % %         end
% % % %         if ii == 5000 && l==1
% % % %             if strcmp(charge_dr(i).name{1}, 'Dr1') || strcmp(charge_dr(i).name{1}, 'Dr3') ||strcmp(charge_dr(i).name{1}, 'Dr6')
% % % %                 text(Z-5, Y ,charge_dr(i).name{1},'HorizontalAlignment','center','FontSize',10);
% % % %             else
% % % %                 text(Z, Y-2.5 ,charge_dr(i).name{1},'HorizontalAlignment','center','FontSize',10);
% % % %             end
% % % %         end
% % % %         line([dot1_2(1,3), dot1_2(2,3)],[dot1_2(1,2), dot1_2(2,2)], 'Color', 'k', 'LineWidth', 2)    
% % % %         hold on;
% % % %     end
% % % % end
% % % 
% % % 
% % % % xlim([20 140]);
% % % % ylim([-2 +135]);
% % % % axis equal
% % % % axis off



if strcmp(settings.fig_saver,'yes')
    
    %manage figure folder
    if exist('FIGURE') == 7 && ii==1 % ==7 beacuse the function 'exist' used for directory has as output 7
        delete('FIGURE/*');  % delete its content 
    else
        mkdir('FIGURE');     % if not present. It is created.
    end
    
    disp('Fig_saver is currently disabled')
    %save figures
%     saveas(fig_1,sprintf('FIGURE/FIG_3D_%d',ii),'png')
%     saveas(fig_2,sprintf('FIGURE/FIG_charge_%d',ii),'png')
%     saveas(fig_1,sprintf('FIGURE/FIG_3D_%d',ii),'epsc2')
%     saveas(fig_2,sprintf('FIGURE/FIG_charge_%d',ii),'epsc2')
end

end

if settings.plot_voltage==1
    figure(500000),hold on, grid on, grid minor
    title('Input Voltage on each molecule');
    xlabel('Molecule number'), ylabel('Input Voltage [V]')
    plot(Vout)
end

drawnow

end

