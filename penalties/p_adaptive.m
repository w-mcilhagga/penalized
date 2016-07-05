function [x,y] = p_adaptive(mode,beta,lambda,opts)
% P_ADAPTIVE - the adaptive lasso.
%
% Definition & Properties:
% ------------------------
%
% The adaptive lasso defines the penalty as lambda*sum(|beta|/|b|^gamma),
% where b is a consistent estimator of b. 
%
% Usage:
% ------
%
% penalized(model,@p_adaptive, 'gamma',g, 'adaptivewt', {b}, ...)
%    -- g may be a vector in which case all values are tried in order.
%    -- note that the adaptive weight vector b must be enclosed in a cell.
%
% Reference:
% Zou H (2006). "The Adaptive Lasso and Its Oracle Properties." Journal of the 
% American Statistical Association, 101(476), 1418{1429.


gamma = opts.gamma; 
w = abs(opts.adaptivewt{1});
w(w==0)=eps;

switch (mode)
    case ''
        x = abs(beta)./w.^gamma;
    case 'deriv'
        x = sign(beta)./w.^gamma;
    case 'subdiff'
        y = 1./w.^gamma;
        x = -y;
    case '2ndderiv' % of active set
        x = 0;
    case 'project'
        x = true;
end




