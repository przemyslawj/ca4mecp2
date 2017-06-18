function [ result ] = filterFstat( fstat )
% Returns dat structure only with data for cells that should be kept

result = struct(fstat);

if isfield(fstat,'cells_selected')
    keep_cells = fstat.cells_selected;
else
    %%Remove noisy and cells without events
    min_events = 4;
    dF_max = 3;
    cells_not_noisy = find(max(abs(fstat.dF), [], 2) <= dF_max);
    cell_signal_diff = mean(fstat.Fcell, 2) ...
                       - mean(fstat.FcellNeu, 2) ...
                       - 0.6 * std(fstat.FcellNeu, [], 2);
    keep_cells = find(fstat.event_counts >= min_events & cell_signal_diff > 0);
    keep_cells = sort(intersect(keep_cells, cells_not_noisy));
end

result.dF = fstat.dF(keep_cells,:);
result.Fcell = fstat.Fcell(keep_cells,:);
result.FcellNeu = fstat.FcellNeu(keep_cells,:);

result.peaks = fstat.peaks(keep_cells);
result.peak_extends = fstat.peak_extends(keep_cells,:);
result.event_counts = fstat.event_counts(keep_cells);
result.acorrs = fstat.acorrs(keep_cells,:);
result.max_lag = fstat.max_lag(keep_cells);
result.active_rate = fstat.active_rate(keep_cells);
result.ncells = numel(keep_cells);

result.keep_cells = keep_cells;
end

