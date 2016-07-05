function p = property(m, name)
% PROPERTY returns a structure or properties, or a single one
% usage: p = property(model)
%        p = property(model, name)
%
% Mostly for internal use.



p = struct('n',size(m.glm_base.X,1), ...
    'p', size(m.glm_base.X,2)*m.q, ...
    'colscale', m.colscale );
p.nobs = sum(m.glm_base.y);
p.intercept = m.glm_base.intercept;
if ~isempty(p.intercept)
    p.intercept = p.intercept+(0:m.q-1)*size(m.glm_base.X,2);
end

if nargin==2
    p = p.(name);
end
    