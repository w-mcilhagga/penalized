function m = glm_logistic(y,X,varargin)
% LOGISTIC creates a logistic regression model.
%
% Usage:
%   l = logistic(y,X,...)
%
% Inputs:
%   y  : a vector of observations. If y is n by 1, then it records successes
%        from Bernoulli trials (count = 1). If y is n by 2, then the first
%        column gives the number of successes and the second column gives
%        the counts.
%   X  : a matrix of covariates
%   ... : options. These are:
%            'nointercept' - stops an intercept being added.
%            'center' or 'centre' - centres the columns of X when the
%                intercept is added.
%
% Outputs:
%   l : a glm_logistic regression model
%
% Notes:
% A logistic model is defined as E(y./n)=(1+exp(-X*beta))^-1. 

if size(y,2)==1
    m.n = ones(size(y));
else
    m.n = y(:,2);
    y = y(:,1);
end
m = class(m,'glm_logistic',glm_base(y, X, varargin{:}));