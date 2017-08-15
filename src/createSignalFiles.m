% Reads in .tiff files with Ca timelapse and extracts values of fluorescence
% for ROI in zip files with ROI placed in data_root_dir according to structure
% defined in README.md. The output Matlab data file contains fluorescence
% values as well as metadata for the recorded signal, e.g. recording date,
% culture genotype and ROIs location.

data_root_dir = '/home/przemek/neurodata/ca_mecp2_culture';
output_dir = [data_root_dir '/signal'];
aligned_tiffs_dir = [data_root_dir '/Mecp2_cultures_aligned'];

tiff_files = listfiles(aligned_tiffs_dir, '.*tiff');

for i=1:numel(tiff_files)
    fname = tiff_files{i};
    tiff_info = getTiffInfo(fname);
    d = tiff_info.recording_date;
    dated_dir = ['20' d(1:2) '-' d(3:4) '-' d(5:6)];
    filepattern = ['C' tiff_info.coverslip_id '.*Fr.*' tiff_info.fr_id '.*3D'];
    roi_tiff_files = listfiles([data_root_dir filesep dated_dir], [filepattern '.*tif']);
    roi_zip_files = listfiles([data_root_dir filesep dated_dir], [filepattern '.*zip']);
    output_f = [output_dir filesep tiff_info.filename '.mat'];

    if ~isempty(roi_tiff_files) && ~isempty(roi_zip_files) && ~exist(output_f, 'file')
        sprintf('processing file %s\n', fname)
        dat = extractSignal(roi_tiff_files{1}, roi_zip_files{1}, fname);
        dat.finfo = tiff_info;
        save(output_f, 'dat');
    else
        if ~exist(output_f, 'file')
            sprintf('no roi defined for %s\n', fname)
        end
    end
end
