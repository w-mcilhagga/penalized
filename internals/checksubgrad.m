function a = checksubgrad(grad,penalty,beta,lambda,opts)
% checksubgrad returns a vector of how much
% each gradient (over the inactive set) exceeds the subgradient of
% the penalty. If lambda is empty, it finds the maximum value of 
% lambda which ensures at least one value escapes from the inactive set. 
%
% checksubgrad is an internal routine and should 
% not be called outside a wrapper.


% Copyright © 2014 William McIlhagga, william.mcilhagga@gmail.com
%
% This file is part of the PENALIZED toolbox.
% 
% The PENALIZED toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% The PENALIZED toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with the PENALIZED toolbox.  If not, see
% <http://www.gnu.org/licenses/>.

if isempty(lambda) 
    % find a good initial lambda. A bracketing approach is used
    % in case penalty nonlinearly depends on the value of lambda.
    
    % get indices that are weighted - search for lambda 
    % can't occur within unweighted parameters
    wt = opts.penaltywt(beta==0)~=0;
    % 1. bracket two lambda values which can be used. One lambda
    % has all zeros in p, the other doesn't.
    lambda = 1;
    p = checksubgrad(grad,penalty,beta,lambda,opts);
    iters = 10;
    while all(p(wt)==0) && iters>0
        % reduce lambda.
        oldlambda = lambda;
        lambda = lambda/2;
        iters = iters-1;
        p = checksubgrad(grad,penalty,beta,lambda,opts);
    end
    while ~all(p(wt)==0) && iters>0
        % increase lambda
        oldlambda = lambda;
        lambda = lambda*2;
        iters = iters-1;
        p = checksubgrad(grad,penalty,beta,lambda,opts);
    end
    if iters==0, error('Problem finding initial lambda'); end
    % 2. narrow the bracket
    hi = max(oldlambda,lambda); % value s.t. all(p==0)
    lo = min(oldlambda,lambda); % value s.t. ~all(p==0)
    while (hi-lo)>1e-3*(hi+lo)
        L = (hi+lo)/2;
        p = checksubgrad(grad,penalty,beta,L,opts);
        if all(p(wt)==0), hi=L; else lo=L; end
    end
    % 3. return the lo value.
    a = lo;
else
    % work out the subgradient at beta over the inactive set
    inactive = find(beta==0);
    [lo,hi] = restrictpenalty(penalty,'subdiff',beta,lambda,opts);
    lo = lo.*opts.penaltywt(inactive);
    hi = hi.*opts.penaltywt(inactive);
    % find the excess of gradient over the subgradient over inactive set
    grad = grad(inactive);
    lo = lo*lambda; hi = hi*lambda;
    a = (grad<lo).*(grad-lo) + (grad>hi).*(grad-hi);
end

    
    