function plot_penalized(fit,varargin)
% PLOT_PENALIZED plots the fit structure returned by penalized.m. 
%
% Usage:
%   plot_penalized(fit,...)
%
% Inputs:
%   fit   : the structure returned by penalized.m
%   ...   : name-value pairs to specify what to plot and how. Options are
%           'xaxis' - 'lambda' (default) or 'devratio'
%           'slice' - 'all' (default) or a scalar/vector of integers to
%              specify which of the penalty parameters to plot (if any)
%           'symbol' - the plot symbol (default '-' or line)
%
% Examples:
%
% plot_penalized(fit,'slice',5)
% 
% This plots the coefficients fit.beta as a function of fit.lambda for
% the 5th value of penalty parameter.
%
% plot_penalized(fit)
% 
% This interactively shows fit.beta for each level of penalty parameter.


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

opts = struct('slice','all','xaxis','lambda','symbol','-');
for i=1:2:length(varargin)
    opts.(varargin{i})=varargin{i+1};
end

if size(fit.beta,3)==1 
    % no relaxation, ignore slice
    beta = fit.beta;
    beta(fit.intercept,:,:) = [];
    beta(sum(beta,2)==0,:) = [];
    if strcmp(opts.xaxis,'lambda')
        plotvslambda(fit.lambda,beta,'',opts.symbol);
    else
        plotvsdev(fit.devratio,beta,'',opts.symbol);
    end
else
    if strcmp(opts.slice,'all')
        opts.slice = 1:size(fit.beta,3);
    end
    
    for s=opts.slice
        beta = squeeze(fit.beta(:,:,s));
        beta(fit.intercept,:,:) = [];
        beta(sum(beta,2)==0,:)=[];
        t = [fit.relax,'=',num2str(fit.(fit.relax)(s))];
        if strcmp(opts.xaxis,'lambda')
            plotvslambda(fit.lambda,beta,t,opts.symbol);
        else
            plotvsdev(fit.devratio(:,s),beta,t,opts.symbol);
        end
        if s~=opts.slice(end) % interactive
            pause
        end
    end
end

% -------------------------------------------------------------------

function plotvslambda(lambda,beta,thetitle,symbol)

semilogx(lambda,beta',symbol);
a=axis;
axis([min(lambda),max(lambda),a(3:4)]);
set(gca,'xdir','reverse')
xlabel('\lambda');
ylabel('coefficients \beta');
title(thetitle);

function plotvsdev(dev,beta,thetitle,symbol)

plot(dev,beta',symbol);
a=axis;
axis([min(dev),max(dev),a(3:4)]);
xlabel('deviance ratio');
ylabel('coefficients \beta');
title(thetitle);



