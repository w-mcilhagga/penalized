function d = goodness_of_fit(mode, fit, varargin)
% GOODNESS_OF_FIT calculates a number of measures
%
% Usage:
%   d = goodness_of_fit(which, fit, ...)
%
% Input:
%   which : a string giving the measure needed. One of 'deviance',
%          'log-likelihood', 'aic' or 'bic'. If 'bic' is desired, the
%          model used for the fit must be passed as a third parameter i.e.
%          d = goodness_of_fit('bic', fit, model)
%   fit  : the object returned by penalized
%
% Output:
%   d    : the goodness of fit measure. d(i) is the selected goodness of fit at 
%          penalty weight fit.lambda(i)

switch lower(mode)
    case 'deviance'
        d = (1-fit.devratio)*fit.nulldev;
    case 'log-likelihood'
        d = goodness_of_fit('deviance',fit)/(-2)+fit.sat;
    case 'aic'
        d = -2*goodness_of_fit('log-likelihood',fit)+2*fit.nz;
    case 'bic'
        nobs = property(varargin{1}, 'nobs');
        d = -2*goodness_of_fit('log-likelihood',fit)+log(nobs)*fit.nz;
end


