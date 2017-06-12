function [ M ] = meanimg( fname, frames )
    M = imread(fname, frames(1)) - imread(fname, frames(1));
    for i=1:length(frames)
        frame_index = frames(i);
        A = imread(fname, frame_index);
        M = M + A;
    end
    M = M / length(frames);
end

