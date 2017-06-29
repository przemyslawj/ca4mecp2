function [cluster_phases] = clusterMeanPhaseShift(dF, cluster_index)

signal_shifts = zeros(size(dF,1));
shift_fitness = zeros(size(dF,1));
fft_dF = fft(dF')';
for i = 1:size(dF,1)
    for j = 1:size(dF,1)
        f_y1 = fft_dF(i,:);
        f_y2 = fft_dF(j,:);
        f_shift = f_y1(1:end/2) / f_y2(1:end/2);
        signal_shifts(i,j) = angle(f_shift);
        shift_fitness(i,j) = norm(f_y1(1:end/2) - f_shift * f_y2(1:end/2));
    end
end

%[~,I] = sort(cluster_index);
%imagesc(signal_shifts(I,I))

cluster_count = max(cluster_index);
cluster_phases = zeros(cluster_count);
cluster_pairs = nchoosek(1:cluster_count,2);
for i=1:size(cluster_pairs,1)
    fst_c = cluster_pairs(i,1);
    snd_c = cluster_pairs(i,2);
    fst_roi = cluster_index==fst_c;
    snd_roi = cluster_index==snd_c;
    
    A = signal_shifts(fst_roi,snd_roi);
    angles = A(:);
    shift = rad2deg(atan2(sum(sin(angles)), sum(cos(angles))));
    cluster_phases(fst_c,snd_c) = shift;
    cluster_phases(snd_c, fst_c) = shift;
end

end
