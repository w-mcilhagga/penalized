function [x,y] = restrictpenalty(penalty,mode,beta,lambda,opts);
% restrictedpenalty changes the output of penalty to be either
% active or inactive set as needed.

switch mode
    case {'deriv','2ndderiv'}
        x = call_penalty(penalty,mode,beta,lambda,opts);
        if max(size(x))==1
            x = x.*ones(size(beta));
        end
        x = x(beta~=0);
    case 'subdiff'
        [x,y] = call_penalty(penalty,'subdiff',beta,lambda,opts);
        if max(size(x))==1
            x = x.*ones(size(beta));
            y = y.*ones(size(beta));
        end
        inactive = beta==0;
        x = x(inactive);
        y = y(inactive);
end