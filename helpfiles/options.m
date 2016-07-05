% OPTIONS:
%
% The options control the behaviour of penalized.
% Any unspecified options are filled in with default values.
%
% The options are passed to penalized as either a set of name,value
% pairs (e.g. 'nlambda',100,'coreiter',20,...), or as a struct containing 
% some or all of the properties below (assuming n=number of observations
% and p=number of parameters):
% 
%  .coreiter  : the number of LM iterations to do for a single
%               penalty value. default=30
%  .fdev      : when the change in (deviance/n) is less than fdev, we
%               finish.
%  .forcelambda : whether to use all lambdas or not. This switches off all
%               convergence criteria
%  .lambda    : the series of lambdas to use. If not supplied (usually the
%               best option) a series of lambdas is generated, of
%               length nlambda. See below.
%  .lambdamax : if supplied, the lambda sequence begins with this value,
%               instead of the generated one. Useful when the subgradient of
%               the penalty is zero (e.g. ridge penalty).
%  .lambdaminratio : the ratio of smallest to largest lambda when .lambda
%               is not specified. default is 0.0001 when n>p, otherwise
%               0.01
%  .maxnewvars : how many new variables to take into the working set on each
%               iteration. Default is 3 when n>p, otherwise 1. Use inf to 
%               accept as many as possible.
%  .measure   : the measure of cross-validation error, either 'dev' or
%               'deviance' or 'log-likelihood'
%  .nlambda   : number of lambdas to use for penalty. default=100
%  .penaltywt : the weightings for the penalty function. default is 1, 
%               except where an intercept has been defined (then it's
%               zero at the intercept).
%  .betascale : this is used internally by penalized when ther .standardize
%               option is true. The default is 1.
%  .pmax      : the maximum number of nonzero parameters. default is p+1.
%  .standardize : whether to apply standardization to the columns of the
%               design matrix. Although this is commonly done, the default is
%               FALSE. (Standardization is implemented by changing the
%               penalty weights; the model itself is not altered.)
%  .thresh    : the threshold for convergence for a single penalty
%               value. default = 1e-8 if p<n, otherwise 1e-5. Convergence
%               occurs when change in deviance < thresh*null deviance. Note
%               that both this convergence criterion _and_ the next
%               criterion on beta must hold for convergence.
%  .betathresh: the threshold for convergence in the coefficients.
%               Coefficients have converged when the norm of the change is less 
%               than betathresh times the number of nonzero elements of
%               beta.
%  .trustiter : the number of trust region shrinkages to try for
%               each coreiter. default=10
%  .trustrgn  : the initial trust region size. default=0.1
%  .warmstart : determines the warm-start sequence. There are three
%               possibilities when fitting the value of fit.beta(:,j,k):
%               'relax' : the warm-start is fit.beta(:,j,k-1) i.e. 
%                         same lambda, previous penalty parameter value. 
%                         This is the default.
%               'lambda': the warm-start is fit.beta(:,j-1,k)
%                         i.e. same penalty param, previous lambda. 
%               'best'  : try both warm starts, and pick the best one. 
%                         This is slower but may be better.
%
% How PENALIZED chooses lambda:
% -----------------------------
%
% 1) When lambda is specified (usually a vector) it is used. Otherwise,
% 2) When lambdamax is specified, the lambda series is given by
%      logspace(log10(lambdamax),log10(lambdamax*lambdaminratio),nlambda).
% 3) When lambdamax is not specified, it is calculated as the largest value
%    of lambda which allows at least one coefficient to enter the active
%    set. Then the range of lambdas is calculated as in 2).
%
% Penalty Parameters:
% -------------------
%
% If the chosen penalty function requires a parameter, this is passed as an
% option. For example, clipso requires a parameter 'alpha'. This can be
% passed as, for example,  penalized(model,@clipso,'alpha',0.5). Penalized
% doesn't know that alpha is a clipso parameter; instead, it sweeps up _all_
% the name value pairs into a structure which contains all the above
% options as well, and passes it as the fourth argument to penalized. Thus
% all penalty functions can access the .penaltywt option.
%
% When more than one penalty parameter should be fitted, they are passed as
% an array. Penalized() assumes that the first non-standard option that is
% an array is a list of penalty parameter values. For example, in the call
%
%    penalized(model,@penalty, 'alpha', [inf 1 0.5], 'beta',1:10)
%
% the 'alpha' option is assumed to be an array of penalty parameters to be
% fitted and 'beta' just some array (which is always passed to penalty via 
% the options structure). In this case, it sets fit.relax equal to 'alpha', 
% and fit.alpha equal to the array of values [inf 1 0.5].
%
% If _none_ of the additional arrays represent a range of penalty parameters,
% then they should be enclosed in cells. Thus, in the above case, to fit
% just one value of alpha, we would have to write
%
%    penalized(model,@penalty, 'alpha', 1, 'beta', {1:10})
%
% This ensures than penalized won't assume that beta is a series of
% penalty parameters to be fitted. Of course, if the penalty function
% expects a 'beta', it needs to be programmed to deal with a cell rather
% than a vector.

