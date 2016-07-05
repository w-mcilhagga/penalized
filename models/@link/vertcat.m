function c = vertcat(varargin)
% vertcat for link objects only

v=[];
J=[];
for i=1:length(varargin)
    a = varargin{i};
    v = [v;a.value];
    J = [J;a.J];
end
c.value = v;
c.J = J;
c = class(c,'link');