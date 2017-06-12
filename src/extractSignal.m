function [ dat ] = extractSignal( roi_imagf, roi_fname, fname )
% Extracts fluorescence signal from tiff for given ROI
%   Params:
%     roi_imagf - filepath of 3d stack tiff 
%     roi_fname - filepath of ROI zip file for roi_imagf
%     fname - tiff recording with fluorescence changes
%   Returns: 
%     dat - structure with Fcell, FcellNeu and extraced cell info


roi_iminfo = imfinfo(roi_imagf);
roi_img = imread(roi_imagf);
rois = ReadImageJROI(roi_fname);

tiff_finfo = imfinfo(fname);
tiff_len = numel(tiff_finfo);
scale = gray;
tiff_scale = tiff_finfo(1).Width / roi_iminfo.Width;

roi_img_scaled = imresize(roi_img, tiff_scale);

mimg = meanimg(fname, 1:min(20,tiff_len));
[u, v] = fftalign(mimg, roi_img_scaled(:,:,1));

%% create cellstruct
cells = cell(numel(rois),4);
for i=1:numel(rois)
    roi_cell = rois(i);
    if ~isfield(roi_cell{1}, 'mnCoordinates')
        sprintf('Does not support ROI shape %s', roi_cell{1}.strType)
    end
    scaled_boundary = roi_cell{1}.mnCoordinates * tiff_scale;
    cords = unique(round(scaled_boundary), 'rows');
    translation = ones(size(cords, 1),1) * [v u];
    cords = cords - translation;
    centroid = round([mean(cords(:,1)), mean(cords(:,2))]);
    cells{i,1} = cords(:,1);
    cells{i,2} = cords(:,2);
    bw = boundary(cords(:,1), cords(:,2));
    cells{i,3} = polyarea(cords(bw,1), cords(bw,2));
    cells{i,4} = centroid;
end
cell_headings = {'xpix', 'ypix', 'npix', 'med'};
cellstruct = cell2struct(cells, cell_headings, 2);

%% calculate Fcell and FcellNeu
% all cells mask

width = tiff_finfo(1).Width;
height = tiff_finfo(1).Height;
cells_mask = zeros(width, height);
for i=1:numel(cellstruct)
    x = cellstruct(i).xpix;
    y = cellstruct(i).ypix;
    if x >= 1 & x <= width & y >= 1 & y <= height
        %cells_mask(sub2ind(size(cells_mask), x, y)) = 1;
        cells_mask = cells_mask + poly2mask(x, y, width, height);
    end
end

Fcell = zeros(numel(cellstruct), tiff_len);
FcellNeu = zeros(numel(cellstruct), tiff_len);

roi_masks = zeros(numel(cellstruct),width,height);
neu_masks = zeros(numel(cellstruct),width,height);

for j=1:numel(cellstruct)
    x = cellstruct(j).xpix;
    y = cellstruct(j).ypix;
    roi_masks(j,:,:) = poly2mask(x, y, width, height);
    
    neu_radius = 4;
    cell_radius = sqrt(cellstruct(j).npix / pi);
    radius = cell_radius + neu_radius;

    cx = cellstruct(j).med(1);
    cy = cellstruct(j).med(2);
    [x,y] = meshgrid(-(cx-1):(width-cx),-(cy-1):(height-cy));
    neu_circle = x.^2 + y .^ 2 <= radius .^ 2;
    neu_masks(j,:,:) = (1 - cells_mask)  .* neu_circle;
end

for i=1:tiff_len
    A = imread(fname,i);
    A = imgaussfilt(A,0.6);
    for j=1:size(roi_masks,1)
        roi_mask = squeeze(roi_masks(j,:,:));
                
        Fcell(j,i) = avgMask(A, roi_mask);
        % TODO: gaussian filter/mexican hat
        neu_mask = squeeze(neu_masks(j,:,:));
        FcellNeu(j,i) = avgMask(A, neu_mask);
    end
end

dat = struct();
dat.Fcell{1} = Fcell;
dat.FcellNeu{1} = FcellNeu;
dat.stat = cellstruct;
dat.mimg = mimg;
dat.filename = fname;
dat.cl.Lx = width;
dat.cl.Ly = height;

dat.roi_img = circshift(roi_img_scaled, -[v u]);

end

function x = avgMask(A, mask)
    vals = double(A) .* double(mask);
    x = sum(vals(:)) / sum(mask(:));
end

