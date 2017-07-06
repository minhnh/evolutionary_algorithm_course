function populationWithObjectives = CalculateObjectives(population, objectiveNames,...
                                                        objectiveFunctions)
%CALCULATEOBJECTIVES Summary of this function goes here
%   Detailed explanation goes here
numObjective = length(objectiveFunctions);
populationWithObjectives = population;
for i = 1:length(population)
    for j = 1:numObjective
        objectiveFunc = objectiveFunctions{j};
        objectiveFitness = objectiveFunc(population(i).Genome);
        populationWithObjectives(i).(objectiveNames{j}) = objectiveFitness;
    end
end

end

