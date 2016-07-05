function c = plus(a,b)
% adding link objects

switch [class(a),class(b)]
    case 'doublelink'
        c = b;
        c.value = c.value+a;
    case 'linkdouble'
        c = a;
        c.value = c.value+b;
    case 'linklink'
        c = a;
        c.value = c.value+b.value;
        c.J = c.J+b.J;
    otherwise
        error(['plus not defined for ',class(a),' and ',class(b)])
end