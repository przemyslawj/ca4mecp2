function [ peak_lags, peak_vals, A, lag ] = autocorrs( dF )
% Calculates cell autocorrelations on the signal
%   Returns 
%      lag for which autocorrelation reaches peak, the peak around
%        lag=0 is ignored.
%      acorr - matrix with auto correlation for all cells

ncells = size(dF, 1);
peak_lags = zeros(1,ncells);
peak_vals = zeros(1,ncells);
lag_span = round(size(dF, 2) / 4);
A = zeros(ncells, 2 * lag_span + 1);
for i=1:ncells
    [acorr,lag] = xcorr(dF(i,:)', lag_span, 'coeff');
    positive_lags_i = ceil(numel(lag) / 2): numel(lag);
    [vals,locs] = findpeaks(acorr(positive_lags_i),...
                           'MinPeakDistance', lag_span / 2,...
                           'SortStr', 'descend',...
                           'NPeaks', 1);
    
    if ~isempty(locs)
        peak_lags(i) = locs(1);
        peak_vals(i) = vals(1);
    end
    A(i,:) = acorr;
end

end
