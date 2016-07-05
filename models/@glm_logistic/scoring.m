function [l,m,D,V,X] = scoring(model,beta)
% SCORING returns the components needed the score and information matrix.
%
% Usage:
%   [l,m,D,V,X] = scoring(model,beta)
%
% Inputs:
%   model : a glm_logistic model.
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

eta = predictor(model,beta);

% calculate mu(i)=E(y(i)) from eta(i). Here mu is called p.
mu = 1./(1+exp(-link(eta))); % NB link is a constructor, mu is an object

% clip probablities
mu(mu.value<0.0001)=0.0001;
mu(mu.value>0.999) =0.999;
p  = mu.value;

% calculate outputs
l = l_from_p(model,p); 
m = (model.glm_base.y-model.n.*p)./(p.*(1-p));
D = mu.J;  
V = (model.n)./(p.*(1-p)) ;
X = model.glm_base.X;
