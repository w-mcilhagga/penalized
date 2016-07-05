function [x,y] = p_flash(mode,beta,lambda,opts)
% P_FLASH - the Forward Lasso Adaptive SHrinkage penalty (Radchenko & James
% 2011)
%
% Definition & Properties:
% ------------------------
%
%   flash(beta) = |beta|.*(1-delta) , when beta~=0
%   flash(beta) = |beta|            , when beta=0
%
% Usage:
% ------
%
% penalized(model,@p_flash, 'delta',d, ...)
%    -- will set delta to d. d may be a vector in which case all values are
%       tried in order.
% 
% penalized(model,@p_flash,'delta',d,'warmstart','lambda'...)
%    -- invokes flash in the way suggested by Radchenko & James (2011) for
%       variable selection.
%
% Reference:
% Radchenko & James (2011) 'Improved variable selection with Forward-Lasso 
% adaptive shrinkage.' The Annals of Applied Statistics, 5(1), 427-448.] 

delta = opts.delta;
switch (mode)
    case ''
        x = (1-delta)*abs(beta);
    case 'deriv'
        x=(1-delta)*sign(beta);
    case 'subdiff'
        x=-1; y=1;
    case '2ndderiv' % of active set
        x = 0;
    case 'project'
        x = true;
end





