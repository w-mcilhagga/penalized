function [x,y] = p_none(mode,b,lambda,options)
% P_NONE - no penalty.
%
% Definition & Properties:
% ------------------------
%
% none(beta) = 0
%
% Usage:
% ------
%
% penalized(model,@p_none, 'lambda',0, ...)
%    -- setting lambda to zero saves some time.

switch (mode)
    case ''
        x = zeros(size(b));
    case 'deriv'
        x=zeros(size(b));
    case 'subdiff'
        x=0; y=0;
    case '2ndderiv' % of active set
        x = 0;
    case 'project'
        x = false;
end



