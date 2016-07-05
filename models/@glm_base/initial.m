function beta = initial(m)
% INITIAL returns an initial value for the coefficients beta.
%
% Usage:
%   beta = initial(m)
%
% Inputs:
%   m : a glm_base object
%
% Outputs:
%   beta : a vector of zeros

beta = zeros(size(m.X,2),1);
i = intercept(m);
if ~isempty(i)
    beta(i)=1;
end