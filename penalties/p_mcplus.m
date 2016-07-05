function [x,y] = p_mcplus(mode,beta,lambda,options)
% P_MCPLUS - the MC+ penalty.
%
% Definition & Properties:
% ------------------------
%
% MC+(b) = |b|-b^2/(2*w), |b|<w
%        = w/2,           |b|>=w
%
% The scaled MC+ penalty is
%
% MC+(b) = |b|-b^2/(2*w*lambda), |b|<w*lambda
%        = w*lambda/2,           |b|>=w*lambda
%
% Usage:
% ------
%
% penalized(model,@p_mcplus, 'w',w, ...)
%    -- will set 'w' to w. w may be a vector in which case all values are
%       tried in order.
% penalized(model,@p_mcplus,'w',w,'scaled',true,...)
%    -- will scale w by lambda, giving the scaled mc+ penalty.
%
% Reference
% Zhang CH (2010). "Nearly unbiased variable selection under minimax 
% concave penalty." The Annals of Statistics, 38(2), 894-942.

w=options.w;
if isfield(options,'scaled') && options.scaled
    w = w*lambda;
end
switch (mode)
    case ''
        x = abs(beta)-beta.^2/(2*w); 
        x(abs(beta)>=w) = w/2;
    case 'deriv'
        x = sign(beta).*max(1-abs(beta)/w,0);
    case 'subdiff'
        x=-1; 
        y= 1;
    case '2ndderiv' % of active set
        x = -1/w.*(abs(beta)<w);
    case 'project'
        x = true;
end



