function [l,m,D,V,X] = scoring(model,beta)
% SCORING returns the components needed the score and information matrix.
%
% Usage:
%   [l,m,D,V,X] = scoring(model,beta)
%
% Inputs:
%   model : a glm_multinomial model.
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

% calculate the linear predictor
eta = link( predictor(model,beta), ':');

p = 0;
psum = 0;
for i=1:model.q
    eta{i} = exp(eta{i});
    p = p + double(model.catid==i).*eta{i};
    psum = psum + eta{i};
end
p = p./psum; % gives the probability of success for this category.
p(p<0.0001)=0.0001;
p(p>0.999)=0.999;

D = p.J;
p = p.value;

l = l_from_p(model,p);
m = model.glm_base.y./p;
V = model.glm_base.y.^2 - model.glm_base.y + m;
X = {};
for i=1:model.q
    X{i}=bsxfun(@times,D(:,i),model.glm_base.X);
end
X = cat(2,X{:});
D = 1;
