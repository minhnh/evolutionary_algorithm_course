function genomesWithRanks = crowdingDistance(genomesWithRanks, currentFront, objectiveNames)

frontSize = length(currentFront);
population = genomesWithRanks;
numObjectives = length(objectiveNames);
maxFitIdeal = length(genomesWithRanks(1).Genome);

for ind = 1:frontSize
    population(currentFront(ind)).dist = 0;
end

for nObj = 1:numObjectives
    currentObjectiveName = objectiveNames{nObj};
    sortedFront =  sortByObjective(population(currentFront), currentObjectiveName);
    [sortedFront(1).dist, sortedFront(frontSize).dist] = deal(inf);
    for j = 2:frontSize-1
        sortedFront(j).dist = population(j).dist...
                              + (sortedFront(j-1).(currentObjectiveName)...
                                 - sortedFront(j+1).(currentObjectiveName)) / maxFitIdeal;
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