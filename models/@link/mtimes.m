function c = mtimes(a,b)
% * for link and scalar

switch [class(a),class(b)]
    case 'doublelink'
        if max(size(a))>1, error('mtimes only defined for scalar*link'); end
        c = b;
        c.value = a.*c.value;
        c.J = bsxfun(@times,a,c.J);
    case 'linkdouble'
        if max(size(b))>1, error('mtimes only defined for scalar*link'); end
        c = a;
        c.value = c.value.*b;
        c.J = bsxfun(@times,c.J,b);
    otherwise
        error(['mtimes not defined for ',class(a),' and ',class(b)])
end