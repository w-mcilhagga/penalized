function l = l_from_mu(model,mu)
% L_FROM_MU is an internal function used in logL and scoring.
%
% Usage:
%   l = l_from_mu(m,mu)
%
% Inputs:
%   m  : a glm_poisson model object
%   mu : a vector of expected values
%
% Outputs:
%   l  : the log-likelihood, sum(y.*log(mu)-mu)

ok = mu~=0;
l = sum(model.glm_base.y(ok).*log(mu(ok))-mu(ok));