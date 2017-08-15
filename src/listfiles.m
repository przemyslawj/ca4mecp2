function [result] = listfiles(src_dir, filenamepattern)
% Returns an array of file paths matching filenamepattern and found recursively
% in src_dir

    allfiles = dir(src_dir);
    result = {};
    for i = 1:length(allfiles)
        fname = allfiles(i).name;
        if (allfiles(i).isdir == 1) & ~strcmp(fname, '.') & ~strcmp(fname,'..')
            result = [result listfiles([src_dir '/' allfiles(i).name], filenamepattern)];
        else
            if ~allfiles(i).isdir & (regexp(fname, filenamepattern))
                file = [src_dir '/' fname];
                result = [result file];
            end
        end
    end
end
