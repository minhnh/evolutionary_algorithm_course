function children = MutateOrderChange(children, mutationRate)
    mutationMatrix = rand(size(children)) < mutationRate;
    numGenome = size(children, 1);
    numGene = size(children, 2);
    numSwap = sum(mutationMatrix, 2);
    for i = 1 : numGenome
        if numSwap(i) == 0
            continue;
        end
        for j = 1 : numGene
            if ~mutationMatrix(i, j)
                continue;
            end
            swapIndex = randi(numGene);
            swapTemp = children(i, swapIndex);
            children(i, swapIndex) = children(i, j);
            children(i, j) = swapTemp;
        end
    end
end
