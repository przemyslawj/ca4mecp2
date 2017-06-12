function [ result ] = FStats(dat)

event_detect.stddev = 1.0;
event_detect.min_duration = 5;
event_detect.min_peak_distance = 5;
event_detect.peak_base = 0.2;
min_events = 4;
dF_max = 3;

Fcell = dat.Fcell{1};
FcellNeu = dat.FcellNeu{1};
F = Fcell - 0.7 * FcellNeu;
dF = dFOverF(F);
% Smooth the signal
dF = exp_smooth(dF, 0.2);

[peak_extends, ~, peaks, event_counts] = detectEvents(dF, event_detect);
active_rate = mean(peak_extends, 2)';

%%Remove noisy and cells without events
cells_not_noisy = find(max(dF, [], 2) <= dF_max);
cell_signal_diff = mean(Fcell, 2) - mean(FcellNeu, 2) - 0.6 * std(FcellNeu, [], 2);
keep_cells = find(event_counts >= min_events & cell_signal_diff > 0);
keep_cells = sort(intersect(keep_cells, cells_not_noisy));

if isfield(dat,'cells_selected')
    keep_cells = dat.cells_selected;
end

dF1 = dF(keep_cells,:);

peaks = peaks(keep_cells);
peak_extends = peak_extends(keep_cells,:);
event_counts = event_counts(keep_cells);
active_rate = active_rate(keep_cells);

[max_lag, ~, ACORRS, ~] = autocorrs(dF1);

result = cell2struct({ ...
                       dat.finfo, dF, keep_cells,...
                       peaks, peak_extends, event_counts,...
                       max_lag, mean(ACORRS,1), active_rate...
                     },...
                     { 
                       'fileinfo', 'dF', 'keep_cells',...
                       'peaks', 'peak_extends', 'event_counts'...
                       'max_lag', 'avg_acorr', 'active_rate'...
                     },...
                     2);

end

