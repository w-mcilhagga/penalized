function l = l_from_p(m,p)
% L_FROM_P is an internal function used by logistic
%
% Usage:
%   l = l_from_p(m,p)
%
% Inputs:
%   m  : a logistic model
%   p  : the fitted probabilities
%
% Outputs:
%   l : the likelihood

l = m.glm_base.y.*log(p)+(m.n-m.glm_base.y).*log(1-p);
l = sum(l(~isnan(l))); 
