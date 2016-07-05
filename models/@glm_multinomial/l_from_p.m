function l = l_from_p(m,p)
% L_FROM_P is an internal function used by multi
%
% Usage:
%   l = l_from_p(m,p)
%
% Inputs:
%   m  : a glm_multinomial model
%   p  : the fitted probabilities
%
% Outputs:
%   l : the log likelihood - this is the probability of observing s
%       successes from s trials with probability p

l = m.glm_base.y.*log(p);
l = sum(l(~isnan(l))); 
