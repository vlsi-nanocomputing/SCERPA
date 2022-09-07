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

    warning off backtrace
    
    %No command error
    if ~exist('command','var')
         error("[ERROR][001] Missing command! SCERPA does not know what to do. Type SCERPA('help') to open the documentation." )
    end

    % commands
    switch command

        case char('help') % Open help file
            open(fullfile('Documentation','SCERPA_documentation.pdf'))

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
        
        case char('plotSteps')
            disp('Plotting Results!')
            cd Viewer
            if exist('option1','var')
                SCERPAPlotSteps(option1)
            else
                SCERPAPlotSteps();
                warning('Default plot settings')
            end
            cd ..
        
        case('generateLaunch') %generate and launch
            if exist('option1','var')
                SCERPA('generate', option1);
                if exist('option2','var')
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
            error("[ERROR][003] Command not valid! Type SCERPA('help') to open the documentation.")
    end

    warning on backtrace
end

