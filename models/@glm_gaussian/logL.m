function [l,fitted,resid] = logL(m,beta)
% LOGL computes the log-likelihood of the gaussian model.
%
% Usage:
%   [l,fitted,resid] = logL(g,beta)
%
% Inputs:
%   g     : a glm_gaussian model object
%   beta  : a vector of coefficients, or the strings 'null' or 'saturated'
%
% Outputs:
%   l       : the likelihood (see notes)
%   fitted  : the fitted values X*beta
%   resid   : the residuals y-fitted
%
% Notes:
%  When beta is a vector, the log-likelihood is given by
%    -0.5*norm(y-X*beta)^2
%  When beta=='saturated', the log-likelihood is zero
%  When beta=='null', the log-likelihood is -0.5*norm(y)^2 if there
%  is no intercept in the model, and -0.5*norm(y-mean(y))^2 if there is.

n=size(m);
if isnumeric(beta)
    yhat  = predictor(m,beta);
    resid = m.glm_base.y - yhat;
    l = -sum(resid.^2)/2;
elseif strcmp(beta,'null')
    resid = m.glm_base.y;
    if ~isempty(property(m,'intercept'))
        resid = resid - mean(resid);
    end
    l = -sum(resid.^2)/2;
elseif strcmp(beta,'saturated')
    l = 0;
end

