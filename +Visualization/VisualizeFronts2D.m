function VisualizeFronts2D(genomes, fronts, selectedIndices, objectiveNames)
%VISUALIZEFRONTS2D Summary of this function goes here
%   Detailed explanation goes here
assert(length(objectiveNames) == 2, 'VisualizeFronts2D only work for 2 objectives');
cla; hold on; gcf;
objectiveFitness1 = extractfield(genomes, objectiveNames{1});
objectiveFitness2 = extractfield(genomes, objectiveNames{2});
for frontIndex = 1:length(fronts)
    curObjective1 = objectiveFitness1(fronts{frontIndex});
    curObjective2 = objectiveFitness2(fronts{frontIndex});
    [~, sortedIdx] = sort(curObjective1);
    plot(curObjective1(sortedIdx), curObjective2(sortedIdx),...
         '.-.', 'linewidth', 1, 'markersize', 60);
end
Visualization.gif;

scatter(objectiveFitness1(selectedIndices), objectiveFitness2(selectedIndices), 70, 'og');
discardedIndices = 1:length(genomes);
discardedIndices = discardedIndices(~ismember(discardedIndices, selectedIndices));
scatter(objectiveFitness1(discardedIndices), objectiveFitness2(discardedIndices), 70, 'xr')
Visualization.gif;

hold off;

end

