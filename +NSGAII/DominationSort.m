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
        if p == q
            continue;
        end
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

fronts = {bestFront};
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
    currentFront = nextFront;
    fronts = [fronts; nextFront];
end

end

function isDominant = IsDominant(firstIndex, secondIndex, objectiveFitness)
    firstFitnessVect = objectiveFitness(firstIndex, :);
    secondFitnessVect = objectiveFitness(secondIndex, :);
    isDominant = false;
    for firstFitness = objectiveFitness(firstIndex, :)
        for secondFitness = objectiveFitness(secondIndex, :)
            if firstFitness < secondFitness
                isDominant = false;
                return;
            end
            if firstFitness > secondFitness
                isDominant = true;
            end
        end
    end
%     isDominant = all(objectiveFitness(firstIndex, :) >= objectiveFitness(secondIndex, :))...
%                  && any(objectiveFitness(firstIndex, :) > objectiveFitness(secondIndex, :));
end

