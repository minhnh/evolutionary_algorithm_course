function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS sort population by fitness
    fitness = obj.funcGetFitness(obj.Population, obj.Target, -1);
    [~, sortedFitnessIndices] = sort(fitness, 'descend');
    obj.Population = obj.Population(sortedFitnessIndices, :);
    winners = obj.Population(1:selection_size, :);
end

