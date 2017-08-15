function [ result ] = FStats(dat)
% Calculates statistics on fluorescence signal of the cells.
%   Params:
%     dat - structure with cell data as returned by extractSignal function
%   Returns:
%     result - structure with metadata and statistics computed for each cell
%

event_detect.stddev = 1.0;
event_detect.min_duration = 5;
event_detect.min_peak_distance = 5;
event_detect.peak_base = 0.2;

Fcell = dat.Fcell{1};
FcellNeu = dat.FcellNeu{1};
dF = dFOverF(Fcell);
dF = exp_smooth(dF, 0.4);

[peak_extends, ~, peaks, event_counts] = detectEvents(dF, event_detect);
active_rate = mean(peak_extends, 2)';

[max_lag, ~, ACORRS, ~] = autocorrs(dF);
ncells = size(dF,1);

result = cell2struct({ ...
                       dat.finfo, dF, Fcell, FcellNeu,...
                       peaks, peak_extends, event_counts,...
                       max_lag, ACORRS, active_rate, ncells...
                     },...
                     {
                       'fileinfo', 'dF', 'Fcell','FcellNeu',...
                       'peaks', 'peak_extends', 'event_counts',...
                       'max_lag', 'acorrs', 'active_rate', 'ncells'...
                     },...
                     2);

end

