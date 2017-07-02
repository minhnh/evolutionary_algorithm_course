function child = SinglePointCrossover(parents)
    numGene = size(parents, 2);
    midPoint = int16(numGene / 2);
    child = -ones(1, numGene);
    child(1 : midPoint) = parents(1, 1 : midPoint);
    parent2 = parents(2, :);
    child(midPoint + 1 : numGene) = parent2(~ismember(parent2, child));
end
