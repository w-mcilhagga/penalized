function m = glm_base(y, X, varargin)
% GLM_BASE is a base class object for generalized linear models.
%
% Usage:
%   m = glm_base(y, X, ...)
%
% Inputs:
%   y  : a vector of observations
%   X  : a matrix of covariates
%   ...: keywords. Choose from 'nointercept', 'center' (or 'centre')
%
% Outputs:
%   m  : a glm_base object
%
% Notes:
%  glm_base is a base class, so you shouldn't use it directly


% initialize model
m.y = y;
m.X = X;
m.intercept = [];

% data for standardize
m.colscale = sqrt(sum(X.^2));

% intercept, center
if ~strfound('nointercept', varargin)
    colmeans = 0;
    if strfound('center',varargin) || strfound('centre', varargin)
        colmeans = mean(m.X,1);
    end
    m.X = [ones(size(X,1),1),bsxfun(@minus, m.X, colmeans)];
    m.intercept = 1;
    m.colscale = [1, m.colscale];
end

m = class(m,'glm_base');
