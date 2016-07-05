function c = mrdivide(a,b)
% elementwise division ./ for link objects

switch [class(a),class(b)]
    case 'doublelink'
        if max(size(a))>1, error('mrdivides only defined for scalar*link'); end
        c = b;
        c.value = a./b.value;
        c.J = bsxfun(@times,-a./b.value.^2,c.J);
    case 'linkdouble'
        if max(size(b))>1, error('mrdivides only defined for scalar*link'); end
        c = a;
        c.value = a.value./b;
        c.J = bsxfun(@rdivide,a.J,b);
    otherwise
        error(['mrdivide not defined for ',class(a),' and ',class(b)])
end