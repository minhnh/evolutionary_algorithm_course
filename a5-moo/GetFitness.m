function fitness = GetFitness(genomes, targetFitness, Constraints)
%GETFITNESS Summary of this function goes here
%   Detailed explanation goes here
    numGenome = size(genomes, 1);
    fitness = zeros(numGenome, 1);
    parfor i = 1:numGenome
        fitness(i) = genomes(i).numLeadingZeros + genomes(i).numTrailingOnes;
    end
end

