function [ fronts, genomesWithRanks ] = DominationSort( genomes, objectiveNames )
%DOMINATIONSORT Summary of this function goes here
%   Detailed explanation goes here
numGenome = length(genomes);
numObjective = length(objectiveNames);
objectiveFitness = zeros(numGenome, numObjective);
for i = 1:numObjective
    objectiveFitness(:, i) = extractfield(genomes, objectiveNames{i});
end

genomesWithRanks = genomes;
bestFront = [];
for p = 1:numGenome
    lestFitSet = [];
    moreFitCount = 0;
    for q = 1:numGenome
        if IsDominant(p, q, objectiveFitness)
            lestFitSet = [lestFitSet, q];
        elseif IsDominant(q, p, objectiveFitness)
            moreFitCount = moreFitCount + 1;
        end
    end
    if moreFitCount == 0
        bestFront = [bestFront, p];
        genomesWithRanks(p).rank = 1;
    end
    genomesWithRanks(p).lestFitSet = lestFitSet;
    genomesWithRanks(p).moreFitCount = moreFitCount;
end

fronts = {};
i = 1;
currentFront = bestFront;
while ~isempty(currentFront)
    nextFront = [];
    for p = currentFront
        lestFitSet = genomesWithRanks(p).lestFitSet;
        for q = lestFitSet
            genomesWithRanks(q).moreFitCount = genomesWithRanks(q).moreFitCount - 1;
            if genomesWithRanks(q).moreFitCount == 0
                genomesWithRanks(q).rank = i + 1;
                nextFront = [nextFront, q];
            end
        end
    end
    i = i + 1;
    fronts = [fronts; currentFront];
    currentFront = nextFront;
end

end

function isDominant = IsDominant(firstIndex, secondIndex, objectiveFitness)
    firstFitness = objectiveFitness(firstIndex, :);
    secondFitness = objectiveFitness(secondIndex, :);
    isDominant = any(firstFitness > secondFitness) && all(firstFitness >= secondFitness);
end

