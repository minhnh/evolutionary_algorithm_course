function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS Summary of this function goes here
%   Detailed explanation goes here
offsprings = NSGAII.CalculateObjectives(obj.Population, obj.Constraints.objectiveNames,...
                                        obj.Constraints.objectiveFunctions);
winners = obj.Population;
if isfield(obj.Constraints, 'oldPopulation')
    [fronts, genomesWithRanks] = NSGAII.DominationSort([offsprings; obj.Constraints.oldPopulation],...
                                                       obj.Constraints.objectiveNames);
    Visualization.VisualizeFronts2D(genomesWithRanks, fronts, obj.Constraints.objectiveNames);
    Visualization.gif;
    winIndex = 1;
    selectedIndices = zeros(selection_size);
    for j = 1:length(fronts)
        currentFront = fronts{j};
        while (winIndex + length(currentFront) <= selection_size)
            for i = 1:length(currentFront)
                winners(winIndex).Genome = genomesWithRanks(currentFront(i)).Genome;
                selectedIndices(winIndex) = currentFront(i);
                winIndex = winIndex + 1;
            end
        end
        genomesWithRanks = crowdingDistance(genomesWithRanks, currentFront,...
                                            obj.Constraints.objectiveNames);
        % Sorting based on partial order
        currentFront = partialOrderSort(currentFront, genomesWithRanks);
        
        % Append best from current front to winners until filled
        if winIndex < selection_size
            for addRestID = 1 : selection_size - (winIndex - 1)
                selectedIndices(winIndex) = currentFront(addRestID);
                winners(winIndex).Genome = genomesWithRanks(currentFront(addRestID)).Genome;
                winIndex = winIndex + 1;
            end
        end
    end
else
    obj.Constraints.oldPopulation = obj.Population;
end

end

function currentFront =  partialOrderSort(currentFront, genomesWithRanks)
frontSize = length(currentFront);
for i = 1:frontSize
    if i < frontSize
        if genomesWithRanks(currentFront(i)).rank < genomesWithRanks(currentFront(i+1)).rank
            [currentFront(i), currentFront(i+1)] = deal(currentFront(i+1), currentFront(i));
        elseif genomesWithRanks(currentFront(i)).rank == genomesWithRanks(currentFront(i+1)).rank
            if genomesWithRanks(currentFront(i)).dist > genomesWithRanks(currentFront(i+1)).dist
                [currentFront(i), currentFront(i+1)] = deal(currentFront(i+1), currentFront(i));
            end
        end
    end
end
end

