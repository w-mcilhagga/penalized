function [l,mu,eta] = logL(model,beta)
% LOGL calculates the log-likelihood of the poisson model.
%
% Usage:
%   [l,mu,eta] = logL(m,beta)
%
% Inputs:
%   m    : a glm_poisson model
%   beta : a vector of parameters, or a string
%
% Outputs:
%   l   : the log-likelihood
%   mu  : the expected value given beta
%   eta : the linear predictor
%
% Notes:
% When beta is a vector, we have 
%   eta = X*beta
%   mu  = exp(eta)
%   l   = sum( y.*log(mu)-mu)
%
% When beta=='saturated', we set mu=y, and calculate l from that
% When beta=='null' we set mu=mean(y) if there is an intercept. If not,
% we set mu=1 (= exp(0). ). 

if isnumeric(beta)
    eta = predictor(model,beta);
    mu = exp(eta);
elseif strcmp(beta,'null')
    if ~isempty(property(model,'intercept'))
       mu = mean(model.glm_base.y);
    else
        mu = 1;
    end
elseif strcmp(beta,'saturated')
    mu = model.glm_base.y;
end

l = l_from_mu(model,mu);




