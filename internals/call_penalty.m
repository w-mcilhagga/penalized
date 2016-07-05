function [x,y] = call_penalty(penalty,mode,beta,lambda,opts)
% call_penalty wraps penalty with betascaling. This is important when
% the fit requires standardization.

beta = beta.*opts.betascale;
switch mode
    case ''
        x = penalty(mode,beta,lambda,opts);
    case 'deriv'
        x = opts.betascale.*penalty(mode,beta,lambda,opts);
    case 'subdiff'
        [x, y] = penalty(mode,beta,lambda,opts);
        x = x.*opts.betascale;
        y = y.*opts.betascale;
    case '2ndderiv' % of active set
        x = opts.betascale.^2.*penalty(mode,beta,lambda,opts);
end    