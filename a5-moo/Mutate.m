function children = Mutate(~, children, mutationRate)
%MUTATE Summary of this function goes here
%   Detailed explanation goes here
numGene = length(children(1).Genome);
numGenome = length(children);
genomes = reshape(extractfield(children, 'Genome'), numGene, numGenome)';
childrenGenomes = double(GeneticEncoding.BinaryOperators.Mutate(genomes, mutationRate));

parfor i = 1:numGenome
    children(i).Genome = childrenGenomes(i, :);
end

end

