function [ result ] = FStats(dat)

event_detect.stddev = 1.0;
event_detect.min_duration = 5;
event_detect.min_peak_distance = 5;
event_detect.peak_base = 0.2;

Fcell = dat.Fcell{1};
FcellNeu = dat.FcellNeu{1};
F = Fcell - 0.7 * FcellNeu;
dF = dFOverF(F);
% Smooth the signal
dF = exp_smooth(dF, 0.2);

[peak_extends, ~, peaks, event_counts] = detectEvents(dF, event_detect);
active_rate = mean(peak_extends, 2)';

[max_lag, ~, ACORRS, ~] = autocorrs(dF);

result = cell2struct({ ...
                       dat.finfo, dF, Fcell, FcellNeu,...
                       peaks, peak_extends, event_counts,...
                       max_lag, ACORRS, active_rate...
                     },...
                     { 
                       'fileinfo', 'dF', 'Fcell','FcellNeu',...
                       'peaks', 'peak_extends', 'event_counts',...
                       'max_lag', 'acorrs', 'active_rate'...
                     },...
                     2);

end

