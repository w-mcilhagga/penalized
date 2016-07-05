function [x,y] = p_Lq(mode,beta,lambda,options)
% p_Lq - the Lq norm net penalty.
%
% Definition & Properties:
% ------------------------
%
% Lq(beta) = |beta|^q
%
% Usage:
% ------
%
% penalized(model,@p_Lq, 'q',q, ...)
%    -- will set q to q. q may be a vector in which case all values are
%       tried in order.
%
% Note that if q<1, no inactive elements of beta will ever join the active
% vector. The only way to use this penalty effectively is via relaxation, e.g.
%
%  penalized(model,@p_Lq,'q',1:-0.2:0,...)
%
% In this case, the warm starts are from the L1 norm, and so have some
% elements different from zero.

q = options.q;

switch (mode)
    case ''
        x = abs(beta).^q;
    case 'deriv'
        if q==1
            x = sign(beta);
        else
            x = q*sign(beta).*abs(beta).^(q-1);
        end
    case 'subdiff'
        if q==1
            x=-1; y=1;
        elseif q<1
            x=-inf; y=inf;
        else
            x=0; y=0;
        end
    case '2ndderiv' % of active set
        x = q*(q-1)*abs(beta).^(q-2);
    case 'project'
        x = q<=1;
end



