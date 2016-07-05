function [l,p,eta] = logL(m,beta)
% LOGL returns the log-likelihood of the logistic model.
%
% Usage:
%  [l,p,eta] = logL(m,beta)
%
% Inputs:
%   m     : a glm_logistic model
%   beta  : a vector of coefficients, or a string
%
% Outputs:
%   l   : the log-likelihood
%   p   : the fitted probabilities
%   eta : the linear estimates
%
% Notes:
%   When beta is a vector of coefficients, we have
%   eta = X*beta
%   p   = (1+exp(-eta)).^(-1), clipped into the range 0.0001...0.9999
%   l   = sum (m.y.*log(p)+(m.n-m.y).*log(1-p))
%
%   When beta=='saturated', p = m.y/m.n and eta is not returned. 
%   When beta=='null', p = sum(m.y)/sum(m.n) when there is an intercept,
%   otherwise p=0.5. 
%
% In both string inputs, l is computed from p in the same way.

if isnumeric(beta)
    eta = predictor(m,beta);
    p   = 1./(1+exp(-eta));
elseif strcmp(beta,'null')
    % this will depend on whether there is an intercept or not
    if ~isempty(m.glm_base.intercept)
        p = sum(m.glm_base.y)/sum(m.n);
    else
        p = 0.5; % which is what you get when all beta=0
    end
elseif strcmp(beta,'saturated')
    % this returns different value for grouped/ungrouped, since has
    % one parameter per distinct covariate pattern.
    p = m.glm_base.y./m.n;
end

p(p<0.0001)=0.0001;
p(p>0.9999)=0.9999;

l = l_from_p(m,p);




