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
function SCERPA(command,option1,option2,option3)
    
    
    %No command error: automatically show "help"
    if ~exist('command','var')
         error('[ERROR][001] Missing command! SCERPA does not know what to do...')
    end

    % commands
    switch command

        case char('help') % Open help file
            edit(fullfile('README.md'))

        case char('generate') % Generate SCERPA Layout files
            close all
            if exist('option1','var')
                disp('Generating SCERPA layout!')
                cd Layout
                GenerateLayoutFile(option1);
                cd ..
            else
                error('[ERROR][002] Missing circuit.')
            end

        case char('launch') % Launch SCERPA simulation (use available layout)
            disp('Launching SCERPA!')
            cd Algorithm
            if exist('option1','var')
                ScerpaRun(option1);
            else
                ScerpaRun();
                warning('Default settings')
            end
            cd ..
            %open log file
%             open('../OUTPUT_FILES/Simulation_Output.log')
        
        case char('plotSteps')
            %close all
            disp('Plotting Results!')
            cd Viewer
            if exist('option1','var')
                SCERPAPlotSteps(option1)
            else
                SCERPAPlotSteps();
                warning('Default plot settings')
            end
            cd ..
        
        case char('topoLaunch') %retrocompatibility
            if exist('option1','var')
                option1.magcadImporter = 1;
                SCERPA('generate', option1);
                if exist('option2','var')
                    SCERPA('launch',option2);
                else
                    SCERPA('launch');
                end
            else
                error('[ERROR][002] Missing circuit.')
            end

        case('generateLaunch') %generate and launch
            if exist('option1','var')
                SCERPA('generate', option1);
                if exist('option2','var')
                    %option2.circuit = option1; %pass things which are not managed by the layour generator directly to scerpa (compatibility)
                    SCERPA('launch',option2);
                else
                    SCERPA('launch');
                end
            else
                error('[ERROR][002] Missing circuit.')
            end

        case('generateLaunchView') %generate and launch
            if exist('option1','var') 
                if exist('option2','var') && exist('option3','var')
                    SCERPA('generateLaunch',option1,option2);
                    SCERPA('plotSteps',option3);
                elseif ~exist('option2','var') && exist('option3','var')
                    SCERPA('generateLaunch',option1);
                    SCERPA('plotSteps',option3);
                elseif exist('option2','var') && ~exist('option3','var')
                    SCERPA('generateLaunch',option1,option2);
                    SCERPA('plotSteps',option3);
                end
            else
                error('[ERROR][002] Missing circuit.')
            end
        
        otherwise
            error('[ERROR][003] Command not valid!')
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

