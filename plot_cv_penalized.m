function plot_cv_penalized(cv,varargin)
% PLOT_CV_PENALIZED plots the output of crossvalidate.
%
% Usage:
%   plot_cv_penalized(cv,...)
% 
% Input:
%   cv     : the structure returned by cv_penalty
%   ...    : name-value pairs to define various options. These are:
%            'errorbars': 'on' (default with 1 level) or 'off' (default
%                     otherwise)
%            'slice': an array giving the indices of the penalization
%                     parameter to plot. 
%
% plot_cv_penalized does different things depending on whether a penalty
% parameter has been relaxed or not.
%
% 1. no relaxation:
%  
% plot_cv_penalized plots the value of the cross-validation error (with 
% error bars by default) against lambda (on a reversed log scale). It adds a vertical 
% dashed line at the value of lambda yielding the minimum error.
%
% 2. penalty parameter relaxed:
%
% If slice is not given, plot_cv_penalized plots the cross-validation error 
% against lambda for all levels of the relaxation parameter. Error bars are
% not plotted by default. A vertical dashed line is placed at the lambda which gives 
% the smallest error across all levels of the relaxation.
%
% If slice is given, plot_cv_penalized isolates that slice of the
% relaxation parameter and plots it as if it came from penalized above
% (i.e. with error bars). The dashed line is still at the smallest error
% across all levels.
%
% With relaxed cross-validation, it is sometimes useful to plot a couple of
% different parameter values on top of one another to compare, e.g.
%
% plot_cv_penalized(cv,'slice',[1,5])
%
% will plot the error for the 1st and 5th levels of the relaxation
% parameter on top of one another, with error bars. 

% Copyright © 2014 William McIlhagga, william.mcilhagga@gmail.com
%
% This file is part of the PENALIZED toolbox.
% 
% The PENALIZED toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% The PENALIZED toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with the PENALIZED toolbox.  If not, see
% <http://www.gnu.org/licenses/>.

opts = struct('errorbars','default','slice',[]);
for i=1:2:length(varargin)
    opts.(varargin{i})=varargin{i+1};
end

if nargin>1 && ~isempty(opts.slice) && size(cv.cve,2)>1 
    % select some levels of the penalty parameter
    cv.cve  = cv.cve(:,opts.slice);
    cv.cvse = cv.cvse(:,opts.slice);
end

if size(cv.cve,2)==1
    % one level of relaxed to plot
    if strcmp(opts.errorbars,'default')
        opts.errorbars='on';
    end
    if strcmp(opts.errorbars,'on')
        errorbar(cv.lambda,cv.cve,cv.cvse,'-o')
    else
        plot(cv.lambda,cv.cve,'-o')
    end
    title(['Cross-Validation Error '])
else
    % more than one level of relaxed to plot
    if strcmp(opts.errorbars,'default')
        opts.errorbars='off';
    end
    if isempty(opts.slice)
        opts.slice = 1:size(cv.cve,2);
    end
    if strcmp(opts.errorbars,'on')
        errorbar(repmat(cv.lambda(:),[1,size(cv.cve,2)]),cv.cve,cv.cvse,'-o');
    else
        plot(cv.lambda,cv.cve);
    end
    values = {};
    name = cv.relax;
    for i=1:length(opts.slice)
        values{i} = [cv.relax,' = ',num2str(cv.(cv.relax)(opts.slice(i)))];
    end
    legend(values)
    title(['Cross-Validation Error, varying ',name])
end

% fix up axes
a = axis;
axis([min(cv.lambda),max(cv.lambda),a(3:4)]);
set(gca,'xscale','log','xdir','reverse')
xlabel('\lambda')
ylabel(['cross-validated ',cv.measure])

% put in the minimum marker.
hold on
lambdamin = cv.lambda(cv.minlambda);
plot(lambdamin*[1 1],a(3:4),'color',[0,0,0],'linestyle',':')
hold off



