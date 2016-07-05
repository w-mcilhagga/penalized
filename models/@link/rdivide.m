function c = rdivide(a,b)
% elementwise division ./ for link objects

switch [class(a),class(b)]
    case 'doublelink'
        c = b;
        c.value = a./b.value;
        c.J = bsxfun(@times,-a./b.value.^2,c.J);
    case 'linkdouble'
        c = a;
        c.value = c.value./b;
        c.J = bsxfun(@rdivide,c.J,b);
    case 'linklink'
        c = a.*(1./b);
    otherwise
        error(['rdivide not defined for ',class(a),' and ',class(b)])
end