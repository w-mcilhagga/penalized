% REPLICATION - a GUI to let user choose what to replicate.

choice = menu('Replicate:', 'the tutorial', 'the figures only', ...
    'table 1', 'penalty demos', 'more penalty demos');

% check installation
try
    check_install
catch
    if strcmp(questdlg('Install penalized toolbox now?'),'Yes')
        install_penalized
    end
end

switch (choice)
    case 1
        echodemo jsstutorial
    case 2
        uiwait(warndlg('You will need R to plot the final figure'))
        jssfigures
    case 3
        uiwait(warndlg('You will need R to do some of the timings'))
        table_entry
    case 4
        penaltydemo1
    case 5
        penaltydemo2
end