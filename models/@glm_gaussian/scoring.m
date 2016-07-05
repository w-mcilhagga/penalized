function [l,m,D,V,X] = scoring(model,beta)
% SCORING returns the components needed the score and information matrix.
%
% Usage:
%   [l,m,D,V,X] = scoring(model,beta)
%
% Inputs:
%   model : a glm_gaussian model.
%   beta  : the coefficient estimate
%
% Outputs:
%   l    : the log-likelihood at beta, l = sum(l(i))
%   m    : m is the vector with elements m(i)= E[(d l(i))/(d mu(i))]
%          where mu(i) = E(y(i))
%   D    : a vector with elements D(i) = (d mu(i))/(d eta(i)) where
%          eta(i) = X(i,:)*beta
%   V    : a vector with elements V(i) = E[(d l(i))/(d mu(i))]^2
%   X    : the jacobian (d eta(i))/(d beta(j)) = X
%
% Notes:
%   score = X'*diag(D)*m, 
%   information matrix = X'diag(D)*diag(V)*diag(D)*X

resid = model.glm_base.y - predictor(model,beta);
l = -sum(resid.^2)/2;
m = resid;
D = 1;
V = 1; 
X = model.glm_base.X;

 