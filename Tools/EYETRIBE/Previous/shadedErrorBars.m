function [f,range]= shadedErrorBars(x, y, y_sem,col)

% x = tm;
% y = Y(1,:);
% y_sem = Ysem(1,:);

top = y + y_sem;
bot = y - y_sem;

yy = [top bot(end:-1:1)];
xx = [x   x(end:-1:1)];
range.x = [min(xx), max(xx)];
range.y = [min(yy), max(yy)];

f = fill(xx, yy, col);
set(f, 'linestyle', 'none','facealpha',0.3)
