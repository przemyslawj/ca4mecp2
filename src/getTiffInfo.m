function tiff_info = getTiffInfo(fpath)
% Returns structure with metadata information about Ca timelapse recording
% based on the filename convention.

[~,fname] = fileparts(fpath);
parts = strsplit(fname, '[_ ]', 'DelimiterType', 'RegularExpression');
recording_date = parts{1};
condition = parts{2};
culture_date = parts{4}(1:4);
embryo_id = parts{4}(5:end);
p_day = parts{5};
div = parts{6};
coverslip_id = extractNum(parts{7});
fr_id = extractNum([parts{8:9}]);

tiff_info = cell2struct({ fname,...
                           condition, culture_date, embryo_id, p_day,...
                           div, coverslip_id,...
                           fr_id,...
                           recording_date }, ...
                         { 'filename',...
                           'condition', 'culture_date', 'embryo_id', 'p_day',...
                           'div', 'coverslip_id', 'fr_id', 'recording_date' },...
                         2);
end

function number = extractNum(str)
[i, j] = regexp(str,'\d+');
number = str(i:j);
end
