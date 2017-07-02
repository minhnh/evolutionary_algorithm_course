function child = CrossoverSinglePoint(parents)
    numGene = size(parents, 2);
    crossoverPoint = randi(numGene - 1);
    child = -ones(1, numGene);
    child(1 : crossoverPoint) = parents(1, 1 : crossoverPoint);
    parent2 = parents(2, :);
    child(crossoverPoint + 1 : numGene) = parent2(~ismember(parent2, child));
end
