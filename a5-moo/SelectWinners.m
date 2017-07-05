function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS Summary of this function goes here
%   Detailed explanation goes here
offsprings = NSGAII.CalculateObjectives(obj.Population, obj.Constraints.objectiveNames,...
                                        obj.Constraints.objectiveFunctions);
winners = obj.Population;
if isfield(obj.Constraints, 'oldPopulation')
    [ fronts, genomesWithRanks ] = NSGAII.DominationSort( [offsprings; obj.Constraints.oldPopulation] );
    Visualization.VisualizeFronts2D(genomesWithRanks, fronts, obj.Constraints.objectiveNames);
    Visualization.gif;
    winnerIndex = 1;
    for i = 1:length(fronts)
        currentFront = fronts{i};
        frontSize = length(currentFront);
        if winnerIndex + frontSize - 1 > selection_size
            break;
        end
        for genomeIndex = currentFront
            winners(winnerIndex).Genome = genomesWithRanks(genomeIndex).Genome;
            winnerIndex = winnerIndex + 1;
        end
    end
    nextFront = fronts{i};
    for j = winnerIndex:selection_size
        winners(j).Genome = genomesWithRanks(nextFront(j + 1 - winnerIndex)).Genome;
    end
else
    obj.Constraints.oldPopulation = obj.Population;
end
    % perform NSGA
end

