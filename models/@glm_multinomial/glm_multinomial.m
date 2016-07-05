function m = glm_multinomial(y,X, varargin)
% MULTI creates a new multinomial model.
%
% Usage:
%   m = glm_multinomial(y,X,...)
%
% Inputs:
%   y : an n*q matrix of counts. Each row [s1,s2,s3,...sq] gives
%       the number of successes for each category 1,2,3,...q
%   X : an n*nparams matrix. The X matrix is the same for all categories 
%       and nparams is the number of params per category.
%   ... : options. These are:
%            'nointercept' - stops an intercept being added.
%            'center' or 'centre' - centres the columns of X when the
%                intercept is added.
%
% Outputs:
%   m  : a multinomial model object

m.original = struct('y',y,'X',X);
m.intercept = [];

[n,q] = size(y); 
if q==1
    error('multinomial model needs 2+ categories'); 
end

% auxiliary values
catid = repmat(1:q,[n,1]);      % each row is [1,2,3,...q]
count = repmat(sum(y,2),[1,q]); % each row is [n,n,n,...] where n=s1+s2+s3+...
obs   = repmat((1:n)',[1,q]);   % each row is [r,r,r,...] where r is the row number

% stack the categories
y = y(:); 
catid = catid(:); 
count = count(:);
obs=obs(:);
XX = {}; 
for i=1:q
    XX{i}=X; 
end
X  = cat(1,XX{:});

% remove cases where number of successes is zero
ok = y~=0;
y  = y(ok);
catid = catid(ok);
obs   = obs(ok);
count = count(ok);
X = X(ok,:);

% make the model class
m.catid = catid;
m.obs = obs;
m.count = count;
m.q = q;
m.colscale = 0;
m = class(m,'glm_multinomial',glm_base(y, X, varargin{:}));
m.colscale = m.glm_base.colscale;
