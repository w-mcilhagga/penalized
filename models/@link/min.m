function c = min(a,b)
% min of two - and only two - link/doubles
if nargin>2, error('overloaded max only accepts 2 arguments'); end

switch [class(a),class(b)]
    case 'doublelink'
        c = b;
        wipe = c.value>a;
        if max(size(a))==1
            c.value(wipe)=a;
        else
            c.value(wipe) = a(wipe);
        end
        c.J(~ok,:) = 0;
    case 'linkdouble'
        c = a;
        wipe = c.value>b;
        if max(size(b))==1
            c.value(wipe)=b;
        else
            c.value(wipe) = b(wipe);
        end
        c.J(wipe,:) = 0;
    case 'linklink'
        c = a;
        wipe = a.value>b.value;
        c.value(wipe) = b.value(wipe);
        c.J(wipe,:) = b.J(wipe,:);
    otherwise
        error(['max not defined for ',class(a),' and ',class(b)])
end