function populationWithObjectives = CalculateObjectives(population, constraints)
%CALCULATEOBJECTIVES Summary of this function goes here
%   Detailed explanation goes here
numObjective = length(constraints.objectiveFunctions);
populationWithObjectives = population;
for i = 1:length(population)
    for j = 1:numObjective
        objectiveFunc = constraints.objectiveFunctions{j};
        objectiveFitness = objectiveFunc(population(i).Genome, constraints);
        populationWithObjectives(i).(constraints.objectiveNames{j}) = objectiveFitness;
    end
end

end

