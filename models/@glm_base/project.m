function b = project(model,b)
% PROJECT projects the coefficient vector onto the allowable domain
%
% Usage:
%   pbeta = project(m,beta)
%
% Inputs:
%   m     : a glm_base object
%   beta  : a vector
%
% Outputs:
%   pbeta : the projected beta
%
% Notes:
%  This is almost always a no-op, and pbeta=beta.

