function children = Crossover(obj, parents, crossoverParams)
%CROSSOVER Summary of this function goes here
%   Detailed explanation goes here
numGene = length(parents(1).Genome);
numGenome = length(parents);
genomes = reshape(extractfield(parents, 'Genome'), numGene, numGenome)';
childrenGenomes = GeneticEncoding.CrossoverBasic(obj, genomes, crossoverParams);
children = repmat(obj.Population(1), size(childrenGenomes, 1), 1);
parfor i = 1:numGenome
    children(i).Genome = childrenGenomes(i, :);
end

end

