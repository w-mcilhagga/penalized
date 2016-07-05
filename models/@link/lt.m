function c = lt(a,b)
% comparing link objects; returns a logical vector

switch [class(a),class(b)]
    case 'doublelink'
        c = a<b.value;
    case 'linkdouble'
        c = a.value<b;
    case 'linklink'
        c = a.value<b.value;
    otherwise
        error(['< not defined for ',class(a),' and ',class(b)])
end