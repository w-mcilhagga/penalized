function [x,y]=p_clipso(mode,b,lambda,options)
% P_CLIPSO - the clipped lasso penalty.
%
% Definition & Properties:
% ------------------------
%
% The clipped lasso is clipso(beta)=min(|beta|,alpha). The scaled
% clipped lasso is clipso(beta)=min(|beta|,lambda*alpha)
%
% When alpha>lambda/2, and in an orthogonal setting, 
% clipso is a mix of hard and soft thresholding.
%       x = y                 if y>alpha+lambda/2, 
%       x = max(0,y-lambda)   otherwise
%
% When alpha<lambda/2, clipso is hard thresholding with a threshold equal to
% sqrt(2*lambda*alpha). When alpha=lambda/2, the two cases coincide and we
% get hard thresholding with a threshold of lambda.
%
% Usage:
% ------
%
% penalized(model,@p_clipso, 'alpha',a, ...)
%    -- will set alpha to a. a may be a vector in which case all values are
%       tried in order.
% 
% penalized(model,@p_clipso, 'alpha',a,'scaled',true ...)
%    -- invokes the scaled clipso, so alpha is multiplied by lambda.


alpha = options.alpha;
if isfield(options,'scaled') && options.scaled
    alpha = alpha*lambda; 
end

switch (mode)
    case ''
        x = min(abs(b),alpha);
    case 'deriv'
        x=sign(b).*(abs(b)<=alpha);
    case 'subdiff'
        x=-1; y=1;
    case '2ndderiv' % of active set
        x = 0;
    case 'project'
        x = true;
end




