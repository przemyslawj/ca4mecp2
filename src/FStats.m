function [ result ] = FStats( Fcell, FcellNeu, fileinfo )

event_detect.stddev = 1.0;
event_detect.min_duration = 5;
event_detect.min_peak_distance = 5;
event_detect.peak_base = 0.2;
min_events = 4;
dF_max = 3;

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
dF1 = dF(keep_cells,:);

peaks = peaks(keep_cells);
active_rate = active_rate(keep_cells);

[max_lag, ~, ACORRS, ~] = autocorrs(dF1);

result = cell2struct({ fileinfo, peaks, max_lag, mean(ACORRS,1), active_rate },...
                     { 'fileinfo', 'peaks', 'max_lag', 'avg_acorr', 'active_rate' },...
                      2);

end

