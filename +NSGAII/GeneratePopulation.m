function GeneratePopulation(obj, populationSize, numGene, constraints)
%GENERATEPOPULATION Summary of this function goes here
%   Detailed explanation goes here
    parfor i = 1:populationSize
        population(i).Genome = randi([0,1], 1, numGene);
    end
    
    set(obj, 'Population', population);
    obj.Population = obj.funcSelectWinners(obj, populationSize);
end

