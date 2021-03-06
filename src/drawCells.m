function drawCells(dat, cell_indecies)
% Shows 3d stack image with overlayed cells

cells = dat.stat;
if nargin < 2
    cell_indecies = 1:numel(cells);
end

img = dat.mimg;
if isfield(dat,'roi_img')
    img = dat.roi_img;
end
image(img);

hold on;

% draw each ROI
for i=1:numel(cell_indecies)
    cell_index = cell_indecies(i);
    x = cells(cell_index).xpix;
    y = cells(cell_index).ypix;
    bw = boundary(x,y);

    plot(x(bw), y(bw), 'r');
    text(max(x), mean(y), ...
        num2str(cell_index),...
        'Color', 'r');
end
hold off;
end
