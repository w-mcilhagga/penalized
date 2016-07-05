function b = subsref(a,index)
%SUBSREF Define field name indexing for link objects
switch index.type
    case '.'
        switch index.subs
            case 'value'
                b = a.value;
            case 'J'
                b = a.J;
            otherwise
                error('Invalid field name')
        end
    case '()'
        b=a;
        b.value = a.value(index.subs{1});
        b.J = a.J(index.subs{1},:);
    otherwise
        error('Invalid reference')
end