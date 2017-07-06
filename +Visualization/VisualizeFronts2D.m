function VisualizeFronts2D( genomes, fronts, selectedFronts, rejectedFronts, objectiveNames )
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

for frontIndex = 1:length(selectedFronts)
    Obj1 = objectiveFitness1(selectedFronts{frontIndex});
    Obj2 = objectiveFitness2(selectedFronts{frontIndex});
    [~, sortedIdx] = sort(Obj1);
    scatter(Obj1(sortedIdx), Obj2(sortedIdx), 50, 'g');
end

for frontIndex = 1:length(rejectedFronts)
    rObj1 = objectiveFitness1(rejectedFronts{frontIndex});
    rObj2 = objectiveFitness2(rejectedFronts{frontIndex});
    [~, sortedIdx] = sort(rObj1);
    scatter(rObj1(sortedIdx), rObj2(sortedIdx), 50, 'r', 'x');
end
hold off;

end

