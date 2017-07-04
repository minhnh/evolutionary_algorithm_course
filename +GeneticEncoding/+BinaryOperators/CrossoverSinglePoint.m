function child = CrossoverSinglePoint(parents)
    numGene = size(parents, 2);
    crossoverPoint = randi(numGene - 1);
    child = -ones(1, numGene);
    child(1 : crossoverPoint) = parents(1, 1 : crossoverPoint);
    child(crossoverPoint + 1 : numGene) = parents(2, crossoverPoint + 1 : numGene);
end
