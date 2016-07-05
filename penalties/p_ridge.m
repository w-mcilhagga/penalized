function [x,y] = p_ridge(mode,beta,lambda,opts)
% P_RIDGE - the ridge penalty.
%
% Definition & Properties:
% ------------------------
%
% ridge(beta) = beta^2
%
% Usage:
% ------
%
% penalized(model,@p_ridge, 'lambdamax',l ...)
%    -- if using ridge, you MUST supply a value for lambdamax, or an explicit 
%       lambda vector, otherwise the penalized function has no way of selecting one.

switch (mode)
    case ''
        x = beta.^2;
    case 'deriv'
        x=2*beta;
    case 'subdiff'
        x=2*beta; y=x;
    case '2ndderiv' % of active set
        x = 2;
    case 'project'
        x = false;
end

