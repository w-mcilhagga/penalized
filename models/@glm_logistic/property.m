function p = property(m, name)
% PROPERTY returns a structure or properties, or a single one
% usage: p = property(model)
%        p = property(model, name)
%
% Mostly for internal use.



p = property(m.glm_base);
p.nobs = sum(m.n);

if nargin==2
    p = p.(name);
end
    