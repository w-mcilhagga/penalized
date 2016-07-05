function p = property(m, name)
% PROPERTY returns a structure or properties, or a single one
% usage: p = property(model)
%        p = property(model, name)
%
% Mostly for internal use.



p = struct('n',size(m.X,1), 'p', size(m.X,2), 'intercept', m.intercept, ...
    'colscale', m.colscale );
p.nobs = p.n;

if nargin==2
    p = p.(name);
end
    