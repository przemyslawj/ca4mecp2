function plotTrace( trace, threshold, cell_peaks)
timeaxis = (1:1600) / 3;
plot(timeaxis,trace, 'b');
hold on; 
plot([0 numel(trace)], [threshold threshold], 'r--');
for j=1:size(cell_peaks,1)
    x = cell_peaks(j).start_index:cell_peaks(j).end_index;
    plot(x / 3, trace(x), 'r');
end
hold off;
xlabel('Time (seconds)');
ylabel('ΔF/F');
xlim([0 max(timeaxis)]);
end

