% FIT structure:
%
% The fit structure contains the output from penalized. The fit structure 
% contains the following fields.
%
%  .nulldev   : the deviance under the null model
%  .sat       : the log likelihood for the saturated model
%  .lambda    : lambda(i) gives the value of the i-th penalty weight lambda
%  .beta      : beta(:,i) is the fitted estimate for penalty weight lambda(i)
%  .intercept : gives the row of beta which contains the estimated intercept.
%               if no intercept, this is just []. If you want to compare
%               this with the fit structure from glmnet, do the following:
%                   fit.a0 = fit.beta(fit.intercept,:,:);
%                   fit.beta(fit.intercept,:,:) = [];
%               This cuts the intercept out of fit.beta and stores it in
%               fit.a0
%  .nz        : nz(i) is the number of nonzero parameters in beta(:,i)
%  .devratio  : devratio(i) is the deviance ratio at lambda(i), defined
%               as devratio(i) = 1-(deviance for beta(:,i))/nulldev
%  .flag      : the reason why the fitting procedure finished.
%  .intercept : if the model has an intercept, this gives the index of the 
%               intercept in beta.
%
% If the penalty function has one parameter, e.g. as in the call
%    fit = penalized(model,@penalty,'alpha',0.5)
% the fit structure includes the value of the parameter i.e. fit.alpha=0.5
% in the example call.
%
% Penalty Relaxation.
%
% If an array of values has been given for the penalty parameter e.g. as in
% the call
%    fit = penalized(model,@penalty,'alpha',[5 3 1])
% the fit structure also contains the array of values, so fit.alpha=[5 3 1]. 
% The fit structure then includes an additional field fit.relax, which gives the
% name of the penalty parameter array; in this case, fit.relax = 'alpha'.
%
% In addition, the fit.beta, fit.devratio, fit.intercept, and fit.nz fields 
% are expanded:
%
%   fit.beta(:,i,j) holds the coefficients for fit.lambda(i) and
%        fit.(fit.relax)(j) (e.g. fit.alpha(j))
%   fit.nz(:,i,j) holds the number of nonzero coeffs for fit.lambda(i) and
%        fit.(fit.relax)(j)
%   fit.devratio(:,i,j) holds the deviance ratio for fit.lambda(i) and
%        fit.(fit.relax)(j)



