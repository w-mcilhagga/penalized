function ok = strfound(str,cellstr)
% faster than strmatch for my purposes
ok = 0;
for i=1:length(cellstr)
    if strcmp(str,cellstr{i}), ok=i; break, end
end