function [ fronts, genomesWithRanks ] = DominationSort( genomes )
%DOMINATIONSORT Summary of this function goes here
%   Detailed explanation goes here
numGenome = length(genomes);

genomesWithRanks = genomes;
bestFront = [];
for p = 1:numGenome
    lestFitSet = [];
    moreFitCount = 0;
    for q = 1:numGenome
        if genomesWithRanks(p).fitness > genomesWithRanks(q).fitness
            lestFitSet = [lestFitSet, q];
        elseif genomesWithRanks(p).fitness < genomesWithRanks(q).fitness
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

