function beta = initial(m)
% INITIAL returns an initial value for the coefficients beta.
%
% Usage:
%   beta = initial(m)
%
% Inputs:
%   m : a glm object
%
% Outputs:
%   beta : a vector of zeros

beta = zeros(size(m.glm_base.X,2),1);
i = property(m,'intercept');
if ~isempty(i)
    beta(i) = log(mean(y));
end