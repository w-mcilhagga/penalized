function c = power(a,b)
% elementwise multiplication for link objects

switch [class(a),class(b)]
    case 'linkdouble'
        c = a;
        c.value = a.value.^b;
        c.J = bsxfun(@times,b.*a.value.^(b-1),c.J);
    case {'doublelink','linklink'}
        c = exp(log(a).*b);
    otherwise
        error(['power not defined for ',class(a),' and ',class(b)])
end