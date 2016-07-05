% Generate one entry in Table 1 depending on model, size

% find the path to R
rpath = 'E:\Program Files\R\R-3.0.0\bin\R.exe';
if ~exist(rpath,'file')
    [fname, pathname] = uigetfile({'*.*'}, 'Find R executable (cancel if none)');
    if fname~=0
        rpath = [pathname,fname];
    else
        msgbox('Sorry, R is needed to generate table entries')
        return
    end
end

probno = menu('Choose n,p from the the table column', ...
    'n=1000, p=100', 'n=5000, p=100', 'n=10000, p=100', 'n=100000, p=100', ...
    'n=100, p=1000', 'n=100, p=5000', 'n=100, p=10000');

% choose the model
modtype = menu('Choose the model type', ...
    'logistic', 'gaussian', 'poisson', 'multinomial');
% The following lines set parameters as used in the table. 
% change them if you want.
rho    = 0; %input('rho (correlation between X columns): ');
treps  = 15; %input('Number of repeats: ');
intercept = false; %input('Intercept (true or false)? ');
standardize = false; %input('Standardize (true or false)? ');

[fit fit2 model] = table_entry_dofit(rpath, probno, modtype, rho, treps, intercept, standardize);