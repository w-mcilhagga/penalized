function [fit fit2 model] = table_entry_dofit(rpath, probno, modtype, rho, treps, intercept, standardize)
% Generate one entry in Table 1 depending on model, size
% The parameters are supplied by table_entry

% move to correct directory
curdir = pwd;
cd(fileparts([mfilename('fullpath'),'.m']))

% choose the problem
problemsize = [1000 100;
    5000 100;
    10000 100;
    100000 100;
    100 1000;
    100 5000;
    100 10000];

n = problemsize(probno,1);
p = problemsize(probno,2);

% choose the model
if modtype==4
    ncat = input('Number of categories: ');
end
if intercept
    option='';
else
    option='nointercept';
end
option
% run comparison

% initialize the elapsed times
glmnet_time = 0;
penalized_time = 0;

fprintf('reps: ');
for i=1:treps
    % generate the problem
    switch modtype
        case 1 % logistic
            count = 1+ceil(rand(n,1)*4);
            [y,X,truebeta,count] = genmodel(n,p,'logistic','rho',rho,'count',count);
            model = glm_logistic([y,count],X,option);
            y = [count-y,y]; % for glmnet
            type = 'binomial';
        case 2 % gaussian
            [y,X,truebeta] = genmodel(n,p,'gaussian','rho',rho);
            model = glm_gaussian(y,X,option);
            type = 'gaussian';
        case 3 % poisson
            [y,X,truebeta] = genmodel(n,p,'poisson','rho',rho);
            model = glm_poisson(y,X,option);
            type = 'poisson';
        case 4 % multinomial
            count = 1+ceil(rand(n,1)*4);
            p = round(p/ncat);
            [y,X,truebeta] = genmodel(n,p,'multi','rho',rho,'count',count,'categories',ncat);
            model = glm_multinomial(y,X,option);
            type='multinomial';
    end
    fprintf('%3d ',i);

    % Run glmnet from R
    alpha = 1; % the elastic glmnet parameter 1 means L1, 0 means L2, intermediate is a mix.
    nlambda = 100;

    clear fit
    if exist('rpath','var')
        save temp.mat X y alpha nlambda type intercept standardize
        delete('tempout.*');
        cmd = sprintf('"%s"  CMD BATCH run_glmnet.R',rpath);
        [status,result] = system(cmd);

        % retrieve glmnet results
        fit = load('tempout.mat');
        fit.dev = fit.dev';
        fit.lambda = fit.lambda';
        fit.df = double(fit.df)';
        fit.elapsed = fit.elapsed(3);
        fit.intercept=[];
        glmnet_time = glmnet_time + fit.elapsed;
    end

    % run penalized - this uses the same lambda series as glmnet
    % for a fair comparison of algorithm speed.
    tic
    if exist('rpath','var')
        fit2 = penalized(model,@p_lasso,'lambda',fit.lambda,...
            'forcelambda',true,'standardize',standardize);
    else
        fit2 = penalized(model,@p_lasso,'standardize',standardize);
    end
    penalized_time = penalized_time+toc;
end

% plot last example as comparison
plot_penalized(fit2); 
if exist('fit','var') 
    hold on 
    plot_penalized(fit,'symbol','.'); 
    hold off
end
title('Comparison of glmnet (.) & penalized (-) coefficients: last rep')


fprintf('\n\n%s  n=%4d  p=%4d  glmnet: %10.4f  penalized %10.4f\n',...
    type,n,p,glmnet_time/treps,penalized_time/treps)


cd(curdir)
