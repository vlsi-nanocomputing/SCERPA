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
function [status] = SCERPA(command,option1,option2,option3)
    
    option1.pathList = config('internal');
    option2.pathList = option1.pathList;
    option3.pathList = option1.pathList;
   

    %No command error: automatically show "help"
    if ~exist('command','var')
         error('[ERROR][001] Missing command! SCERPA does not know what to do...')
    end

    % commands
    switch command
        case char('launch') % Launch SCERPA simulation (use available layout)
            disp('Launching SCERPA!')
            cd Algorithm
            if exist('option1','var')
                ScerpaRun(option1);
                status = 0;
            else
                ScerpaRun();
                status = 0;
            end
            %open log file
%             open('../OUTPUT_FILES/Simulation_Output.log')
            cd ..
        case char('topoLaunch') %work in progress
            if exist('option1','var')
                option1.magcadImporter = 1;
                status = SCERPA('generate', option1);
                if status == 0
                     if exist('option2','var')
                        status = SCERPA('launch',option2);
                     else
                         status = SCERPA('launch');
                     end
                end
            else
                disp('[SCERPA ERROR] No circuit.')
                status = 1;
                return
            end
        case char('generate') % Generate SCERPA Layout files
            close all
            disp('Generating SCERPA layout!')
            cd Layout
            status = GenerateLayoutFile(option1);
            cd ..
        case('generateLaunch') %generate and launch
            if exist('option1','var')
                status = SCERPA('generate', option1);
                if status == 0
                     if exist('option2','var')
                        %option2.circuit = option1; %pass things which are not managed by the layour generator directly to scerpa (compatibility)
                        status = SCERPA('launch',option2);
                     else
                         status = SCERPA('launch');
                     end
                end
            else
                disp('[SCERPA ERROR] No circuit.')
                status = 1;
                return
            end
        case('generateLaunchView') %generate and launch
            if exist('option1','var')
                if exist('option2','var')
                    SCERPA('generateLaunch',option1,option2);
                end
            end
        case char('plotSteps')
            %close all
            disp('Plotting Results!')
            cd Viewer
            SCERPAPlotSteps(option1)
            cd ..
        case char('help') % Open help file
            edit(fullfile('Layout','inputSample.m'))
        otherwise
            disp('Command not valid!')
    end
end

function displayHeader()

    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%                                                                          %')
    disp('%       Self-Consistent Electrostatic Potential Algorithm (SCERPA)         %')
    disp('%                                                                          %')
    disp('%       VLSI Nanocomputing Research Group                                  %')
    disp('%       Dept. of Electronics and Telecommunications                        %')
    disp('%       Politecnico di Torino, Turin, Italy                                %')
    disp('%       (https://www.vlsilab.polito.it/)                                   %')
    disp('%                                                                          %')
    disp('%       People [people you may contact for info]                           %')
    disp('%         Yuri Ardesi (yuri.ardesi@polito.it)                              %')
    disp('%         Giuliana Beretta (giuliana.beretta@polito.it)                    %')
    disp('%                                                                          %')
    disp('%       Supervision: Gianluca Piccinini, Mariagrazia Graziano              %')
    disp('%                                                                          %')
    disp('%       Relevant pubblications doi: 10.1109/TCAD.2019.2960360              %')
    disp('%                                   10.1109/TVLSI.2020.3045198             %')
    disp('%                                                                          %')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

end

