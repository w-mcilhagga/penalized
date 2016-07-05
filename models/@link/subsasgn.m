function a = subsasgn(a,S,b)
% assignment to link objects

if ~strcmp(S.type,'()')
    error('Unsupported subsasgn');
end
idx = S.subs{1};
switch [class(a),class(b)]
    case 'linkdouble'
        a.value(idx)=b;
        a.J(idx,:)=0;
    case 'linklink'
        a.value(idx) = b.value;
        a.J(idx,:) = b.J;
    otherwise
        error(['== not defined for ',class(a),' and ',class(b)])
end