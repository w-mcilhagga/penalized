function [x,y] = p_concavePF(mode,beta,lambda,opts)
% P_CONCAVEPF - the concave PF penalty.
%
% Definition & Properties:
% ------------------------
%
% concavePF(beta) = k*abs(beta)/(k+abs(beta)). 
%   k=inf is lasso, small k is L_0 like.
%
% Usage:
% ------
%
% penalized(model,@p_concavePF, 'k',k, ...)
%    -- will set 'k' to k. k may be a vector in which case all values are
%       tried in order.

k = opts.k;
switch (mode)
    case ''
        x = k*abs(beta)./(k+abs(beta));
    case 'deriv'
        x=k^2*sign(beta)./(k+abs(beta)).^2;
    case 'subdiff'
        x=-1; y=1;
    case '2ndderiv' % of active set
        x = -2*k^2./(k+abs(beta)).^3;
    case 'project'
        x= true;
end



