function c = uminus(a)
% 

c = a;
c.value = -c.value;
c.J = -c.J;