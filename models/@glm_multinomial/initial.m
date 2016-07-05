function b = initial(m)
% INITIAL returns an initial value for the coefficients beta.
%
% Usage:
%   beta = initial(m)
%
% Inputs:
%   m : a glm_multinomial object
%
% Outputs:
%   beta : a vector of zeros

b = zeros(size(m.glm_base.X,2)*m.q,1);