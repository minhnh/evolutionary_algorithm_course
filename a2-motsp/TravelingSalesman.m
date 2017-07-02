%% Solution for the Traveling Salesman problem
% Author:   Minh Nguyen
% Date:     2017-05-01
%%
POPULATION_SIZE = 100;
VERBOSE = false;
TARGET = 0;
ELITISM = true;
NUM_ITERATION = 1000;
NUM_TRIES = 30;
cities = importdata('cities.csv');
coords = cities.data(:, 2:3);
numCities = size(coords, 1);

%% Precompute euclidean distance between cities
distances = PrecomputeDistance(coords);
CONSTRAINTS = distances;
NUM_GENE = numCities;

%% Initialize population
ie = GeneticEncoding.PermutationEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                         @GeneratePopulation, @GetFitness,...
                                         @SelectWinners,...
                                         @GeneticEncoding.GeneticOperators.CrossoverRandPerm,...
                                         @GeneticEncoding.GeneticOperators.MutateOrderChange,...
                                         @CheckConvergence,...
                                         VERBOSE);
population = ie.Population;
% start timer
tic
% RandomCrossover & MutateOrderChange
VisualizeCities(coords, ie.GetBestChild(), 1);
bestFitness1 = zeros(NUM_TRIES, NUM_ITERATION + 1);
bestChildren1 = zeros(NUM_TRIES, NUM_GENE);
parfor i = 1:NUM_TRIES
    set(ie, 'Population', population);
    [bestFitness, ~, ~] = ie.Iterate(NUM_ITERATION, ELITISM, 0.9, 0.02);
    bestFitness1(i, :) = bestFitness;
    bestChildren1(i, :) = ie.GetBestChild();
end
medianBestFitness1 = median(bestFitness1, 1);
[~, argMax] = max(GetFitness(bestChildren1, 0, distances));
bestChild1 = bestChildren1(argMax, :);
VisualizeCities(coords, bestChild1, 2);
% time
toc

% RandomCrossover & MutateSwitchNeighbor
bestFitness2 = zeros(NUM_TRIES, NUM_ITERATION + 1);
bestChildren2 = zeros(NUM_TRIES, NUM_GENE);
set(ie, 'funcMutate', @GeneticEncoding.GeneticOperators.MutateSwitchNeighbor)
parfor i = 1:NUM_TRIES
    set(ie, 'Population', population);
    [bestFitness, ~, ~] = ie.Iterate(NUM_ITERATION, ELITISM, 0.9, 0.02);
    bestFitness2(i, :) = bestFitness;
    bestChildren2(i, :) = ie.GetBestChild();
end
medianBestFitness2 = median(bestFitness2, 1);
[~, argMax] = max(GetFitness(bestChildren2, 0, distances));
bestChild2 = bestChildren2(argMax, :);
VisualizeCities(coords, bestChild2, 3);
% time
toc

% CycleCrossover & MutateSwitchNeighbor
bestFitness3 = zeros(NUM_TRIES, NUM_ITERATION + 1);
bestChildren3 = zeros(NUM_TRIES, NUM_GENE);
set(ie, 'funcSingleCrossover', @GeneticEncoding.GeneticOperators.CrossoverCycle)
parfor i = 1:NUM_TRIES
    set(ie, 'Population', population);
    [bestFitness, ~, ~] = ie.Iterate(NUM_ITERATION, ELITISM, 0.9, 0.02);
    bestFitness3(i, :) = bestFitness;
    bestChildren3(i, :) = ie.GetBestChild();
end
medianBestFitness3 = median(bestFitness3, 1);
[~, argMax] = max(GetFitness(bestChildren3, 0, distances));
bestChild3 = bestChildren3(argMax, :);
VisualizeCities(coords, bestChild3, 4);
% time
toc

% CycleCrossover & MutateOrderChange
bestFitness4 = zeros(NUM_TRIES, NUM_ITERATION + 1);
bestChildren4 = zeros(NUM_TRIES, NUM_GENE);
set(ie, 'funcMutate', @GeneticEncoding.GeneticOperators.MutateOrderChange)
parfor i = 1:NUM_TRIES
    set(ie, 'Population', population);
    [bestFitness, ~, ~] = ie.Iterate(NUM_ITERATION, ELITISM, 0.9, 0.02);
    bestFitness4(i, :) = bestFitness;
    bestChildren4(i, :) = ie.GetBestChild();
end
medianBestFitness4 = median(bestFitness4, 1);
[~, argMax] = max(GetFitness(bestChildren4, 0, distances));
bestChild4 = bestChildren4(argMax, :);
VisualizeCities(coords, bestChild4, 5);
% time
toc

save('./a2-motsp/median_fitness.mat',...
     'bestFitness1', 'medianBestFitness1', 'bestChild1',...
     'bestFitness2', 'medianBestFitness2', 'bestChild2',...
     'bestFitness3', 'medianBestFitness3', 'bestChild3',...
     'bestFitness4', 'medianBestFitness4', 'bestChild4');


%% Helper Functions for TSP
function distances = PrecomputeDistance(coords)
    distances = squareform(pdist(coords, 'euclidean'));
end

function GeneratePopulation(obj, populationSize, numGene, ~)
    population = zeros(populationSize, numGene);
    for i = 1:populationSize
        population(i, :) = randperm(numGene);
    end
    set(obj, 'Population', population);
end

function winners = SelectWinners(obj, selection_size)
    winners = zeros(selection_size, obj.NumGene);
    for i = 1:selection_size
        parentIndices = randperm(size(obj.Population, 1), 2);
        parents = obj.Population(parentIndices, :);
        fitness = obj.funcGetFitness(parents, obj.Target, obj.Constraints);
        [~, maxArg] = max(fitness);
        winners(i, :) = parents(maxArg, :);
    end
end

function converging = CheckConvergence(~)
    converging = false;
end
