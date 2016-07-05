function c = times(a,b)
% elementwise multiplication for link objects

switch [class(a),class(b)]
    case 'doublelink'
        c = b;
        c.value = a.*c.value;
        c.J = bsxfun(@times,a,c.J);
    case 'linkdouble'
        c = a;
        c.value = c.value.*b;
        c.J = bsxfun(@times,c.J,b);
    case 'linklink'
        c = a;
        c.value = c.value.*b.value;
        c.J = bsxfun(@times,a.value,b.J)+bsxfun(@times,b.value,a.J);
    otherwise
        error(['times not defined for ',class(a),' and ',class(b)])
end