function eta = predictor(model,beta)
% PREDICTOR returns the linear predictor X*beta for a multinomial model.
%
% Usage:
%   eta = predictor(m,beta)
%
% Inputs:
%   m     : a glm object
%   beta  : a vector. This stacks the beta for category 1, then 2, then 3,
%           etc.
%
% Outputs:
%   eta  : eta(i,c) is the linear predictor for observation i, category c
%          in the same shape as the original y vector.
%
% Notes:
%  Slightly optimized for sparse beta.

beta = reshape(beta,[size(model.glm_base.X,2),model.q]); % [beta1,beta2,...]
if nnz(beta)<0.5*prod(size(beta))
    eta = model.glm_base.X*sparse(beta);
else
    eta = model.glm_base.X*beta;
end

