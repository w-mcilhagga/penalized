function panels(varargin)
% panels moves subplots around. 
%
% Usage: panels(...)
%
% Inputs:
%   The first argument can be a figure handle. If omitted, panelize works
%   on the currect figure.
%   Subsequent arguments are key-value pairs. The keys are:
%   'margins' : all the margin sizes
%   'left', 'right', 'top', 'bottom': margin sizes to override existing
%               ones.
%   'gap' : the gaps between figures
%   'vgap', 'hgap' : vertical and horizontal gaps (which may be arrays).
%
% margins and gaps are evaluated in order, so 'vgap',5,'gap',2 makes the
% vertical gap equal to 2.
%
% You can usually cann panelize repeatedly, unless the gap size gets too
% small, in which case stupid things happen.

% parse first argument
if ~ischar(varargin{1}) % should be a figure
    f = varargin{1};
    varargin = varargin(2:end);
else
    f = gcf;
end

% extract the axes from the figure
c = get(f,'children');
ax=[];
for i=1:length(c)
    if strcmp(get(c(i),'type'),'axes') && isempty(get(c(i),'tag'))
        ax=[ax,c(i)];
    end
end

% discover the row, column boundaries
ypos=[0,0;1,1];
xpos=[0,0;1,1];
for i=1:length(ax)
    pos  = get(ax(i),'position');
    xpos = [xpos; pos(1), pos(1)+pos(3)];
    ypos = [ypos; pos(2), pos(2)+pos(4)];
end
ypos = unique(ypos,'rows');
xpos = unique(xpos,'rows');
ypos([1 end],:)=[];
xpos([1 end],:)=[];
ypos = sort(ypos(:)); xpos=sort(xpos(:));

% discover the vertical, horizontal gaps
vgaps=[];
hgaps=[];
for i=2:2:length(xpos)-1
    hgaps=[hgaps,xpos(i+1)-xpos(i)];
end
for i=2:2:length(ypos)-1
    vgaps=[vgaps,ypos(i+1)-ypos(i)];
end

% get margins and replace with any options
margins = struct('left',xpos(1),'right',1-xpos(end),'bottom',ypos(1),'top',1-ypos(end));
for i=1:2:length(varargin)
    switch (varargin{i})
        case {'margins','margin'}
            m = varargin{i+1};
            margins.left=m;
            margins.right=m;
            margins.top=m;
            margins.bottom=m;
        case {'left','left margin'}
            margins.left = varargin{i+1};
        case {'right','right margin'}
            margins.right = varargin{i+1};
        case {'top','top margin'}
            margins.top = varargin{i+1};
        case {'bottom','bottom margin'}
            margins.bottom = varargin{i+1};
    end
end

% create a lookup for the new row, col places
newx=xpos;
newy=ypos;

% set margins
newx(1)=margins.left;
newx(end)=1-margins.right;
newy(1)=margins.bottom;
newy(end)=1-margins.top;

% get gaps
for i=1:2:length(varargin)
    g = varargin{i+1};
    switch varargin{i}
        case {'gaps','gap'}
            hgaps = ones(size(hgaps)).*g;
            vgaps = ones(size(vgaps)).*g;
        case {'vgaps','vgap','vertical gap','vertical gaps','vertical','v'}
            vgaps = ones(size(vgaps)).*g;
        case {'hgaps','hgap','horizontal gap','horizontal gaps','horizontal','h'}
            hgaps = ones(size(hgaps)).*g;
    end
end

% gaps, evenly spaced next
xsize = (newx(end)-newx(1))/(length(newx)/2);
for i=2:2:length(newx)-1
    newx(i)=newx(i-1)+xsize-hgaps(i/2)/2;
    newx(i+1)=newx(i)+hgaps(i/2);
end

ysize = (newy(end)-newy(1))/(length(newy)/2);
for i=2:2:length(newy)-1
    newy(i)=newy(i-1)+ysize-vgaps(i/2)/2;
    newy(i+1)=newy(i)+vgaps(i/2);
end

% create new pos
for i=1:length(ax)
    pos=get(ax(i),'position');
    a = find(abs(ypos-pos(2))<eps);
    b = find(abs(ypos-pos(2)-pos(4))<eps);
    pos(2)=newy(a(1));
    pos(4)=newy(b(1))-pos(2);
    a = find(abs(xpos-pos(1))<eps);
    b = find(abs(xpos-pos(1)-pos(3))<eps);
    pos(1) = newx(a(1));
    pos(3) = newx(b(1))-pos(1);
    set(ax(i),'position',pos);
end
