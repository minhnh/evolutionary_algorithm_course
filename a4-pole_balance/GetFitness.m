function fitness = GetFitness(genomes, targetFitness, Constraints)
%GETFITNESS Fitness function for function pole balancing problem
    fitness = zeros(length(genomes), 1);
    networkFunction = Constraints.NetworkFunction;
    parfor i = 1: length(genomes)
        connectionMatrix = NEAT.GetConnectionMatrix(genomes(i).ConnectionGenes,...
                                                    size(genomes(i).NodeGenes, 2));
        fitness(i) = twoPole_test(connectionMatrix, networkFunction, targetFitness);
    end
end
