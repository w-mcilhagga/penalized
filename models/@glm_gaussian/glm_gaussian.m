function m = gaussian(y,X,varargin)
% GLM_GAUSSIAN creates a linear regression model.
%
% Usage:
%   g = glm_gaussian(y,X,...)
%
% Inputs:
%   y  : a vector of observations
%   X  : a matrix of covariates
%   ... : options. These are:
%            'nointercept' - stops an intercept being added.
%            'center' or 'centre' - centres the columns of X when the
%                intercept is added.
% Outputs:
%   g  : a gaussian model object
%
% Notes:
% The linear regression model is E(y)=X*beta. 
%
% The log-likelihood is -0.5*norm(y-X*beta)^2

m = class(struct([]),'glm_gaussian',glm_base(y,X,varargin{:}));