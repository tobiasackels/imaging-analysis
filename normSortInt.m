function [ int_norm_sorted ] = normSortInt( experiment, cellsToPlot, odourToPlot )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(experiment.(cellsToPlot).allMod_Int_avg) % no of ROI
%     for j = 1:length(experiment.metaData.odours_labels) %no of odour
        int_norm(i,:) = (smooth(experiment.(cellsToPlot).allMod_Int_avg{i, 1}{1, odourToPlot}) - min(experiment.(cellsToPlot).allMod_Int_avg{i, 1}{1, odourToPlot})) / (max(experiment.(cellsToPlot).allMod_Int_avg{i, 1}{1, odourToPlot}) - min(experiment.(cellsToPlot).allMod_Int_avg{i, 1}{1, odourToPlot}));
%     end
end

[~, maxIdx] = max(int_norm, [], 2);
[maxIntSort, maxIdxSort] = sort(maxIdx);
int_norm_sorted = int_norm(maxIdxSort, :);


end

