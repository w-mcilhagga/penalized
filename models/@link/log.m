function c = log(a)
% logarithm

c = a;
c.value = log(c.value);
c.J = bsxfun(@times,1./a.value,c.J);