function [ peak_extends, thresholds, peaks, event_counts ] = detectEvents( F, vargs )
% Detects events in the signal
% Events are detected when amplitutde of the signal crosses a threshold
% set to a multiplication of stddev.
%   param F is a matrix with signal, of size cells x timepoints
%   param vargs is a struct with params for event detection:
%     stddev - multiplier for stddev when setting the event threshold
%     min_duration - min duration in frames
%
% Returns:
%   event_bins - logical matrix true for each time point for a given
%   cell which is part of an event
%   thresholds - list of signal threshold used for event detection for each cell
%   peaks - list of array of peaks objects

if nargin < 2
    vargs.stddev = 1.5;
    vargs.min_duration = 5;
    vargs.min_peak_distance = 20;
    % base of the peak is estimated at amplitude equal to peak_base of the
    % max peak amplitude
    vargs.peak_base = 0.2;
end

cell_count = size(F,1);
peak_extends = zeros(size(F));
%thresholds = mean(F,2) + vargs.stddev * std(F,0,2);
thresholds = zeros(cell_count,1);

% vector with peak struct containing start, end and amplitutde
peaks = cell(cell_count,1);

for cell_index = 1:cell_count

    peak_extends(cell_index,:) = F(cell_index,:) > thresholds(cell_index);
    %[pks,locs]= findpeaks(F(cell_index,:), ...
    %                    'MinPeakHeight',thresholds(cell_index),...
    %                    'MinPeakDistance',vargs.min_peak_distance,...
    %                    'MinPeakWidth', vargs.min_duration);
    peaks_str = ['0' sprintf('%d',peak_extends(cell_index,:)) '0'];
    peak_starts = strfind(peaks_str, '01');
    peak_endings = strfind(peaks_str, '10');

    %% extend the peak width
    % it is extended to the left and rigtht to a point at the base with
    % amplitude equal to peak_base * max_amplitude
    for j=1:length(peak_starts)
        li = peak_starts(j);
        ri = peak_endings(j)-1;
        min_peak_amp = vargs.peak_base * max(F(cell_index,li:ri));
        while li > 0 && F(cell_index,li) >= min_peak_amp
            li = li - 1;
        end
        while ri <= size(F,2) && F(cell_index, ri) >= min_peak_amp
            ri = ri + 1;
        end

        li = li + 1;
        ri = ri - 1;
        is_peak = 1;
        if (ri - li + 1 < vargs.min_duration)
            is_peak = 0;
        end
        peak_extends(cell_index,li:ri) = is_peak;
    end

    % struct arrays with peak information
    peak_arr = [];

    peaks_str = ['0' sprintf('%d',peak_extends(cell_index,:)) '0'];
    peak_starts = strfind(peaks_str, '01');
    peak_endings = strfind(peaks_str, '10') - 1;
    for j=1:length(peak_starts)
        peak_start = max(peak_starts(j) - 1, 1);
        base_amp = F(cell_index, peak_start);
        [peak_amp, peak_loc] = max(F(cell_index,peak_start:peak_endings(j)));
        increase_rate = (peak_amp - base_amp) / peak_loc;
        new_peak = {cell_index,...
                    peak_amp, increase_rate,...
                    peak_starts(j), peak_endings(j), ...
                    peak_endings(j) - peak_starts(j)};
        peak_arr = [peak_arr; new_peak];
    end

    peak_headings = {'cell_index', 'amplitude','increase_rate',...
                     'start_index', 'end_index', 'duration'};
    if ~isempty(peak_arr)
        peaks{cell_index} = cell2struct(peak_arr,peak_headings,2);
    else
        peaks{cell_index} = struct('cell_index', {}, 'amplitude',{},...
                                   'increase_rate', {}, 'start_index', {},...
                                   'end_index',{},'duration',{});
    end
end

peak_extends = double(peak_extends);

event_counts = get_event_counts(peak_extends);

end

function event_counts = get_event_counts(peak_extends)
    event_counts = zeros(size(peak_extends,1), 1);
    for i=1:size(peak_extends)
        events_str = sprintf('%d',peak_extends(i,:));
        event_endings = strfind(events_str, '10');
        event_counts(i) = length(event_endings);
        if events_str(end) == '1'
           event_counts(i) = event_counts(i) + 1;
        end
    end
end

