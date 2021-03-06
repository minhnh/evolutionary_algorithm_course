function child = CrossoverRandPerm(parents)
    numGene = size(parents, 2);
    numChange = int16(numGene / 2);
    child = -ones(1, numGene);
    changeIndices = randperm(numGene, numChange);
    child(changeIndices) = parents(1, changeIndices);
    child(child == -1) = parents(2, ~ismember(parents(2, :), child));
end
