function drawCells(dat)
% Shows 3d stack image with overlayed cells

image(dat.roi_img);

hold on;

cells = dat.stat;
% draw each ROI
for i=1:numel(cells)
        x = cells(i).xpix;
        y = cells(i).ypix;
        bw = boundary(x,y);
        
        plot(x(bw), y(bw), 'r');
        text(max(x), mean(y), ...
            num2str(i),...
            'Color', 'r');
end
hold off;
end
