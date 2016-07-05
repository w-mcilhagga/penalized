
% PENALTY FUNCTIONS
% 
% A penalty function penalty(mode,beta,lambda,options) implements a penalty 
% on the regression parameters. The inputs are:
%
%   mode:   determines what the penalty function produces
%   beta:   the vector of parameters. This may be restricted to the active
%           set or the inactive set, depending on mode.
%   lambda: the value of the penalty weight lambda currently being used.
%           Some penalties depend on this
%   options: the options structure. Some penalties require additional
%           parameters and they are passed as fields in the options 
%           structure. See clipso, mcplus.
%
% A penalty function is called in five different ways, depending on mode 
% and the number of outputs:
% 
% 1) p = penalty('',beta,lambda,options)
% 
% - Returns a vector p which are the penalties for each individual parameter: 
% p(i) is the penalty on parameter beta(i). The total penalty is calculated 
% as lambda*sum(options.penaltywt.*p)
%
% 2) dp = penalty('deriv',beta,lambda,options)
%
% - Returns the derivatives dp of the penalty, dp(i) = (d penalty)/(d beta(i)).
% dp is the same size as the full vector beta but only the elements which are in
% the active set are used (elements of dp not in the active set can be
% anything)
%
% 3) [lo,hi] = penalty('subdiff',beta,lambda,options)
%
% - Returns the subdifferential range of the penalty. 
% lo(i) =  left gradient of beta(i), hi(i) = right gradient.
% If lo(i)>hi(i), swap them.
% If all lo and/or hi are the same, you can return scalars. The full beta
% is passed but only elements of lo and hi in the inactive set are used.
%
% 4) d2p = penalty('2ndderiv',beta,lambda,options)
%
% - Returns the second derivatives (d^2 penalty)/(d beta(i)^2). If all values 
% of d2p are the same, you can return a scalar. The full vector beta is passed 
% but only the elements in dp which are in the active set are used.
%
% 5) b = penalty('project',beta,lambda,options)
%
% - returns true if orthant projection is necessary. Projection simply
% disallows a change of sign on any penalized coefficient.



