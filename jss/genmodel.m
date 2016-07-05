function [y,X,beta,varargout] = genmodel(n,p,type,varargin)
% genmodel creates a model for fitting.
%
% Usage:
%   [y,X,truebeta,...] = genmodel(n,p,type,...)
% Inputs:
%   n,p : number of observations, coefficients
%   type: 'gaussian', 'logistic', 'poisson', or 'multi'.
%   ... : key value pairs:
%       std : std dev of noise (default 1)
%       rho: correlation between columns of X (default 0)
%       beta: the true beta vector, size px1
%       scale: whether to randomly scale cols of X (default false)
%       - for 'multi' type there are two more
%       categories: the number of response categories
%       count : scalar or vector giving the number of observations in a row
%
% Output:
%   y,X   : variates for a model of the appropriate type
%   beta  : the actual value of coefficient vector beta
%    If type is logistic, the next parameter is n, the count

% get options
opts = struct('rho',0,'scale',false','decay',10,'std',1,...
    'count',1,'categories',2);
for i=1:2:length(varargin)
    opts.(varargin{i})=varargin{i+1};
end

% X matrix
C = chol((1-opts.rho)*eye(p)+opts.rho*ones(p,p));
X = randn(n,p);
m = mean(X,1);
X = bsxfun(@minus,X,m)*C;
X = bsxfun(@minus,X,mean(X,1));

% true beta is an oscillating and decreasing vector
if isfield(opts,'beta')
    beta = opts.beta;
else
    beta = exp(-(0:p-1)/opts.decay)';
    beta(2:2:end)=-beta(2:2:end);
end

% scale x columns
if opts.scale
    s = 0.9*rand(1,p)+0.1;
    X = bsxfun(@times,s,X);
	beta = beta./s';
end

% work out y
eta = X*beta;

% compute y
switch type
    case 'gaussian'
        y = eta+opts.std*randn(size(eta));
    case 'logistic'
        n = 0*eta; y=0;
        while any(n<opts.count)
            yy = eta+opts.std*randn(size(eta));
            y = y+(yy>0).*(n<opts.count);
            n = n+1;
        end
        varargout{1} = opts.count.*ones(size(y));
    case 'poisson'
        y = eta+opts.std*randn(size(eta));
        y = randpoisson(exp(y));
    case 'multi'
        % fairly restricted multinomial object generation.
        b = beta;
        for i=2:opts.categories
            beta = beta(randperm(length(beta)));
            eta = [eta, X*beta];
            b   = [b;beta];
        end
        beta = b;
        p=exp(-eta);
        p=bsxfun(@times,1./sum(p,2),p);
        p=cumsum(p,2);
        y=zeros(n,opts.categories);
        for j=1:max(opts.count)
            hit=bsxfun(@minus,p,rand(size(p,1),1));
            cat = (sum(hit<0,2)+1);
            ind = sub2ind(size(y),(1:n)',cat);
            y(ind)=y(ind)+(j<=opts.count);
        end
end


% -------------------------------------------------------------------------

function n = randpoisson(lambda)
% randpoisson returns poisson distributed random numbers with lambda
% given in the vector. Uses a slow method.

L = exp(-lambda);
p = ones(size(L));
done = p>1;
n = p;

for k=0:10000
    p = p.*rand(size(p));
    ok = ~done & p<L;
    n(ok)=k;
    done = done | ok;
    if all(done), break, end
end


