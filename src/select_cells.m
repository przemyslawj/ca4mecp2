% Need to load .dat file with the signal
out_dir = '/media/przemek/Data/neurodata/ca_mecp2_culture/signal_selected';

Fcell = dat.Fcell{1};
FcellNeu = dat.FcellNeu{1};

stat = FStats(dat);
peaks = stat.peaks;
dF = stat.dF;

[path,fname,ext] = fileparts(dat.filename);

cells_selected = [];
roi_count = numel(keep_cells);
for cell_index=1:roi_count
    i = keep_cells(cell_index);
    
    subplot(4,1,[1 2]);
    drawCells(dat,i);
    
    subplot(4,1,3);
    plot(Fcell(i,:),'color','b');
    hold on;
    plot(FcellNeu(i,:),'color','r');
    title(sprintf('Fluorescence for ROI %d', i));
    hold off;
        
    subplot(4,1,4);
    plotTrace(dF(i,:), 0, peaks{i}, 2.8);
    title(sprintf('Trace for ROI %d', i));
    
    prompt = sprintf('Do you want to keep %d out of %d? y/n [y]: ',...
                      cell_index, roi_count);
    str = lower(input(prompt,'s'));
    if isempty(str)
        str = 'y';
    end
    if strcmp(str, 'y')
        cells_selected = [cells_selected i];
    end
end

dat.cells_selected = cells_selected;

output_f = [out_dir filesep fname '_selected.mat'];
save(output_f, 'dat');

