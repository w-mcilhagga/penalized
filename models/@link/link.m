function l = link(eta,dim)
% link creates an automatic differentiation object optimized for
% a matrix of variables eta(i,j), but it is restricted in that 
% it can only compute a vector-valued result.
%
% Usage: 
% link(eta,i):
%     link.value = eta(:,i), 
%     link.J(j,k)= d_link.value(j)/d_eta(j,k)
%
% link(eta) is the same as link(eta,1) when size(eta,2)=1
% link(eta,':') returns {link(eta,1),link(eta,2),...}


if nargin==1 && size(eta,2)>1
    error('You must specify a coordinate dimension')
end
if nargin==1, dim=1; end

if strcmp(dim,':')
    l = cell(1,size(eta,2));
    for i=1:length(l)
        l{i}=link(eta,i);
    end
else
    l.value = eta(:,dim);
    l.J = zeros(size(eta));
    l.J(:,dim)=1;
    l = class(l,'link');
end