function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS Use fitness proportional selection with Stochastic Universal Sampling for selection
    fitness = obj.funcGetFitness(obj.Population, obj.Target, obj.Constraints);
    cumNormFitnessVals = cumsum(fitness / sum(fitness));    % calculate normalized cumulative sum
    markers = rand + (1:selection_size)/selection_size;     % create evenly spaced markers with
                                                            % random starting point
    markers(markers > 1) = markers(markers > 1) - 1;        % wrap markers around 1
    [~, ~, parentIndices] = histcounts(markers, [0 cumNormFitnessVals']);
    parentIndices = parentIndices(randperm(selection_size));
    winners = obj.Population(parentIndices);
end

