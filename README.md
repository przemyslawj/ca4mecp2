# Analysis of Calcium Imaging recordings from Mecp2 deficient cortical cultures
Repository contains scripts for pre-processing the calcium imaging data
and Matlab notebooks for analysis.

## Pre-processing
### Frame alignment / registration
Script `align_files.m` reads tiff images with the timelapse recording and
shifts the frames so possible movements during the recording are corrected.
The frames are shifted by distance which best autocorrelates the image with
the mean image at the beginning of the recording.

Update `input_dir` and `out_dir` variables before running.

### Extracting signal
Script `createSignalFiles.m` creates `.mat` files with fluorescence signal
extracted from aligned tiff files. The signal is extracted from zip files with
ROT created by ImageJ.
Update `data_root_dir` and `aligned_tiffs_dir` variables before running.

`data_root_dir` needs to be organised into subfolders named by their recording
date, e.g 2017-06-01. Subfolders need to contain:
- zip files with ROI following naming convention:
  C<coverslipid>_Fr<frame_id> 3D.zip
- tif files with 3d stack projection from which ROI was extracted, following
  the same naming convention as zip files but with _tif_ extension
Example of `data_root_dir` contents:
<pre>.
├── 2017-05-10
│   ├── C1 Frame 1 3D.tif
│   ├── C1 Frame 1 3D.zip
│   ├── C1 Frame 2 3D.tif
│   ├── C1 Frame 2 3D.zip
└── 2017-05-11
   ├── C1 Frame 1 3D.tif
   └── C1 Frame 1 3D.zip
</pre>

### Filtering ROI for analysis
Run `select_cells.m` script to manually filter cells used for analysis. The
script iterates over all ROIs asking if it should be included. The script
creates  a new _.mat_ data file with  `_selected` suffix, it extends the
original struct with the `cells_selected` field to the struct.

## Data analysis in Matlab Notebooks
- `event_analysis.mlx` - analysis of a single recording, requires loading
  of _.dat_ file with extracted signal before running
- `comparison.mlx` - comparison of recordings between the conditions

