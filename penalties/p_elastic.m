function [x,y] = p_elastic(mode,beta,lambda,opts)
% P_ELASTIC - the elastic net penalty.
%
% Definition & Properties:
% ------------------------
%
% The elastic net is a linear combination of lasso and ridge penalties: 
%   elastic(beta) = alpha*lasso(beta) + (1-alpha)*ridge(beta)
%
% Usage:
% ------
%
% penalized(model,@p_elastic, 'alpha',a, ...)
%    -- will set alpha to a. a may be a vector in which case all values are
%       tried in order.
%
% Reference
% Zou, H. and T. Hastie (2005). "Regularization and variable selection via the
% elastic net." Journal of the Royal Statistical Society  B, 67(2), 301–320.


alpha = opts.alpha;

switch (mode)
    case ''
        x = alpha*p_lasso(mode,beta,lambda,opts)+(1-alpha)*p_ridge(mode,beta,lambda,opts);
    case 'deriv'
        x = alpha*p_lasso(mode,beta,lambda,opts)+(1-alpha)*p_ridge(mode,beta,lambda,opts);
    case 'subdiff'
        [x1,y1] = p_lasso(mode,beta,lambda,opts);
        [x2,y2] = p_ridge(mode,beta,lambda,opts);
        x = alpha*x1+(1-alpha)*x2;
        y = alpha*y1+(1-alpha)*y2;
    case '2ndderiv' % of active set
        x = (1-alpha)*2*ones(size(beta));
    case 'project'
        x = alpha>0;
end




