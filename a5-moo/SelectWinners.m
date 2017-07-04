function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS Summary of this function goes here
%   Detailed explanation goes here
winners = NSGAII.CalculateObjectives(obj.Population, obj.Constraints.objectiveNames,...
                                     obj.Constraints.objectiveFunctions);

if isfield(obj.Constraints, 'oldPopulation')
    [ fronts, genomesWithRanks ] = NSGAII.DominationSort( [winners; obj.Constraints.oldPopulation] );
else
    obj.Constraints.oldPopulation = obj.Population;
end
    % perform NSGA
end

