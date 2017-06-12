input_dir = '/home/przemek/neurodata/ca_mecp2_culture/tmp';
out_dir = '/home/przemek/neurodata/ca_mecp2_culture/Mecp2_cultures_aligned2';

inputfiles = listfiles(input_dir, '.*tif');

for file_index=1:numel(inputfiles)
    fname = inputfiles{file_index};
    sprintf('aligning file %s', fname);
    [~,filename,ext] = fileparts(fname);

    r = rigidAlign(fname);
    tiff_len = numel(imfinfo(fname));
    output_f = [out_dir '/' filename '_aligned' ext];
    for i=1:tiff_len
        data = imread(fname,i);
        data_t = circshift(data, -r.T(i,:));
        imwrite(data_t,output_f,'WriteMode','append');
    end
end
