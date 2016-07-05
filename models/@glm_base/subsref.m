function b = subsref(model,index)
%SUBSREF defines field name indexing for glm objects
% This has to be overridden in derived classes to get
% the right class type. 

switch index(1).type
case '.'  % element
    b = model.(index(1).subs);
otherwise
  error('Model subsref must start with a field')
end

if length(index)>1
    b = subsref(b,index(2:end));
end
