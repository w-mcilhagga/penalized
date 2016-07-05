function m = glm_poisson(y,X,varargin)
% POISSON creates a poisson model.
%
% Usage:
%   p = glm_poisson(y,X,...)
%
% Inputs:
%   y  : a vector of observations
%   X  : a matrix of covariates
%   ... : options. These are:
%            'nointercept' - stops an intercept being added.
%            'center' or 'centre' - centres the columns of X when the
%                intercept is added.
%
% Outputs:
%   p  : a poisson model object
%
% Notes:
% In the Poisson model, E(y)=exp(X*beta). 

m = class(struct,'glm_poisson',glm_base(y,X,varargin{:}));