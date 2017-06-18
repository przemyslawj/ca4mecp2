function [coeff, inner_corrs, outer_corrs] = clusterCoeff(corrs, clusters)
%inter_cluster vs outer_cluster

    cluster_count = max(clusters);
    inner_corrs = zeros(cluster_count,1);
    outer_corrs = zeros(cluster_count,1);
    for cluster = 1:cluster_count
        idx = find(clusters == cluster);
        nidx = numel(idx);
        if nidx == 1
            inner_corrs(cluster) = 1;
        else
            group_corrs = corrs(idx,idx) - eye(nidx);
            inner_corrs(cluster) = sum(group_corrs(:)) / (nidx^2 - nidx);
        end
        no_idx = setdiff(1:size(corrs,1), idx);
        nno_idx = numel(no_idx);
        outer_corrs_m = corrs(idx,no_idx);
        outer_corrs(cluster) = sum(outer_corrs_m(:)) / (nidx * nno_idx);
    end
    
    coeff = norm(inner_corrs - outer_corrs) / cluster_count;
end

