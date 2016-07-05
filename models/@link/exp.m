function c = exp(a)
% exponentiation

c = a;
c.value = exp(c.value);
c.J = bsxfun(@times,c.value,c.J);