function [x,y] = p_scad(mode,beta,lambda,options)
% P_SCAD - the SCAD penalty (Fan & Li 2001)
%
% Definition & Properties:
% ------------------------
%
% SCAD is easiest defined by its derivative wrt beta.
%
% SCAD' = 1                               when beta<lambda
%       = (a*lambda-beta)/(a-1)*lambda)   when lambda<=beta<a*lambda
%       = 0                               when beta>=a*lambda
%
% for a>2, beta>0
%
% SCAD is like lasso when beta<lambda, does not penalize when
% beta>a*lambda, and smoothly transitions between these when
% beta is between lambda and a*lambda.
%
% Usage:
% ------
%
% penalized(model,@p_scad,'a',a)
%    -- SCAD uses a parameter a which must be greater than 2

a = options.a;
if a<2, error('Parameter a in SCAD must be greater than or equal to 2'); end
b = abs(beta);

small  = b<lambda;
medium = ~small & b<(a*lambda);
large  = ~(small | medium);

switch (mode)
    case ''
        x = b.*small + ...
            (b.*((2*a*lambda-b)./(2*(a-1)*lambda)) - lambda/(2*a-2)).*medium + ...
            0.5*lambda*(a+1).*large;
    case 'deriv'
        x = sign(beta).*(small + ...
            (a*lambda-b)./((a-1)*lambda).*medium);
    case 'subdiff'
        x = -1; 
        y = 1;
    case '2ndderiv' % of active set
        x = -sign(beta)./((a-1)*lambda).*medium;
    case 'project'
        x = true;
end



