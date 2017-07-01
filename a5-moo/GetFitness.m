function fitness = GetFitness(genomes, targetFitness, Constraints)
%GETFITNESS Summary of this function goes here
%   Detailed explanation goes here
    numGenome = size(genomes, 1);
    numGene = size(genomes, 2);
    fitness = zeros(numGenome, 1);
    parfor i = 1:numGenome
        numLeadingZeros = find(genomes(i, :), 1, 'first') - 1;
        numTrailingOnes = numGene - find(~genomes(i, :), 1, 'last');
        fitness(i) = numLeadingZeros + numTrailingOnes;
    end
end

