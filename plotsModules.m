%% Plots
close all

experiment = analysis_C432;
cellsToPlot = 'MC'; % change cellType
odourToPlot = 31; % No of odour
ROIToPlot = 1; % No of cell-odor parit

clear MC TC

%% Split data according to cell type (TC or MC)

for i = 1:length(experiment.metaData.cellTypeIdx)
    experiment.allMod_Int_avg(i,:) = {[experiment.imagingData.allMod_Int_corr_aligned_avg{i,:}]};
    experiment.allMod_Int_std(i,:) = {[experiment.imagingData.allMod_Int_corr_aligned_std{i,:}]};
    experiment.allMod_Int_SEM(i,:) = {[experiment.imagingData.allMod_Int_corr_aligned_SEM{i,:}]};
    experiment.allModIntegral(i,:) = {experiment.imagingData.integral5s};
    experiment.allMod_Integral_avg(i,:) = {[experiment.imagingData.allMod_Integral_avg{i,:}]};
    experiment.allMod_Integral_std(i,:) = {[experiment.imagingData.allMod_Integral_std{i,:}]};
    experiment.temp(i,:) = {[experiment.respROIsData.respROIs{i,:}]};
end

for i = 1:length(experiment.temp) % no of ROI 
    for j = 1:size(experiment.temp{i,1},2)
        experiment.respROIs(i,j)  = experiment.temp{i,1}{1,j};
            if experiment.metaData.cellTypeIdx{i,1} == 'MC'
            MC(i) = i;
            elseif experiment.metaData.cellTypeIdx{i,1} == 'TC'
            TC(i) = i;
            end
    end
end

test = exist('TC');
if test == 7
   TC = '';
end

MC(MC==0) = [];
TC(TC==0) = [];


for i = 1:length(TC)
    experiment.TC.respROIs(i,:) = experiment.respROIs(TC(i),:);
    experiment.TC.allMod_Int_avg(i,:) = experiment.allMod_Int_avg(TC(i));     
    experiment.TC.allMod_Int_std(i,:) = experiment.allMod_Int_std(TC(i));
    experiment.TC.allMod_Int_SEM(i,:) = experiment.allMod_Int_SEM(TC(i));
    experiment.TC.allModIntegral(i,:) = experiment.allModIntegral(TC(i));
    experiment.TC.allMod_Integral_avg(i,:) = experiment.allMod_Integral_avg(TC(i));
    experiment.TC.allMod_Integral_std(i,:) = experiment.allMod_Integral_std(TC(i));
    experiment.TC.allMod_Integral_avg_mat(i,:) = experiment.imagingData.allMod_Integral_avg_mat(TC(i),:);    
end
for i = 1:length(MC)
    experiment.MC.respROIs(i,:) = experiment.respROIs(MC(i),:);
    experiment.MC.allMod_Int_avg(i,:) = experiment.allMod_Int_avg(MC(i));     
    experiment.MC.allMod_Int_std(i,:) = experiment.allMod_Int_std(MC(i));
    experiment.MC.allMod_Int_SEM(i,:) = experiment.allMod_Int_SEM(MC(i));
    experiment.MC.allModIntegral(i,:) = experiment.allModIntegral(MC(i));
    experiment.MC.allMod_Integral_avg(i,:) = experiment.allMod_Integral_avg(MC(i));
    experiment.MC.allMod_Integral_std(i,:) = experiment.allMod_Integral_std(MC(i));
    experiment.MC.allMod_Integral_avg_mat(i,:) = experiment.imagingData.allMod_Integral_avg_mat(MC(i),:);
end

% Extract responsive ROIs
experiment.(cellsToPlot).respROIs_mat = experiment.(cellsToPlot).respROIs;
experiment.(cellsToPlot).respROIs_sum = sum(experiment.(cellsToPlot).respROIs);
experiment.(cellsToPlot).respROIs_sum(experiment.(cellsToPlot).respROIs_sum < 0) = 0;
experiment.(cellsToPlot).respROIs_ratio = (experiment.(cellsToPlot).respROIs_sum/size(experiment.(cellsToPlot).respROIs,1))*100;

experiment = rmfield(experiment,'temp');


%% dFoverF heatmap of all cellsToPlot for odourToPlot

int_norm_sorted = normSortInt(experiment, cellsToPlot, odourToPlot);

figure('pos',[950 590 350 400]) 
imagesc(int_norm_sorted)
h = colorbar;
set(h, 'ylim', [0 1])
ylabel(h, 'normalized dF/F')
xlabel('Time (s)')
ylabel(['Cell-odor pair  n=' num2str(size(int_norm_sorted,1))])
colormap(cmap_dFoverF)
ax = gca;
ax.XTick = [1:5:72];
ax.YTick = [];
ax.XTickLabel = [-3:11];
ax.YTickLabel = [];
set(gca, 'XTick', ax.XTick, 'XTickLabel', ax.XTickLabel, 'YTick', ax.YTick, 'YTickLabel', ax.YTickLabel);
% title([num2str(cellsToPlot), ' | ' experiment.metaData.odours_labels{odourToPlot} ' | ' num2str(experiment.metaData.experiment{1, 1})])
title([num2str(cellsToPlot), ' | ' experiment.metaData.odours_labels{odourToPlot}])

%% Plot response integrals

[cmap_dFoverF, cmap_Integrals, cmap_respROIs] = colorMaps(experiment, cellsToPlot);

figure('pos',[10 490 900 500]) 
image(experiment.(cellsToPlot).allMod_Integral_avg_mat ,'CDataMapping','scaled')
colormap(cmap_Integrals')
colorbar
ylabel('Cell-odour pair')
title([num2str(cellsToPlot), ' | ' 'response Integrals'])
h = colorbar;
set(h, 'ylim', [min(min(experiment.(cellsToPlot).allMod_Integral_avg_mat))*2 max(max(experiment.(cellsToPlot).allMod_Integral_avg_mat))*2])
set(gca, 'XTick',1:size(experiment.metaData.odours_labels,2),'XTickLabel', experiment.metaData.odours_labels, 'XTickLabelRotation',90);

%% Plots of responsive ROIs

figure('pos',[950 50 350 300]) 
image(experiment.(cellsToPlot).respROIs_mat,'CDataMapping','scaled')
colormap(cmap_respROIs)
h = colorbar;
set(h, 'ylim', [-1 1])
ylabel(h, 'dF/F * ')
delete(h);
ylabel(['Cell-odor pair  n=' num2str(size(int_norm_sorted,1))])
xlabel('Odour')
% set(gca, 'XTick',1:size(experiment.metaData.odours_labels,2),'XTickLabel', experiment.metaData.odours_labels, 'XTickLabelRotation',90);
title([num2str(cellsToPlot), ' | ' 'Responsive Cell-odour pairs'])

figure('pos',[10 50 900 500])
scatter([1:size(experiment.(cellsToPlot).respROIs_ratio,2)],experiment.(cellsToPlot).respROIs_ratio, 'filled', 'k')
axis([0 size(experiment.(cellsToPlot).respROIs_mat,2) 0 100])
title([num2str(cellsToPlot), ' | ' 'Responsive Cell-odour pairs ratio'])
ylabel('% responsive cell-odour pairs')
set(gca, 'XTick',1:size(experiment.metaData.odours_labels,2),'XTickLabel', experiment.metaData.odours_labels, 'XTickLabelRotation',90);

%% Plot averages

% for i = 1:length(experiment.(cellsToPlot).allMod_Int_avg) % no of ROI
%     c = 1;
% %     figure('units','normalized','outerposition',[0.02 -0.02 0.98 0.98])
%     figure 
%     pause(0.00001);
%     frame_h = get(handle(gcf),'JavaFrame');
%     set(frame_h,'Maximized',1); 
%     warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
% 
%     suptitle([cellsToPlot ' ' num2str(i)])
%         for j = 1:size(experiment.(cellsToPlot).allMod_Int_avg{i,1},2) % no of odour
%             subaxis(8,6, c, 'Spacing', 0.04, 'Padding', 0, 'Margin', 0.03)
%             hold on
%             bar(1, max(experiment.(cellsToPlot).allMod_Int_avg{i,1}{1,j})+0.5, 2, 'FaceColor', [.15 .68 1]);
%             
%             shadedErrorBar(experiment.imagingData.time_downsample(1:72), smooth(experiment.(cellsToPlot).allMod_Int_avg{i,1}{1,j}(1:72), 0.03, 'moving'), experiment.(cellsToPlot).allMod_Int_SEM{i,1}{1,j}(1:72),'k')
% 
%             xlabel('time (sec)')
%             ylabel([(experiment.metaData.odours_labels(c)) 'dF/F'])
%             axis([-3 11 -inf inf])
%             if j < 43
%             set(gca,'xlabel',[], 'xticklabel', []) 
%             end
%             c = c+1;
%         end
% end

%% dFoverF heatmap of all cellsToPlot for odourToPlot

corrMatrix = corrcoef(experiment.(cellsToPlot).respROIs);
for i = 1:size(experiment.metaData.odours_labels,2)
    corrMatrix(i,i) = 1;
end
corrMatrix(isnan(corrMatrix)) = 0;

figure('pos',[1330 50 350 300]) 
imagesc(corrMatrix)
colormap('jet')
h = colorbar;
set(h, 'ylim', [min(min(corrMatrix)) 1])
ylabel(h, 'Correlation')
xlabel('Odour \rightarrow')
ylabel('\leftarrow Odour')
title([num2str(cellsToPlot), ' | ' num2str(experiment.metaData.experiment{1, 1})])

%%
clear test i j h ax