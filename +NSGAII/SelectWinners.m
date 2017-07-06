function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS Summary of this function goes here
%   Detailed explanation goes here
offsprings = NSGAII.CalculateObjectives(obj.Population, obj.Constraints.objectiveNames,...
    obj.Constraints.objectiveFunctions);
winners = obj.Population;
if isfield(obj.Constraints, 'oldPopulation')
    [fronts, genomesWithRanks] = NSGAII.DominationSort([offsprings; obj.Constraints.oldPopulation],...
                                                       obj.Constraints.objectiveNames);
    selectedIndices = zeros(selection_size, 1);
    winnerIndex = 1;
    for i = 1:length(fronts)
        currentFront = fronts{i};
        frontSize = length(currentFront);
        if winnerIndex + frontSize - 1 > selection_size
            break;
        end
        for genomeIndex = currentFront
            winners(winnerIndex).Genome = genomesWithRanks(genomeIndex).Genome;
            selectedIndices(winnerIndex) = genomeIndex;
            winnerIndex = winnerIndex + 1;
        end
    end
    currentFront = fronts{i};
    genomesWithRanks = NSGAII.CrowdingDistance(genomesWithRanks, currentFront,...
                                        obj.Constraints.objectiveNames);
    % Sorting based on partial order
    currentFront =  partialOrderSort(currentFront, genomesWithRanks);

    % Append best from current front to winners until filled
    num2Fill = selection_size - (winnerIndex - 1);
    for addRestID = 1 : num2Fill
        winners(winnerIndex).Genome = genomesWithRanks(currentFront(addRestID)).Genome;
        selectedIndices(winnerIndex) = currentFront(addRestID);
        winnerIndex = winnerIndex + 1;
    end

    Visualization.VisualizeFronts2D(genomesWithRanks, fronts, selectedIndices,...
                                    obj.Constraints.objectiveNames);
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

