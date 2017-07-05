function VisualizeFronts2D( genomes, fronts, objectiveNames )
%VISUALIZEFRONTS2D Summary of this function goes here
%   Detailed explanation goes here
assert(length(objectiveNames) == 2, 'VisualizeFronts2D only work for 2 objectives');
cla; hold on;
colors = copper(length(fronts));
for frontIndex = 1:length(fronts)
    objectiveFitness1 = extractfield(genomes, objectiveNames{1});
    objectiveFitness2 = extractfield(genomes, objectiveNames{2});
    plot(objectiveFitness1(fronts{frontIndex}), objectiveFitness2(fronts{frontIndex}),...
         'o-.', 'linewidth', 1, 'markersize', 10, 'MarkerFaceColor', colors(frontIndex, :),...
         'MarkerEdgeColor', colors(frontIndex, :));
end
hold off;

end

