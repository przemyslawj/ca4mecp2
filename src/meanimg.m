function [ M ] = meanimg( fname, frames )
% Mean image calculated across given frames
%   Params:
%     fname - filepath of tiff image with Ca timelapse
%     frames - vector with numbers of frames used for mean image calculation
%   Returns:
%     M - matrix (img height x img width) with fluorescence values averaged
%       across the selected frames
%

    M = imread(fname, frames(1)) - imread(fname, frames(1));
    for i=1:length(frames)
        frame_index = frames(i);
        A = imread(fname, frame_index);
        M = M + A;
    end
    M = M / length(frames);
end

