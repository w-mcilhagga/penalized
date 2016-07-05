function [x,y] = p_lasso(mode,beta,lambda,options)
% P_LASSO - the lasso (L_1) penalty.
%
% Definition & Properties:
% ------------------------
%
% p_lasso(beta) = |beta|
%
% Usage:
% ------
%
% penalized(model,@p_lasso)
%    -- lasso has no additional parameters, although one can, like all
%       penalties, apply individual weights by specifying a 'penaltywt'
%       option, e.g. penalized(model,@lasso,'penaltywt',w

switch (mode)
    case ''
        x = abs(beta);
    case 'deriv'
        x=sign(beta);
    case 'subdiff'
        x=-1; y=1;
    case '2ndderiv' % of active set
        x = 0;
    case 'project'
        x= true;
end



