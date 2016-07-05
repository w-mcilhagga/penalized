function p = predictor(model,beta)
% PREDICTOR returns the linear predictor X*beta.
%
% Usage:
%   p = predictor(m,beta)
%
% Inputs:
%   m     : a glm_base object
%   beta  : a vector
%
% Outputs:
%   p  : the predictor X*beta
%
% Notes:
%  Slightly optimized for sparse beta.

if nnz(beta)<0.5*length(beta)
    p = full(model.X*sparse(beta));
else
    p = model.X*beta;
end
