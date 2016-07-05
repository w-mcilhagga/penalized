function c = minus(a,b)
% subtracting link objects

switch [class(a),class(b)]
    case 'doublelink'
        c = b;
        c.value = a-b.value;
        c.J = -c.J;
    case 'linkdouble'
        c = a;
        c.value = a.value-b;
    case 'linklink'
        c = a;
        c.value = a.value-b.value;
        c.J = a.J-b.J;
    otherwise
        error(['minus not defined for ',class(a),' and ',class(b)])
end