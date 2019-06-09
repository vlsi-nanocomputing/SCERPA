function [status] = SCERPA(command,option1,option2)

    %No command error: automatically show "help"
    if ~exist('command','var')
         disp('[ERROR] No command! SCERPA does not know what to do...')
         return
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
            cd ..
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
        case char('help') % Open help file
            edit(fullfile('Layout','inputSample.m'))
        otherwise
            disp('Command not valid!')
    end
end
