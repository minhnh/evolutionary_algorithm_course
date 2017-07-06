function fitness = GetFitness(genomes, ~, constraints)
%GETFITNESS Summary of this function goes here
%   Detailed explanation goes here
    numGenome = length(genomes);
    fitness = zeros(numGenome, 1);
    for i = 1:numGenome
        currentFitness = 0;
        for j = 1:length(constraints.objectiveFunctions)
            objectiveFunc = constraints.objectiveFunctions{j};
            currentFitness = currentFitness + objectiveFunc(genomes(i).Genome);
        end
        fitness(i) = currentFitness;
    end
end

