function GeneratePopulation(obj, populationSize, numGene, constraints)
%GENERATEPOPULATION Summary of this function goes here
%   Detailed explanation goes here

if ~isfield(constraints, 'objectiveFunctions')...
        || ~isfield(constraints, 'objectiveNames')...
        || ~isfield(constraints, 'getGenome')
    error(['GeneratePopulation function for NSGA-II requires constraints argument to have'...
           ' objectiveFunctions and Rate objectiveNames']);
end

numObjective = length(constraints.objectiveFunctions);
if numObjective ~= length(constraints.objectiveNames)
    error('length of objectiveNames and objectiveFunctions must equal');
end

population = repmat(struct(), populationSize, 1);
for i = 1:populationSize
    population(i).Genome = constraints.getGenome(numGene);
end
population = NSGAII.CalculateObjectives(population, constraints.objectiveNames,...
                                        constraints.objectiveFunctions);

set(obj, 'Population', population);

% obj.Population = obj.funcSelectWinners(obj, populationSize);

end

