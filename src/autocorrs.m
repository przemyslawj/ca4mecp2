function [ peak_lags, peak_vals, A, lag ] = autocorrs( dF )
% Calculates cell autocorrelations on the signal
%   Returns 
%      lag for which autocorrelation reaches peak, the peak around
%        lag=0 is ignored.
%      acorr - matrix with auto correlation for all cells

peak_lags = [];
peak_vals = [];
ncells = size(dF, 1);
lag_span = round(size(dF, 2) / 4);
A = zeros(ncells, 2 * lag_span + 1);
for i=1:ncells
    [acorr,lag] = xcorr(dF(i,:)', lag_span, 'coeff');
    positive_lags_i = ceil(numel(lag) / 2): numel(lag);
    [vals,locs] = findpeaks(acorr(positive_lags_i), 'MinPeakDistance', lag_span / 2);
    pos_corr = find(vals >= 0.2);
    if ~isempty(pos_corr)
        peak_lags = [peak_lags locs(pos_corr)'];
        peak_vals = [peak_vals vals(pos_corr)'];
    end
    A(i,:) = acorr;
end

end
