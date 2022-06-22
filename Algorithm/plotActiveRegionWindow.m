function [] = plotActiveRegionWindow(molNumber,activeMolecules,activeListMolecule,voltageVariation,activeRegionThreshold)

plot_activeMol = zeros(1,molNumber);
plot_activeMol(activeMolecules) = 0.05;
mask_activeMol = logical(plot_activeMol(:).');

plot_evaluationMol = zeros(1,molNumber);
%                 plot_evaluationMol(find(activeListMolecule==1)) = 1;
plot_evaluationMol(activeListMolecule==1) = 0.05;
mask_evaluationMol = logical(plot_evaluationMol(:).');

figure(2000000), clf, hold on, grid on
    plot(1:molNumber,voltageVariation,'b','LineWidth',2)
    plot([1 molNumber], [activeRegionThreshold activeRegionThreshold],'r--','LineWidth',2)
%     plot(1:molNumber, plot_activeMol)
%     plot(1:molNumber, plot_evaluationMol)

    % Make patch of transparent color for activeMol
    if any(mask_activeMol)
        yl = ylim;
        starts = strfind([false, mask_activeMol], [0 1]);
        stops = strfind([mask_activeMol, false], [1 0]);
        xBox = [starts;stops]; xBox = xBox(:)'; xBox = repelem(xBox,2);
        yBox = repmat([yl(1) yl(2) yl(2) yl(1)],1,length(starts));
        patch(xBox, yBox, 'black' ,'FaceColor', 'green', 'FaceAlpha', 0.1);
        legend('Voltage variation','Threshold','Active','Evaluation')
    else
        legend('Voltage variation','Threshold')
    end
    
    % Make patch of transparent color for evaluationMol
    if any(mask_evaluationMol)
        yl = ylim;
        starts = strfind([false, mask_evaluationMol], [0 1]);
        stops = strfind([mask_evaluationMol, false], [1 0]);
        xBox = [starts;stops]; xBox = xBox(:)'; xBox = repelem(xBox,2);
        yBox = repmat([yl(1) yl(2) yl(2) yl(1)],1,length(starts));
        patch(xBox, yBox, 'black' ,'FaceColor', 'yellow', 'FaceAlpha', 0.1);
        legend('Voltage variation','Threshold','Active','Evaluation')
    else
        legend('Voltage variation','Threshold')
    end

    xlabel('Molecule Number')
    ylabel('Voltage [V]')
    drawnow
end