function [fit,opts] = penalized(model,penalty,varargin)
% PENALIZED   Fit a maximum likelihood model with a penalty.
% penalized finds the coefficients beta which maximizes
%
%    logL(model,beta)/nobs - sum(lambda*wt*penalty(beta,p))
%
% over a range of values of lambda and, possibly, penalty parameter p.
%
% Usage:
%  [fit,opts] = penalized(model,penalty, ...)
%
% Inputs:
%   model   : a model object. Type "help model" for details. 
%   penalty : a function handle. Type "help penalty" for details. 
%   ...     : the remaining arguments are either a series of option, value 
%             pairs or a structure containing option,value pairs. For a 
%             full list of the options, type "help options".
%
% Outputs:
%  fit      : a struct summarizing the fit. Type "help fit" for more information.
%  opts     : a structure holding the full set of options used. Usually not 
%             of interest.
%
% Examples:
%   fit = penalized(glm_logistic(y,X), @p_lasso )
%      -- fits an L1 penalized logistic regression (lasso).
%
%   fit = penalized(glm_logistic(y,X), @p_lasso, 'standardized', true )
%      -- fits an L1 penalized logistic regression (lasso). Columns of the
%         logistic model are standardized.
%
%   fit = penalized(glm_logistic(y,X), @p_flash, 'delta', 0.5 )
%      -- fits a FLASH penalized logistic model to data y, X with flash
%         parameter 'delta' equal to 0.5.
%
%   fit = penalized(glm_gaussian(y,X), @p_Lq, 'q', 1:-0.1:0 )
%      --  fits an Lq penalized linear regression model, with penalty
%          parameter 'q' ranging from 1 (lasso) to 0 (L0 norm). 
%
% See also MODELS PENALTIES FIT OPTIONS 


% Copyright © 2014 William McIlhagga, william.mcilhagga@gmail.com
%
% This file is part of the PENALIZED toolbox.
% 
% The PENALIZED toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% The PENALIZED toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with the PENALIZED toolbox.  If not, see <http://www.gnu.org/licenses/>.


%% INITIALIZATION  

opts = setoptions(model,varargin);
[fit,paramname] = initoutput(model,opts);
opts.devchange  = opts.thresh*(fit.nulldev+1e-5);

if ~isempty(paramname)
    value = opts.(paramname);
    opts.(paramname)= value(1); % set the first penalty parameter value 
else
    value=[];
end

% check for standardize
if opts.standardize
    colscale = property(model,'colscale');
    opts.betascale = colscale(:)/mean(colscale);
end

% compute lambda sequence -------------------------------------------------

beta  = initial(model);
n = property(model,'n'); 
nobs = property(model,'nobs');

if isempty(opts.lambda)
    if isfield(opts,'lambdamax')
        init_lambda = opts.lambdamax;
    else
        [l,m,D,V,J] = scoring(model,beta);
        grad = J'*(D.*m/nobs);
        init_lambda = checksubgrad(grad,penalty,beta,[],opts);
    end
    opts.lambda = logspace(log10(init_lambda),...
        log10(init_lambda*opts.lambdaminratio),opts.nlambda);
end


%% MAXIMIZE OVER LAMBDA, WITH PENALTY PARAM SET TO VALUE(1).

% We also check for convergence wrt lambda in the first fit.
% Note, opts.(paramname) was set earlier to value(1) if more than one value,
% so don't need to set it again.

olddev = inf;
maximizer = opts.maximizer; % This feature lets you swap in new algorithms if you want.

for i=1:length(opts.lambda)
    
    % fit the model for the given lambda, penalty
    [beta,fval,pen,grad,flag] = maximizer(model, beta, opts.lambda(i), penalty, opts);
    
    % calculate new deviance
    logl = nobs*(fval + pen);
    dev  = -2*(logl - fit.sat);

    % update output structure
    fit.beta   = [fit.beta,beta];
    fit.lambda = [fit.lambda,opts.lambda(i)];
    fit.nz     = [fit.nz;sum(beta~=0)];
    fit.devratio = [fit.devratio;1-dev/fit.nulldev];

    % Check various convergence/fault conditions

    if strcmp(flag,'empty workset') || opts.forcelambda
        continue % to next lambda value, skipping checks below
    end 
    
    if sum(beta~=0)>opts.pmax
        flag = 'Maximum number of variables exceeded';
        break;
    end
    
    if fit.devratio(end)>0.99
        flag = 'deviance ratio near 1';
        break;
    end
    
    if abs(dev-olddev)<opts.fdev*abs(dev)
        % look to see if any future coefficients might appear, otherwise
        % not safe to declare convergence.
        p = checksubgrad(grad,penalty,beta,opts.lambda(end),opts);
        if all(p==0)
            flag = 'deviance converged';
            break;
        end
    end
    
    olddev = dev;

end % loop over lambda    

fit.flag = flag;

%% MAXIMIZE OVER REMAINING LAMBDA/PENALTY PARAM COMBINATIONS 

initbeta = initial(model);

for i=2:length(value)
    % set the current value in opts.
    opts.(paramname)=value(i);
    
    for j=1:length(fit.lambda)
        switch opts.warmstart
            case 'relax' % warm start is previous penalty parameter
                [beta,fval,pen] = maximizer(model, fit.beta(:,j,i-1), fit.lambda(j), penalty, opts);
            case 'lambda' % warm start is previous lambda
                if j==1, warmstart=initbeta; else warmstart=fit.beta(:,j-1,i); end
                [beta,fval,pen] = maximizer(model, warmstart, fit.lambda(j), penalty, opts);
            case 'best' 
                % try 'relax' warmstart
                [beta1,fval1,pen1] = maximizer(model, fit.beta(:,j,i-1), fit.lambda(j), penalty, opts);
                % try 'lambda' warmstart
                if j==1, warmstart=initbeta; else warmstart=fit.beta(:,j-1,i); end
                [beta2,fval2,pen2] = maximizer(model, warmstart, fit.lambda(j), penalty, opts);
                % pick the best
                if fval1>fval2
                    beta = beta1; fval = fval1; pen = pen1; 
                else
                    beta = beta2; fval = fval2; pen = pen2;
                end
        end
        % calculate new deviance
        logl = nobs*(fval + pen);
        dev  = -2*(logl - fit.sat);           
        % update output structure
        fit.beta(:,j,i) = beta;
        fit.nz(j,i)     = sum(beta~=0);
        fit.devratio(j,i) = 1-dev/fit.nulldev;
    end
    
end

%% FINISH UP

% need to restore opts.(paramname) to original value.
if length(value)>1
    opts.(paramname) = value;
end

% get the intercept if any
fit.intercept = property(model,'intercept');


%% SUBFUNCTIONS

function [fit,paramname] = initoutput(model,opts)
% initializes the fit structure and finds the paramname of the relaxer parameter

fit = struct('beta',[],'nz',[],'devratio',[],'lambda',[],...
    'intercept',property(model,'intercept'));
fit.sat     = logL(model,'saturated');
fit.nulldev = -2*(logL(model,'null') - fit.sat);

% copy nonstandard options to fit & find penalty parameter array.
fn = fieldnames(opts);
presets = {'coreiter','trustiter','trustrgn','nlambda','lambda','fdev',...
    'penaltywt','maxnewvars','forcelambda','warmstart','betascale',...
    'maximizer','lambdaminratio','thresh','pmax','standardize','betathresh'};
paramname = '';
for i=1:length(fn)
    if ~strfound(fn{i},presets)
        fit.(fn{i})=opts.(fn{i});
        if isempty(paramname) && isnumeric(opts.(fn{i})) && length(opts.(fn{i}))>1
            % found the relaxer
            paramname = fn{i};
            fit.relax = paramname;
        end
    end
end
    
% -------------------------------------------------------------------------

function opts = setoptions(model,args)
% initializes the opts structure

if isempty(args)
    options = struct;
elseif length(args)==1
    if ~isstruct(args{1}), error('Expected a struct as third argument to penalized'); end
    options = args{1}; 
elseif length(args)>1,  
    options=struct;
    for i=1:2:length(args)
        options.(args{i})=args{i+1};
    end
end

props = property(model);
n = props.n;
p = props.p;
opts  = struct('coreiter',30,'trustiter',10,'trustrgn',0.1,...
    'nlambda',100,'lambda',[],'fdev',1e-5,'penaltywt',1,'betascale',1,...
    'maxnewvars',3,'forcelambda',false,'standardize',false,...
    'warmstart','relax','pmax',p+1,'maximizer',@fisher,'betathresh',2.5e-4);

% augment opts with model-specific values
if n>p
    opts.thresh = 1e-5;
    opts.lambdaminratio = 0.0001;
else
    opts.thresh = 1e-8;
    opts.lambdaminratio = 0.01;
    opts.maxnewvars = 1;
end

% fields in options override fields in opts
f = fieldnames(options);
for i=1:length(f)
    opts.(f{i})=options.(f{i});
end

% check new vars is ok
opts.maxnewvars = min(opts.maxnewvars,p);

% create penalty weighting vector, with intercept wt set to zero
wt = ones(p,1);
wt(props.intercept)=0;
if length(opts.penaltywt)==length(wt)
    opts.penaltywt = wt.*opts.penaltywt(:); 
else
    wt(2:end) = wt(2:end).*opts.penaltywt(:); % assume intercept left out
    opts.penaltywt = wt; 
end    
