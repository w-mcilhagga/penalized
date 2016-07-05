% PENALIZED TOOLBOX - a set of m-files for penalized model fitting.
% 
% Functions:----------------------------------------
%
% install_penalized   - sets up the necessary paths. Use this first.
% uninstall_penalized - removes the toolbox paths from the Matlab path.
% 
% penalized    - the main penalized fitting function
% plot_penalized    - plot the output of penalized
% cv_penalized - cross validation of penalized fits
% plot_cv_penalized - plot the output of cv_penalized
% 
% goodness_of_fit - returns a goodness of fit measure (deviance, aic, bic, 
%                   etc) as a function of the lambda parameter.
%
% replication - this m file lets you replicate the tutorial, figures, or table 1
%            from the paper. It also lets you run two penalty demos.
%
% Directories:--------------------------------------
%
% models    - directory containing the generalized linear models
%             Type 'help models' for more information
% penalties - directory containing the penalty functions
%             Type 'help penalties' for more information
% jss       - directory containing code to replicate figures, table in jss
%             article
% internals - a couple of functions used by penalized.
% helpfiles - help for the fit structure and options. Type 'help fit' or 
%             'help options' to view.