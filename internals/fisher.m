function [beta,fval,pen,Lgrad,flag] = fisher(model,beta,lambda,penalty,opts)
% FISHER(model,beta,lambda,alpha,opts) maximizes the penalized
% likelihood
%
%    logL(model,beta)/nobs-sum(wt.*penalty(lambda,beta))
%
% using a Fisher scoring + Levenburg-Marquardt trust-region algorithm, with a warm
% start at the given beta. fisher is an internal routine and should 
% not be called outside a wrapper.
%
% The algorithm deals with singularities in the penalty function at beta=0
% but ignores them every where else. 
%
% Inputs:
%   model  : an object specifying the model. 
%   beta   : the initial value of beta
%   lambda : current penalty weight
%   penalty: a penalty function 
%   opts   : an options structure 
%
% Outputs:
%   beta  : the best fitted beta
%   fval  : the function value at beta
%   pen   : the penalty value at beta
%   Lgrad : the gradient of the likelihood at beta
%   flag  : how the maximization ended

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

n = property(model,'n');
nobs = property(model,'nobs');
trust = opts.trustrgn;
flag  = '';

wt = lambda*opts.penaltywt;

for iter=1:opts.coreiter
    % save beta for convergence calcs.
    oldbeta = beta;
    
    % calculate fval, and unpenalized gradient of model at beta
    [logl,m,D,V,J] = scoring(model,beta);
    pen  = sum( wt.*call_penalty(penalty,'',beta,lambda,opts) );
    fval = logl/nobs - pen;
    grad = J'*(D.*m/nobs); 
    
    % save the gradient of model for export - used in convergence
    % calculations
    Lgrad = grad;
    
    % find additions to the active set.
    inactive = find(beta==0);
    if ~isempty(inactive)
        potential = abs( checksubgrad(grad,penalty,beta,lambda,opts) );
        [p,idx] = sort(-potential);
        idx = idx(1:min(length(idx),opts.maxnewvars));
        idx(potential(idx)<=0)=[];

        % add infinitesimal change to beta over the new active entries
        beta(inactive(idx)) = eps*sign(grad(inactive(idx)));
    end
    
    % work out new active set
    active = beta~=0;
    if sum(active)==0
        % probably because lambda is too high
        flag = 'empty active';
        break;
    end
    
    % calculate the gradient over the active set
    grad(active) = grad(active) - wt(active).*restrictpenalty(penalty,'deriv',beta,lambda,opts);
    grad(~active)= 0;

    % compute the info matrix
    if issparse(J)
        DVJ  = sparse(1:n,1:n,D.*sqrt(V/nobs))*J(:,active);
        Info = full(DVJ'*DVJ);
    else
        DVJ  = bsxfun(@times,D.*sqrt(V/nobs),J(:,active));
        Info = DVJ'*DVJ;
    end
    
    % extract diagonal of Info; this will give the size of the trust region
    % ellipse
    DI = diag(diag(Info));
    
    % add in second derivatives of the penalty to the Info matrix.
    p2 = restrictpenalty(penalty,'2ndderiv',beta,lambda,opts);
    if any(p2~=0)
        Info = Info + diag(wt(active).*p2);
    end
    
    % update beta using LM/trust region algorithm
    oldfval = fval;
    LM_step = zeros(size(beta));
    solveopts.SYM=true;
    
    for t=1:opts.trustiter
        % compute Levenberg-Marquardt step.
        %keyboard
        [LM_step(active),rflag] = linsolve(Info+trust*DI,grad(active),solveopts);

        % project step onto allowable model region
        b = project(model,beta+LM_step);
        
        % project onto the allowable orthant
        if penalty('project',beta,lambda,opts)
            bad = wt~=0 & sign(b)~=sign(beta);
            b(bad) = 0;
        end

        % calculate value of objective function at new point
        newpen  = sum(wt.*call_penalty(penalty,'',b,lambda,opts));
        newfval = logL(model,b)/nobs - newpen;
        change  = newfval - fval;
        
        % calculate change from quadratic model. Note minus sign
        % because Info is negative of hessian.
        step = b(active) - beta(active);
        approx_change = step'*grad(active) - 0.5*(step'*Info*step);

        % adjust trust region
        if change>=0 % some improvement
            rho = change/approx_change;
            if rho>0.9 % good step, increase trust region
                trust = trust/2;
            elseif rho<0.1 % poor step, reduce trust region
                trust = trust*2;
            end
            % accept change & exit loop
            beta = b;
            fval = newfval;
            pen  = newpen;
            break;
        else % change<0
            % very poor step, massively reduce trust region
            % and try again
            trust = trust*64;
        end
    end

    % converged when change in fval is small
    % and there has been improvement
    convg = abs(oldfval-fval) < opts.devchange;
    convb = norm(beta-oldbeta)< opts.betathresh*sum(active);
    if convg && convb && oldfval<=fval
        flag='converged';
        break
    end

    if t==opts.trustiter
        flag = 'trust iterations exceeded';
    end
end

% and return
if iter==opts.coreiter && isempty(flag)
    flag = 'fisher iterations exceeded';
end
