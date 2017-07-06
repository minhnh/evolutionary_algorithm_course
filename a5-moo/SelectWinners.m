function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS Summary of this function goes here
%   Detailed explanation goes here
offsprings = NSGAII.CalculateObjectives(obj.Population, obj.Constraints.objectiveNames,...
    obj.Constraints.objectiveFunctions);
winners = obj.Population;
if isfield(obj.Constraints, 'oldPopulation')
    [fronts, genomesWithRanks] = NSGAII.DominationSort([offsprings; obj.Constraints.oldPopulation],...
        obj.Constraints.objectiveNames);
    winID = 1; selectedIDs = []; rejectedIDs = []; rejFrontID = 2;
    for j = 1:length(fronts)
        currentFront = fronts{j};
        if (winID + length(currentFront) <= selection_size)
            selectedIDs{j} = currentFront;
            for i = 1:length(currentFront)
                winners(winID).Genome = genomesWithRanks(currentFront(i)).Genome;
                winners(winID).numLeadingZeros = genomesWithRanks(currentFront(i)).numLeadingZeros;
                winners(winID).numTrailingOnes = genomesWithRanks(currentFront(i)).numTrailingOnes;
                winners(winID).fitness = genomesWithRanks(currentFront(i)).fitness;
                winID = winID + 1;
            end
        elseif winID-1 < selection_size
            genomesWithRanks = crowdingDistance(obj, currentFront, genomesWithRanks);
            % Sorting based on partial order
            currentFront =  partialOrderSort(currentFront, genomesWithRanks);
            % Append best from current front to winners until filled
            num2Fill = selection_size - (winID - 1);
            selectedIDs{j} = currentFront(1:num2Fill);
            rejectedIDs{1} = currentFront(num2Fill+1:end);
            for addRestID = 1 : num2Fill
                winners(winID).Genome = genomesWithRanks(currentFront(addRestID)).Genome;
                winners(winID).numLeadingZeros = genomesWithRanks(currentFront(addRestID)).numLeadingZeros;
                winners(winID).numTrailingOnes = genomesWithRanks(currentFront(addRestID)).numTrailingOnes;
                winners(winID).fitness = genomesWithRanks(currentFront(addRestID)).fitness;
                winID = winID + 1;
            end
        else
            rejectedIDs{rejFrontID} = currentFront; rejFrontID = rejFrontID + 1;
        end
    end
    Visualization.VisualizeFronts2D(genomesWithRanks, fronts, selectedIDs, rejectedIDs, obj.Constraints.objectiveNames);
    Visualization.gif;
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

