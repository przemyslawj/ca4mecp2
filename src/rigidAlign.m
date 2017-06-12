function r = rigidAlign( fname )
% code adapted from https://scanbox.org/2014/03/20/recursive-image-alignment-and-statistics/
    finfo = imfinfo(fname);
    tiff_len = numel(finfo);
    mimg_len = min(20, tiff_len);
    mimg = meanimg(fname, 1:mimg_len);

    r.T = zeros(mimg_len, 2);
    for i=1:tiff_len
        A = imread(fname, i);
        [u, v] = fftalign(mimg, A);
        r.T(i,:) = [u, v];
    end
    
end
