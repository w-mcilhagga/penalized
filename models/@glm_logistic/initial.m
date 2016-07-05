function beta = initial(m)
% INITIAL returns an initial value for the coefficients beta.
%
% Usage:
%   beta = initial(m)
%
% Inputs:
%   m : a glm_logistic object
%
% Outputs:
%   beta : a vector of zeros

beta = zeros(size(m.glm_base.X,2),1);
i = m.glm_base.intercept;
if ~isempty(i)
    p = sum(m.glm_base.y)/sum(m.n);
    beta(i) = log(p/(1-p));
end