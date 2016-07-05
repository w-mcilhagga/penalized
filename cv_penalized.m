function cv = cv_penalized(model, penalty, varargin)
% CV_PENALIZED works out the k-fold cross validation error for a penalized 
% regression.
%
% Usage:
%   cv = cv_penalized(model,penalty,...)
%
% Inputs:
%   model   : a model object. Type "help model" for details. 
%   penalty : a function handle. Type "help penalty" for details. 
%
%   The remaining arguments are either a series of option,value pairs or a
%   structure containing option,value pairs, as would be used in a call to
%   penalized(). For a full list of the options, type "help options". 
%
%   Three extra options specific to cross validation are:
%   'folds'   : the number of cross-validation folds to do (default is 5). 
%               For n folds, the data is divided into n contiguous chunks.
%               Fold i reserves chunk i for the test, and uses the other
%               chunks for training.
%   'measure' : the measure of cross validation error, either 'deviance' 
%               or 'logl'. The default is deviance. 
%   'shuffle':  Use this if you don't like contiguous
%               chunks. If true, cv_penalized randomly shuffles the rows of 
%               the design matrix before doing the folds. Default is false.
%
% Output:
%   cv  : the cross-validation structure. This has the following fields:
%         .fit  - the fit to the whole data set. See "help fit"
%         .relax- if penalty relaxation occurs, this field contains the name of
%                 the penalty parameter.
%         .(relax) - the range of values used for the penalty parameter.
%                 (relax) is replaced by the actual parameter name e.g. cv.alpha, 
%                 cv.delta, etc.
%         .err  - the cross-validation errors. err(k,j,v) is the error for
%                 fold k, lambda value j, and penalty parameter value v (if
%                 any).
%         .cve  - the total cross-validation error over the folds, 
%                 cve(j,v) = sum(err,1)+2*fit.nulldev. This is directly 
%                 comparable to the value of deviance(cv.fit).
%         .cvsd - the standard error of cve, cvsd(j,v)=se(err(:,j,v))*k
%         .p    - the average number of nonzero parameters. p(j,v) is the
%                 number of parameters lambda value j, and penalty 
%                 parameter value v (if given), averaged over the folds.
%         .minlambda, .min(relax) - the indices of lambda and penalty
%                 parameter that yield the smallest error; (relax) is
%                 replaced by the actual parameter name, e.g. minalpha,
%                 mingamma, mindelta, etc.
%         .min_err - the minimum cv error (=min(cv.cve(:)).
%         .bestbeta - the value of beta that yields the smallest error; equal
%                 to  fit.beta(:,cv.minlambda,cv.min(relax)).
%
% See also PENALIZED

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
% along with the PENALIZED toolbox.  If not, see
% <http://www.gnu.org/licenses/>.

% run penalization once to get the lambda sequence & parse inputs
[fit,options]  = penalized(model,penalty,varargin{:});
options.lambda = fit.lambda;
options.forcelambda = true;

% look for folds, measure, and shuffle options
if ~isfield(options,'folds')
    options.folds = 5;
end
if ~isfield(options, 'measure')
    options.measure = 'deviance';
end
if ~isfield(options,'shuffle')
    options.shuffle = false;
end

% initalize crossvalidation structures
cv.folds = options.folds;
cv.measure = options.measure;
cv.err = [];
cv.p = [];
cv.lambda = options.lambda;
if isfield(fit,'relax')
    cv.relax=fit.relax; 
    cv.(cv.relax)=fit.(fit.relax); 
end

% Compute the cross-validation errors.
% cv.err(k,j,f) is the crossvalidation error for 
% fold k, lambda j, and parametervalue f (if multi)

n = property(model,'n');
p = property(model,'p');

% shuffle
if options.shuffle
    model = sample(model, randperm(n));
end

k = options.folds;
for i=1:k
    % get the training and test set for this fold
    testidx = i:k:n;
    trainidx = 1:n;
    trainidx(testidx)=[];
    test  = sample(model,testidx);
    train = sample(model,trainidx);
    
    % fit model to training data
    trained = penalized(train,penalty,options);
    
    % compute fit to test data
    for j=1:size(trained.beta,2)
        for v=1:size(trained.beta,3)
            cv.err(i,j,v) = -2*logL(test, trained.beta(:,j,v));
            cv.p(i,j,v)   = sum(trained.beta(:,j,v)~=0);
        end
    end
end

% calculate total cv error and variation.
% cv.err(i,j,k) is for fold i, lambda j, and relaxer k
% we sum across the first coordinate, then squeeze it out
cv.cve  = squeeze( sum(cv.err,1) ); 
cv.p    = squeeze( mean(cv.p,1) );
cv.cvse = squeeze( std(cv.err,0,1)/sqrt(k)*k );
% the problem when there is no relaxer is that this leaves a 
% singleton first dimension, so we fix this
if size(cv.cve,1)==1
    cv.cve=cv.cve';
    cv.p=cv.p';
    cv.cvse=cv.cvse';
end

cv.fit  = fit;

switch options.measure
    case {'dev','deviance'}
        % add the null deviance so the cv.err values are directly
        % comparable to the values of deviance(cv.fit)
        cv.err = cv.err+2*fit(1).nulldev;
end

% find minimum error parameters
cv.min_err = min(cv.cve(:));

sz = size(cv.cve);
if sum(sz>1)==1
    minpenalty=1;
    cv.minlambda = find(cv.cve==cv.min_err);
else
    [cv.minlambda,minpenalty] = find(cv.cve==cv.min_err);
    cv.(['min',cv.relax]) = minpenalty;
end

cv.bestbeta = fit.beta(:,cv.minlambda,minpenalty);




