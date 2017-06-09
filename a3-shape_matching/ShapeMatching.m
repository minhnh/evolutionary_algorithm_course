%% Solution for the Shape Matching problem using CMA-ES
% Author:   Minh Nguyen
% Date:     2017-05-25
%%
clear;clc;
NUM_GENE = 32;
POPULATION_SIZE = 15;
VERBOSE = false;
ELITISM = false; % built into weighted mean
NUM_ITERATION = 800;
NUM_TRIES = 5;

%% Precompute euclidean distance between cities
% Create a NACA foil
numEvalPts = 256;                            % Num evaluation points
nacaNum = [0, 0, 1, 2];                      % NACA Parameters
% nacaNum = [5, 5, 2, 2];                      % NACA Parameters
% nacaNum = [9, 7, 3, 5];                      % NACA Parameters
nacafoil = create_naca(nacaNum, numEvalPts); % Create foil
TARGET = nacafoil;

mu_ = POPULATION_SIZE / 2;
weights = mu_ + 1 - (1:mu_)';
%weights = log(mu_ + 1/2) - log(1:mu_)'; % wikipedia weight ratio
weights = weights / sum(weights);
mueff = 1 / sum(weights .^ 2);
CONSTRAINTS = struct('weights', weights,...
                     'mueff', mueff,...
                     'initialSigma', 0.5);

%% Initialize population
ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                  @CMAES.GeneratePopulation, @GetFitness,...
                                  @CMAES.SelectWinners, @CMAES.Crossover,...
                                  @CMAES.Mutate, @CheckConvergence,...
                                  VERBOSE);
% start timer
tic
VisualizeFoil(ie.GetBestChild()', nacafoil, nacaNum, 1);
bestFitnessAllTries = zeros(NUM_TRIES, NUM_ITERATION + 1);
bestChildren = zeros(NUM_TRIES, NUM_GENE);
parfor i = 1:NUM_TRIES
    tic
    ie.funcInitPopulation(ie, POPULATION_SIZE, NUM_GENE, CONSTRAINTS);
    population = ie.Population;
    [bestFitness, ~, ~] = ie.Iterate(NUM_ITERATION, ELITISM, -1, -1);
    bestFitnessAllTries(i, :) = bestFitness;
    bestChildren(i, :) = ie.GetBestChild();
    toc
end
medianBestFitness = median(bestFitnessAllTries, 1);
[~, argMax] = max(GetFitness(bestChildren, TARGET, CONSTRAINTS));
bestChild = bestChildren(argMax, :);
VisualizeFoil(bestChild', nacafoil, nacaNum, 2);
% time
toc
% save data
save('./median_fitness.mat',...
     'bestFitnessAllTries', 'medianBestFitness', 'bestChild', 'bestChildren');

%% Functions specific to Shape Matching problem
function converging = CheckConvergence(~)
    converging = false;
end