function b = subsref(model,index)
%SUBSREF Define field name indexing for glm objects
% This has to be overridden in derived classes to get
% the right class type. 

b = glm_multinomial(model.original.y(index,:),model.original.X(index,:));
b.colscale = model.colscale;