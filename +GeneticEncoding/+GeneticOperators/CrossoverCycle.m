function child = CrossoverCycle(parents)
    numGene = size(parents, 2);
    cycleStart = 1;
    child = -ones(1, numGene);
    parentIndex = 0;
    while sum(ismember(child, -1)) > 0
        currentCycle = cycleStart;
        cycleEnd = cycleStart;
        while ~(parents(2, cycleEnd) == parents(1, cycleStart))
            parent2CycleEndValue = parents(2, cycleEnd);
            cycleEnd = find(ismember(parents(1, :), parent2CycleEndValue));
            currentCycle = [currentCycle, cycleEnd];
        end
        child(currentCycle) = parents(parentIndex + 1, currentCycle);
        parentIndex = ~parentIndex;
        for cycleStart = 1:numGene
            if child(cycleStart) == -1
                break;
            end
        end
    end
    child(child == -1) = parents(2, ~ismember(parents(2, :), child));
end
