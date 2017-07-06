function genomesWithRanks = crowdingDistance(obj, currentFront, genomesWithRanks)

frontSize = length(currentFront);
population = genomesWithRanks;
numObjectives = length(obj.Constraints.objectiveNames);
maxFitIdeal = length(genomesWithRanks(1).Genome);

for ind = 1:frontSize
    population(currentFront(ind)).dist = 0;
end

for nObj = 1:numObjectives
    sortedFront =  sortByObjective(population(currentFront), obj.Constraints.objectiveNames{nObj});
    [sortedFront(1).dist, sortedFront(frontSize).dist] = deal(inf);
    fitObjID = obj.Constraints.objectiveNames{nObj};
    for j = 2:frontSize-1
        sortedFront(j).dist = population(j).dist +...
            (sortedFront(j-1).(fitObjID) - sortedFront(j+1).(fitObjID))/maxFitIdeal;
    end
    for k = 1:frontSize
        genomesWithRanks(currentFront(k)).dist = sortedFront(k).dist;
    end
end

end

function population = sortByObjective(population, objective)
[~, sortIDs] = sort(extractfield(population, objective));
population = population(sortIDs);
end