% MODELS.
% 
% A model is an object with a number of methods called by penalized. As
% well as a constructor, you must supply a number of other methods.
%
% MAIN METHODS:
% =============
% The main methods are the creator, logL and scoring.
%
% CONSTRUCTOR
% -----------
% The constructor function returns a model class from a design matrix X, data
% vector y, and any options that may be needed. For example
%
% g = glm_gaussian(X,y,'nointercept')
%
% sets up a gaussian model (i.e. linear regression) y=X*beta. An intercept
% column is added to X unless the keyword 'nointercept' is specified. 
%
% LOGL 
% ----
% returns the log-likelihood.
%
% Usage:
%   l = logL(model,beta)
%
% Inputs:
%   model : a glm model
%   beta  : beta may be a vector of coefficients, or 'null' or 'saturated',
%           in which case logL must return the log-likelihood for the null
%           or saturated models.
%
% Output:
%   l     : the log-likelihood.
%
% Many of the logL functions will return additional results. See documentation
% for each model.
%
% SCORING 
% -------
% is called by penalized to return the components needed for
% computing the score and information matrix at beta.
%
% Usage:
%   [l,m,D,V,X] = scoring(model,beta)
%
% Inputs:
%   model : a glm model.
%   beta  : the coefficient estimate
%
% Outputs:
%   l    : the log-likelihood at beta, l = sum(l(i))
%   m    : m is the vector with elements m(i)= E[(d l(i))/(d mu(i))]
%          where mu(i) = E(y(i))
%   D    : a vector with elements D(i) = (d mu(i))/(d eta(i)) where
%          eta(i) = X(i,:)*beta
%   V    : a vector with elements V(i) = E[(d l(i))/(d mu(i))]^2
%   X    : X(i,j) = (d eta(i))/(d beta(j)); usually the design matrix
%
% The score and information matrix are computed from
%    score = X'*diag(D)*m, 
%    information matrix = X'diag(D)*diag(V)*diag(D)*X
%
% While m, D, and V are expected to be full vectors, X can be full or
% sparse
%
% ANCILLARY METHODS
% =================
%
% These methods may be inherited from the base class glm. They are
% mostly used for the various book-keeping activities needed to run the
% maximization.
%
% INITIAL
% -------
%  i = initial(model) returns a suitable initial value for beta. 
% 
% PREDICTOR
% ---------
% predictor(model,beta) is an efficient way of calculating X*beta when beta may be sparse.
% You don't have to use it, but it is recommended.
% 
% PROJECT
% -------
% betap = project(model,beta) projects beta onto the domain of the model. Useful when beta
% must be, say, positive. Mostly, this is the identity i.e. betap=beta.
% 
% PROPERTY
% --------
% p = property(model) returns a structure p which contains the model
% properties which are used by penalized. At a minimum, these are:
%   n : the number of rows of the design matrix
%   p : the number of columns (parameters) of the design matrix
%   nobs : the number of observations, which may be the same as n
%   colscale: a vector giving the L2 norms of the columns of the design
%       matrix. This is used when the 'standardize' options for penalized
%       is true.
%
% p = property(model, propname) just returns the specific property as p.
%
% SAMPLE
% -------
% Sample is used to select a subset of the model for cross-validation. 
%
% Usage:
%   m = sample(model,index)
%
% m is a model with the observations specified by index. For example
%   m = sample(model,1:2:size(model,1))
% is a sub-model containing the odd numbered observations of the original
% model.
%
% We DO NOT recalculate the colscale for a sampled model. This is because
% the sampled model is used in cross-validation, and must scale the columns
% the same as the full model.
